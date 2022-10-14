package main

import (
	"fmt"
	"flag"
	"time"

	"go.uber.org/ratelimit"
	"github.com/jaswdr/faker"
)

var (
	flagTotalRateLimit = flag.Int("total-rate", 250, "Logs per second to emit total.")
	flagSSHRateLimit   = flag.Int("ssh-rate", 30, "Logs per minute to emit for SSH connection attempts.")

	f                  = faker.New()
	i                  = f.Internet()
	// version account-id interface-id srcaddr dstaddr srcport dstport protocol packets bytes start end action log-status
	VPCFlowLogFormat   = "%d %s %s %s %s %d %d %d %d %d %d %d %s %s\n"

	// TODO: generate these at boot?
	accountID   = "1234567890"

	httpPort = 8080
)

func init() {
	flag.Parse()
}

func generateInterfaceID() string {
	return fmt.Sprintf("eni-%s", f.RandomStringWithLength(17))
}

// TODO: model more accurate traffic patterns
func generateWebTraffic() {
	start := time.Now().Add(time.Duration(f.IntBetween(-10, -1)) * time.Second)
	end := time.Now()

	clientIP := i.Ipv4()
	serverIP := i.LocalIpv4()
	clientPort := f.IntBetween(30000, 78000)
	requestBytes := f.IntBetween(230, 9000)
	requestPackets := f.IntBetween(5, 1000)

	responseBytes := f.IntBetween(80, 12000000)
	responsePackets := f.IntBetween(requestPackets, 2500)

	interfaceID := generateInterfaceID()
	action := "ACCEPT"
	status := "OK" // TODO: NODATA?

	fmt.Printf(
		VPCFlowLogFormat,
		2,
		accountID,
		interfaceID,
		clientIP,
		serverIP,
		clientPort,
		httpPort,
		6,
		requestPackets,
		requestBytes,
		start.Unix(),
		end.Unix(),
		action,
		status,
	)

	fmt.Printf(
		VPCFlowLogFormat,
		2,
		accountID,
		interfaceID,
		serverIP,
		clientIP,
		httpPort,
		clientPort,
		6,
		responsePackets,
		responseBytes,
		start.Unix(),
		end.Unix(),
		action,
		status,
	)
}

func generateSSHAttempt() {
	start := time.Now().Add(time.Duration(f.IntBetween(-5, -1)) * time.Second)
	end := time.Now()

	clientIP := i.Ipv4()
	serverIP := i.LocalIpv4()
	clientPort := f.IntBetween(30000, 78000)
	requestBytes := f.IntBetween(230, 900)
	requestPackets := f.IntBetween(5, 400000)

	action := "REJECT"
	status := "OK" // TODO: NODATA?

	fmt.Printf(
		VPCFlowLogFormat,
		2,
		accountID,
		generateInterfaceID(),
		clientIP,
		serverIP,
		clientPort,
		22,
		6,
		requestPackets,
		requestBytes,
		start.Unix(),
		end.Unix(),
		action,
		status,
	)
}

func main() {
	totalRateLimit := ratelimit.New(*flagTotalRateLimit)
	sshRateLimit := ratelimit.New(*flagSSHRateLimit, ratelimit.Per(time.Minute))

	go func(){
		for {
			totalRateLimit.Take()
			sshRateLimit.Take()
			generateSSHAttempt()
		}
	}()

	for {
		totalRateLimit.Take()
		generateWebTraffic()
	}
}