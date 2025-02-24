package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/utils"
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// @Summary Add Course
// @Description Add Course for the user
// @Tags Course
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param category formData string true "Category"
// @Param title formData string true "Title"
// @Param description formData string true "Description"
// @Param image formData file true "Image"
// @Param price formData number true "Price"
// @Success 200 "Success"
// @Failure 400 "Invalid input data"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /Course/add-Course [post]
func AddCourse(c *gin.Context) {
	token := c.GetHeader("Authorization")
	if token == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "token messing"})
		return
	}
	claim, err := utils.ValidateToken(token)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "invalid token"})
		return
	}

	category := c.PostForm("category")
	title := c.PostForm("title")
	description := c.PostForm("description")
	price := c.PostForm("price")
	file, fileHeader, err := c.Request.FormFile("image")

	if category == "" || title == "" || description == "" || price == "" || err != nil {
		log.Println("All fields are required")
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "All fields are required"})
		return
	}

	categoryExists := false
	for _, validCategory := range utils.TechCategories {
		if validCategory == category {
			categoryExists = true
			break
		}
	}

	if !categoryExists {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Invalid category"})
		return
	}

	defer file.Close()
	userId := claim.Subject
	isBookMark := false

	imageURL, err := Upload_Image(c, file, fileHeader)
	if err != nil {
		log.Println("Failed to upload image:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to upload image"})
		return
	}

	query := `INSERT INTO CourseDetail (id, category, title, image, description, price, isBookMark, userId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
	id := uuid.NewString()
	_, err = database.DB.Exec(query, id, category, title, imageURL, description, price, isBookMark, userId)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Failed to insert data"})
	}
	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "Course add successfully"})
}

// @Summary Get All Courses
// @Description Get all available courses
// @Tags Course
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 500 "Internal Server Error"
// @Router /Course/get-courses [get]
func GetCourse(c *gin.Context) {
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

	query := `SELECT id, category, title, image, description, price, isBookMark FROM CourseDetail`
	rows, err := database.DB.Query(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to fetch courses"})
		return
	}
	defer rows.Close()

	var courses []map[string]interface{}
	for rows.Next() {
		var id, category, title, image, description string
		var price float64
		var isBookMark bool

		err := rows.Scan(&id, &category, &title, &image, &description, &price, &isBookMark)
		if err != nil {
			log.Printf("Error scanning row: %v", err)
			continue
		}

		course := map[string]interface{}{
			"id":          id,
			"category":    category,
			"title":       title,
			"image":       image,
			"description": description,
			"price":       price,
			"isBookMark":  isBookMark,
		}
		courses = append(courses, course)
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": courses})
}

// @Summary Get Course By ID
// @Description Get course by ID
// @Tags Course
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Course ID"
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /Course/get-course/{id} [get]
func GetCourseById(c *gin.Context) {
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

	id := c.Param("id")
	if id == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Course ID is required"})
		return
	}

	query := `
		SELECT c.id, c.category, c.title, c.image, c.description, c.price, c.isBookMark, 
			   u.id, u.name, u.email, u.image
		FROM CourseDetail c
		JOIN Users u ON c.userId = u.id
		WHERE c.id = ?`

	var course struct {
		ID          string  `json:"id"`
		Category    string  `json:"category"`
		Title       string  `json:"title"`
		Image       string  `json:"image"`
		Description string  `json:"description"`
		Price       float64 `json:"price"`
		IsBookMark  bool    `json:"isBookMark"`
		User        struct {
			ID    string `json:"id"`
			Name  string `json:"name"`
			Email string `json:"email"`
			Image string `json:"image"`
		} `json:"user"`
	}

	err = database.DB.QueryRow(query, id).Scan(
		&course.ID, &course.Category, &course.Title, &course.Image,
		&course.Description, &course.Price, &course.IsBookMark,
		&course.User.ID, &course.User.Name, &course.User.Email, &course.User.Image,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Course not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to fetch course"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "data": course})
}
