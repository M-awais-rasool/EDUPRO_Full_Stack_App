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

	router.POST("/Course/add-Course", handlers.AddCourse)
	router.GET("/Course/get-courses", handlers.GetCourse)
	router.GET("/Course/get-course-details/:id", handlers.GetCourseDetailsById)

	router.GET("/mentor/get-mentors", handlers.GetMentors)

	router.POST("/bookmarks/add-bookMark/:id", handlers.AddBookMark)
	router.DELETE("/bookmarks/remove-bookMark/:id", handlers.RemoveBookMark)
	router.GET("/bookmarks/get-bookMarks", handlers.GetBookMarks)

	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	return router
}
