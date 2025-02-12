package main

import (
	"EduproBackEnd/database"
	_ "EduproBackEnd/docs"
	"EduproBackEnd/envConfig"
	"EduproBackEnd/routes"

	"log"
)

// @title Demo API
// @version 1.0
// @description This is a sample server for a demo application
// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
func main() {
	database.ConnectDB()
	router := routes.SetRoutes()

	log.Println("Starting server on :8080")
	log.Println("Swagger UI available at http://localhost:8080/swagger/index.html")
	router.Run(":8080")
}

func init() {
	envConfig.LoadEnv()
}
