package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/utils"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// @Summary Add a bookmark
// @Description Adds a bookmark for a specified course by the authenticated user
// @Tags Bookmarks
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Course ID" example("123e4567-e89b-12d3-a456-426614174000")
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /bookmarks/add-bookMark/{id} [post]
func AddBookMark(c *gin.Context) {
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

	userId := claim.Subject
	courseId := c.Param("id")

	var exists bool
	err = database.DB.QueryRow("SELECT CASE WHEN EXISTS (SELECT 1 FROM bookmarks WHERE userId = ? AND courseId = ?) THEN 1 ELSE 0 END", userId, courseId).Scan(&exists)
	if err != nil {
		log.Println("Failed to upload image:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "database error"})
		return
	}

	if exists {
		c.JSON(http.StatusConflict, gin.H{"status": "error", "message": "bookmark already exists"})
		return
	}

	tx, err := database.DB.Begin()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "transaction error"})
		return
	}

	newId := uuid.NewString()
	_, err = tx.Exec("INSERT INTO bookmarks (id, userId, courseId) VALUES (?, ?, ?)", newId, userId, courseId)
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to add bookmark"})
		return
	}

	_, err = tx.Exec("UPDATE CourseDetail SET isBookMark = 1 WHERE id = ?", courseId)
	if err != nil {
		log.Println("Failed to upload image:", err)
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to update course"})
		return
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to commit transaction"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "bookmark added successfully"})
}

// @Summary Remove a bookmark
// @Description Removes a bookmark for a specified course by the authenticated user
// @Tags Bookmarks
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Course ID" example("123e4567-e89b-12d3-a456-426614174000")
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /bookmarks/remove-bookMark/{id} [delete]
func RemoveBookMark(c *gin.Context) {
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

	userId := claim.Subject
	courseId := c.Param("id")

	tx, err := database.DB.Begin()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "transaction error"})
		return
	}

	result, err := tx.Exec("DELETE FROM bookmarks WHERE userId = ? AND courseId = ?", userId, courseId)
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to remove bookmark"})
		return
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil || rowsAffected == 0 {
		tx.Rollback()
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "bookmark not found"})
		return
	}

	_, err = tx.Exec("UPDATE CourseDetail SET isBookMark = 0 WHERE id = ?", courseId)
	if err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to update course"})
		return
	}

	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "failed to commit transaction"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "bookmark removed successfully"})
}

// @Summary Get user's bookmarks
// @Description Retrieves all bookmarks for the authenticated user
// @Tags Bookmarks
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /bookmarks/get-bookMarks [get]
func GetBookMarks(c *gin.Context) {
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

	userId := claim.Subject

	rows, err := database.DB.Query(`
		SELECT cd.* 
		FROM CourseDetail cd 
		INNER JOIN bookmarks b ON cd.id = b.courseId 
		WHERE b.userId = ?`, userId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "database error"})
		return
	}
	defer rows.Close()

	var bookmarks []map[string]interface{}
	for rows.Next() {
		var course struct {
			ID          string
			Title       string
			Description string
			ImageURL    string
			Category    string
			userId      string
			Price       float64
			IsBookMark  bool
		}

		if err := rows.Scan(&course.ID, &course.Category, &course.Title, &course.Description, &course.ImageURL, &course.Price, &course.IsBookMark, &userId); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "error scanning data"})
			log.Println("Failed to upload image:", err)

			return
		}

		bookmarkData := map[string]interface{}{
			"id":          course.ID,
			"category":    course.Category,
			"title":       course.Title,
			"description": course.Description,
			"imageURL":    course.ImageURL,
			"price":       course.Price,
			"isBookMark":  course.IsBookMark,
		}
		bookmarks = append(bookmarks, bookmarkData)
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": bookmarks})
}
