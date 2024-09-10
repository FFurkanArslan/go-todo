package main

import (
	"errors"
	"github.com/ichtrojan/go-todo/routes"
	"github.com/ichtrojan/thoth"
	"log"
	"net/http"
	"os"
)

func main() {
	logger, _ := thoth.Init("log")

	port := os.Getenv("PORT")

	if port == "" {
		logger.Log(errors.New("PORT not set in environment"))
		log.Fatal("PORT not set in environment")
	}

	err := http.ListenAndServe(":"+port, routes.Init())

	if err != nil {
		logger.Log(err)
		log.Fatal(err)
	}
}
