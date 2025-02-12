package routes

import (
	"EduproBackEnd/handlers"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func SetRoutes() *gin.Engine {
	router := gin.Default()

	router.POST("/Auth/login", handlers.Login)
	router.POST("Auth/sign-up", handlers.SignUp)

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	return router
}
