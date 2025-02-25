package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/models"
	"EduproBackEnd/utils"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// @Summary Search courses by keyword
// @Description Searches for courses based on a keyword in title or category, and saves the search history
// @Tags Search
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param key path string true "Search keyword"
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /Search/search-by-key/{key} [get]
func SearchCoursesHandler(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "token missing"})
		return
	}
	claim, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "invalid token"})
		return
	}

	UserID := claim.Subject
	key := strings.TrimSpace(c.Param("key"))
	id := uuid.NewString()

	if key == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Course ID is required"})
		return
	}

	tx, err := database.DB.Begin()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Database error"})
		return
	}
	defer tx.Rollback()

	var exists bool
	err = tx.QueryRow("SELECT CASE WHEN COUNT(1) > 0 THEN 1 ELSE 0 END FROM KeyWord WHERE userId = ? AND word = ?", UserID, key).Scan(&exists)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Database error"})
		return
	}

	if !exists {
		_, err = tx.Exec("INSERT INTO KeyWord (id, userId, word) VALUES (?, ?, ?)", id, UserID, key)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to save search"})
			return
		}
	}

	keyword := "%" + strings.ToLower(key) + "%"
	rows, err := tx.Query(`
		SELECT id, category, title, image, description, price, isBookMark
		FROM CourseDetail 
		WHERE LOWER(title) LIKE ? OR LOWER(category) LIKE ?`,
		keyword, keyword,
	)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to search courses"})
		return
	}
	defer rows.Close()

	var courses []models.Course
	for rows.Next() {
		var course models.Course
		if err := rows.Scan(&course.Id, &course.Category, &course.Title, &course.Image, &course.Description, &course.Price, &course.IsBookMark); err != nil {
			log.Println(err)
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Error reading courses"})
			return
		}
		courses = append(courses, course)
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to commit transaction"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": courses})
}

// @Summary Get user's search history
// @Description Retrieves the list of keywords previously searched by the user
// @Tags Search
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /Search/get-keyWords [get]
func GetKeyWord(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "token missing"})
		return
	}
	claim, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "invalid token"})
		return
	}

	UserID := claim.Subject

	query := `SELECT id, word FROM KeyWord WHERE userId = ?`
	rows, err := database.DB.Query(query, UserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to fetch keywords"})
		return
	}
	defer rows.Close()

	var keywords []map[string]interface{}
	for rows.Next() {
		var id, word string

		err := rows.Scan(&id, &word)
		if err != nil {
			log.Printf("Error scanning row: %v", err)
			continue
		}

		keyword := map[string]interface{}{
			"id":   id,
			"word": word,
		}
		keywords = append(keywords, keyword)
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": keywords})
}

// @Summary Delete a search keyword
// @Description Deletes a specific keyword from user's search history
// @Tags Search
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Keyword ID"
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /Search/delete-keyword/{id} [delete]
func DeleteKeyWord(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "token missing"})
		return
	}
	claim, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "invalid token"})
		return
	}

	UserID := claim.Subject
	keywordID := c.Param("id")

	if keywordID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Keyword ID is required"})
		return
	}

	result, err := database.DB.Exec("DELETE FROM KeyWord WHERE id = ? AND userId = ?", keywordID, UserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to delete keyword"})
		return
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Error checking deletion result"})
		return
	}

	if rowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Keyword not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "Keyword deleted successfully"})
}
