package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/utils"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

// @Summary Get all mentors
// @Description Get all users who are mentors
// @Tags Mentors
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 "Success"
// @Failure 400 "Invalid input data"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /mentor/get-mentors [get]
func GetMentors(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "token missing"})
		return
	}
	_, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "invalid token"})
		return
	}

	rows, err := database.DB.Query("SELECT id, name, image, email FROM Users WHERE isMentor = ?", true)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Error fetching mentors"})
		return
	}
	defer rows.Close()

	var mentors []map[string]interface{}
	for rows.Next() {
		var id, name, email, image string

		err := rows.Scan(&id, &name, &image, &email)
		if err != nil {
			log.Println("Scan error:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Error scanning mentors"})
			return
		}
		mentor := map[string]interface{}{
			"id":    id,
			"image": image,
			"name":  name,
			"email": email,
		}
		mentors = append(mentors, mentor)
	}

	if err = rows.Err(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Error iterating mentors"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": mentors})
}
