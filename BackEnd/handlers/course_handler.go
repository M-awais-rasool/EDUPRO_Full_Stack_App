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
// @Router /Course/get-course-details/{id} [get]
func GetCourseDetailsById(c *gin.Context) {
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

// @Summary Create Section
// @Description Create a new section for a course
// @Tags Course
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param title path string true "Section Title"
// @Param id path string true "Course ID"
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /Course/create-section/{id}/{title} [post]
func CreateSection(c *gin.Context) {
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

	title := c.Param("title")
	CourseID := c.Param("id")
	if CourseID == "" || title == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Course ID & title is required"})
		return
	}

	var exists int
	err = database.DB.QueryRow("SELECT CASE WHEN EXISTS (SELECT 1 FROM CourseDetail WHERE id = ?) THEN 1 ELSE 0 END", CourseID).Scan(&exists)
	if err != nil {
		log.Println("Failed to check course existence:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to check course existence"})
		return
	}
	if exists == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Course not found"})
		return
	}

	UserID := claim.Subject
	id := uuid.NewString()

	query := "INSERT INTO Section (id, userId, courseId, title) VALUES (?, ?, ?, ?)"
	result, err := database.DB.Exec(query, id, UserID, CourseID, title)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to create section"})
		return
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "No rows affected"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "Section created successfully"})
}

// @Summary Create Video
// @Description Create a new video for a course section
// @Tags Course
// @Accept multipart/form-data
// @Produce json
// @Security BearerAuth
// @Param title formData string true "Video Title"
// @Param video formData file true "Video File"
// @Param courseId formData string true "Course ID"
// @Param sectionId formData string true "Section ID"
// @Success 200 "Success"
// @Failure 400 "Bad Request"
// @Failure 401 "Unauthorized"
// @Failure 404 "Not Found"
// @Failure 500 "Internal Server Error"
// @Router /Course/create-video [post]
func CreateVideo(c *gin.Context) {
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

	file, fileHeader, err := c.Request.FormFile("video")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Video file is required"})
		return
	}
	defer file.Close()

	title := c.PostForm("title")
	courseID := c.PostForm("courseId")
	sectionID := c.PostForm("sectionId")

	if title == "" || courseID == "" || sectionID == "" {
		log.Println("All fields are required", err)
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "All fields (title, courseId, sectionId) are required"})
		return
	}

	var courseExists int
	err = database.DB.QueryRow("SELECT COUNT(*) FROM CourseDetail WHERE id = ?", courseID).Scan(&courseExists)
	if err != nil || courseExists == 0 {
		log.Println("Course not found", err)
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Course not found"})
		return
	}

	var sectionExists int
	err = database.DB.QueryRow("SELECT COUNT(*) FROM Section WHERE id = ? AND courseId = ?", sectionID, courseID).Scan(&sectionExists)
	if err != nil || sectionExists == 0 {
		log.Println("Section not found for this course", err)
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Section not found for this course"})
		return
	}

	VideoURL, err := Upload_Image(c, file, fileHeader)
	if err != nil {
		log.Println("Failed to upload video:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to upload video"})
		return
	}

	id := uuid.NewString()
	userID := claim.Subject

	query := "INSERT INTO Video (id, title, video, userId, courseId, sectionId) VALUES (?, ?, ?, ?, ?, ?)"
	resultDB, err := database.DB.Exec(query, id, title, VideoURL, userID, courseID, sectionID)
	if err != nil {
		log.Println("Database Insert Error:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to create video record"})
		return
	}

	rowsAffected, err := resultDB.RowsAffected()
	if err != nil || rowsAffected == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to insert video record"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Video uploaded successfully",
	})
}

// @Summary Get Sections with Videos
// @Description Get all sections and their associated videos for a given course
// @Tags Course
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param id path string true "Course ID"
// @Success 200 "Success"
// @Failure 401 "Unauthorized"
// @Failure 404 "Course not found"
// @Failure 500 "Internal Server Error"
// @Router /Course/get-sections/{id} [get]
func GetSectionsWithVideos(c *gin.Context) {
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

	courseID := c.Param("id")
	if courseID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "Course ID is required"})
		return
	}

	var courseExists int
	err = database.DB.QueryRow("SELECT COUNT(*) FROM CourseDetail WHERE id = ?", courseID).Scan(&courseExists)
	if err != nil || courseExists == 0 {
		log.Println("Course not found:", err)
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Course not found"})
		return
	}

	rows, err := database.DB.Query("SELECT id, title FROM Section WHERE courseId = ?", courseID)
	if err != nil {
		log.Println("Failed to fetch sections:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": "error", "message": "Failed to fetch sections"})
		return
	}
	defer rows.Close()

	var sections []map[string]interface{}

	for rows.Next() {
		var sectionID, title string
		if err := rows.Scan(&sectionID, &title); err != nil {
			log.Println("Failed to scan section:", err)
			continue
		}

		videoRows, err := database.DB.Query("SELECT id, title, video FROM Video WHERE sectionId = ?", sectionID)
		if err != nil {
			log.Println("Failed to fetch videos:", err)
			continue
		}

		var videos []map[string]interface{}
		for videoRows.Next() {
			var videoID, videoTitle, videoURL string
			if err := videoRows.Scan(&videoID, &videoTitle, &videoURL); err != nil {
				log.Println("Failed to scan video:", err)
				continue
			}

			videos = append(videos, map[string]interface{}{
				"id":    videoID,
				"title": videoTitle,
				"video": videoURL,
			})
		}
		videoRows.Close()

		sections = append(sections, map[string]interface{}{
			"id":     sectionID,
			"title":  title,
			"videos": videos,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "success",
		"data":   sections,
	})
}
