package config

import (
	"database/sql"
	"errors"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"github.com/ichtrojan/thoth"
	"github.com/joho/godotenv/autoload"
	"os"
)

func Database() *sql.DB {
    logger, _ := thoth.Init("log")

    user := os.Getenv("DB_USER")
    pass := os.Getenv("DB_PASS")
    host := os.Getenv("DB_HOST")
    dbName := os.Getenv("DB_NAME")

    credentials := fmt.Sprintf("%s:%s@tcp(%s:3306)/%s?charset=utf8&parseTime=True", user, pass, host, dbName)
    
    logger.Log(errors.New(fmt.Sprintf("Attempting to connect to database at %s", host)))

    database, err := sql.Open("mysql", credentials)
    if err != nil {
        logger.Log(errors.New(fmt.Sprintf("Failed to open database: %v", err)))
        return nil
    }

    err = database.Ping()
    if err != nil {
        logger.Log(errors.New(fmt.Sprintf("Failed to ping database: %v", err)))
        return nil
    }

    logger.Log(errors.New("Database Connection Successful"))
    return database
}
