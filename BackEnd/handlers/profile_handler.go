package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/utils"
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @Summary Get Mentor Details
// @Description Fetch user details by Mentor ID
// @Tags Profile
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Mentor ID"
// @Success 200 "Success"
// @Failure 400 "Bad Request"
// @Failure 401 "Unauthorized"
// @Failure 404 "User Not Found"
// @Failure 500 "Internal Server Error"
// @Router /user/mentor-details/{id} [get]
func GetUserDetails(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "Token missing"})
		return
	}
	_, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "Invalid token"})
		return
	}

	userID := c.Param("id")
	if userID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "User ID is required"})
		return
	}

	var user struct {
		ID    string `json:"id"`
		Name  string `json:"name"`
		Email string `json:"email"`
		Image string `json:"image"`
	}

	err = database.DB.QueryRow("SELECT id, name, email, image FROM Users WHERE id = ?", userID).Scan(&user.ID, &user.Name, &user.Email, &user.Image)
	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "User not found"})
		} else {
			log.Println("Database error:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Internal Server Error"})
		}
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data":   user,
	})
}

// @Summary Get Courses by Mentor ID
// @Description Fetch all courses assigned to a specific Mentor
// @Tags Profile
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Mentor ID"
// @Success 200 "Success"
// @Failure 400 "Bad Request"
// @Failure 401 "Unauthorized"
// @Failure 404 "No Courses Found"
// @Failure 500 "Internal Server Error"
// @Router /user/mentor-courses/{id} [get]
func GetCoursesByUserID(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "Token missing"})
		return
	}
	_, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "Invalid token"})
		return
	}

	userID := c.Param("id")
	if userID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "User ID is required"})
		return
	}

	rows, err := database.DB.Query("SELECT id, category, title, image, description, price, isBookMark FROM CourseDetail WHERE userId = ?", userID)
	if err != nil {
		log.Println("Database error:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Internal Server Error"})
		return
	}
	defer rows.Close()

	var courses []map[string]interface{}
	for rows.Next() {
		var course struct {
			ID          string  `json:"id"`
			Category    string  `json:"category"`
			Title       string  `json:"title"`
			Image       string  `json:"image"`
			Description string  `json:"description"`
			Price       float32 `json:"price"`
			IsBookMark  bool    `json:"isBookMark"`
		}
		if err := rows.Scan(&course.ID, &course.Category, &course.Title, &course.Image, &course.Description, &course.Price, &course.IsBookMark); err != nil {
			log.Println("Row scan error:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Internal Server Error"})
			return
		}
		courses = append(courses, map[string]interface{}{
			"id":          course.ID,
			"category":    course.Category,
			"title":       course.Title,
			"image":       course.Image,
			"description": course.Description,
			"price":       course.Price,
			"isBookMark":  course.IsBookMark,
		})
	}

	if len(courses) == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "No courses found for this user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data":   courses,
	})
}
