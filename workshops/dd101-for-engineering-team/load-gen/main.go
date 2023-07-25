package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

type RequestBody struct {
	QueryValue string `json:"queryValue"`
}

func main() {
	paths := []struct {
		Path        string
		Method      string
		QueryValues []string
	}{
		{
			Path:        "/api/r",
			Method:      http.MethodGet,
			QueryValues: nil,
		},
		{
			Path:        "/api/word",
			Method:      http.MethodPost,
			QueryValues: []string{"gold", "rose", "foo"},
		},
		{
			Path:        "/api/word",
			Method:      http.MethodPost,
			QueryValues: []string{"money", "trouble"},
		},
		{
			Path:        "/api/word",
			Method:      http.MethodPost,
			QueryValues: []string{"humor", "onion"},
		},
		{
			Path:        "/api/word",
			Method:      http.MethodPost,
			QueryValues: []string{"money", "trouble", "humor"},
		},
	}

	for {
		for _, p := range paths {
			go func(path string, method string, queryValues []string) {
				if method == http.MethodGet {
					retryCount := 3
					for i := 0; i < retryCount; i++ {
						// need to change lab-host by a variable from a flag
						resp, err := http.Get(fmt.Sprintf("http://lab-host:8000%s", path))
						if err != nil {
							fmt.Printf("Error requesting %s: %v\n", path, err)
							if i < retryCount-1 {
								time.Sleep(time.Second * 2)
								continue
							} else {
								return
							}
						}
						defer resp.Body.Close()

						fmt.Printf("Response from %s: %s\n", path, resp.Status)
						break
					}
				} else if method == http.MethodPost {
					randomIndex := rand.Intn(len(queryValues))
					queryValue := queryValues[randomIndex]

					reqBody := RequestBody{
						QueryValue: queryValue,
					}
					bodyBytes, err := json.Marshal(reqBody)
					if err != nil {
						fmt.Printf("Error creating request body for %s: %v\n", path, err)
						return
					}

					retryCount := 3
					for i := 0; i < retryCount; i++ {
						// need to change lab-host by a variable from a flag
						resp, err := http.Post(fmt.Sprintf("http://lab-host:8000%s", path), "application/json", bytes.NewReader(bodyBytes))
						if err != nil {
							fmt.Printf("Error requesting %s: %v\n", path, err)
							if i < retryCount-1 {
								time.Sleep(time.Second * 2)
								continue
							} else {
								return
							}
						}
						defer resp.Body.Close()

						fmt.Printf("Response from %s: %s\n", path, resp.Status)
						break
					}
				}
			}(p.Path, p.Method, p.QueryValues)
		}

		coolDownDuration := time.Millisecond * 500
		time.Sleep(coolDownDuration)
	}
}
