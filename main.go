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

	// You might want to log these for debugging
	log.Printf("DB_HOST: %s", os.Getenv("DB_HOST"))
	log.Printf("DB_USER: %s", os.Getenv("DB_USER"))
	log.Printf("DB_NAME: %s", os.Getenv("DB_NAME"))
	log.Printf("hallo liebe leute")
	log.printf("hallo liebe leute")
	err := http.ListenAndServe(":"+port, routes.Init())
	if err != nil {
		logger.Log(err)
		log.Fatal(err)
	}
}
