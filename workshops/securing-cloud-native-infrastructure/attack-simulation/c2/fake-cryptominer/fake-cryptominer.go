package main

import (
	"math"
	"net"
	"runtime"
	"strconv"
	"time"
)

func main() {
	// Fake DNS lookup
	println("Connecting to pool")
	net.LookupIP("pool.minexmr.com")

	// Eat all the CPU from half the CPUs
	println("Connection successful")
	numCpusToEat := int(math.Floor(float64(runtime.NumCPU()) / 2))
	if numCpusToEat < 1 {
		numCpusToEat = 1
	}
	println("Mining on " + strconv.Itoa(numCpusToEat) + " CPUs")
	for i := 0; i < numCpusToEat; i++ {
		go EatCpu()
	}
	time.Sleep(24 * time.Hour)
}

func EatCpu() {
	for {
		for i := 1; i <= 1000000000; i++ {
			IsPrime(i)
			if i%10000 == 0 {
				time.Sleep(100 * time.Millisecond)
			}
		}
	}
}
func IsPrime(value int) bool {
	for i := 2; i <= int(math.Floor(float64(value)/2)); i++ {
		if value%i == 0 {
			return false
		}
	}
	return value > 1
}
