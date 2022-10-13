package main

import (
	"fmt"
	"flag"
	"time"

	"go.uber.org/ratelimit"
	"github.com/jaswdr/faker"
)

var (
	flagTotalRateLimit = flag.Int("total-rate", 100, "Logs per second to emit total.")
	flagErrorRateLimit = flag.Int("error-rate", 10, "Logs per second to emit that are HTTP errors.")
	flagLeakRateLimit  = flag.Int("leak-rate", 1, "Logs per second to emit that leak credit card info.")

	f                  = faker.New()
	// ApacheCommonLog : {host} {user-identifier} {auth-user-id} [{datetime}] "{method} {request} {protocol}" {response-code} {bytes}
	ApacheCommonLog    = "%s - %s [%s] \"%s %s %s\" %d %d"
	ApacheTime         = "02/Jan/2006:15:04:05 -0700"
)

func init() {
	flag.Parse()
}

func generateApacheLogLine(status int) string {
	i := f.Internet()
	// TODO: generate a more storedog-related file path
	url := f.File().AbsoluteFilePath(3)
	t := time.Now()

	return fmt.Sprintf(
		ApacheCommonLog,
		i.Ipv4(),
		i.User(),
		t.Format(ApacheTime),
		"GET",
		url,
		"HTTP/1.1",
		status,
		f.UInt16(),
	)
}

func main() {
	totalRateLimit := ratelimit.New(*flagTotalRateLimit)
	errorRateLimit := ratelimit.New(*flagErrorRateLimit)
	leakRateLimit  := ratelimit.New(*flagLeakRateLimit)

	// Emit logs that are errors, first.
	go func(){
		time.Sleep(1 * time.Second)
		for {
			totalRateLimit.Take()
			errorRateLimit.Take()
			fmt.Println(generateApacheLogLine(500))
		}
	}()

	// Now emit logs that leak credit card info.
	go func(){
		time.Sleep(2 * time.Second)
		for {
			totalRateLimit.Take()
			errorRateLimit.Take()
			leakRateLimit.Take()

			// TODO: improve this to actually fit the Luhn algorithm?
			cc := f.Payment().CreditCardNumber()
			tid := f.Int()
			fmt.Printf("ERROR could not charge card %s for transaction %d\n", cc, tid)
			fmt.Println(generateApacheLogLine(504))
		}
	}()

	for {
		totalRateLimit.Take()
		fmt.Println(generateApacheLogLine(200))
	}
}