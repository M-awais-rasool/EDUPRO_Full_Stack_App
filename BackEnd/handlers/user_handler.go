package handlers

import (
	"EduproBackEnd/database"
	"EduproBackEnd/models"
	"database/sql"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

var jwtKey = []byte("agfgdfdsgfdfgdertwcvb")

// @Summary User Login
// @Description Authenticate user and return JWT token
// @Tags Auth
// @Accept json
// @Produce json
// @Param user body models.LoginReq true "User Login Details"
// @Success 200 "Success"
// @Failure 404 "User not found"
// @Failure 500 "Internal Server Error"
// @Router /Auth/login [post]
func Login(c *gin.Context) {
	var reqUser models.LoginReq
	var StoreUser models.StoreUser

	if err := c.ShouldBindJSON(&reqUser); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": "request invalid"})
		return
	}
	query := `SELECT id, name, email, password, image, dob, phoneNo, gender FROM Users WHERE email = ?`

	err := database.DB.QueryRow(query, reqUser.Email).Scan(&StoreUser.Id, &StoreUser.Name, &StoreUser.Email, &StoreUser.Password, &StoreUser.Image, &StoreUser.Dob, &StoreUser.PhoneNo, &StoreUser.Gender)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"status": "error", "message": "Email does not exist"})
		return
	} else if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"status": "error", "message": err.Error()})
		return
	}
	if err := bcrypt.CompareHashAndPassword([]byte(StoreUser.Password), []byte(reqUser.Password)); err != nil {
		log.Println("Password mismatch:", err)
		c.JSON(http.StatusUnauthorized, gin.H{"status": "error", "message": "Invalid password"})
		return
	}

	claims := &jwt.RegisteredClaims{
		Subject: StoreUser.Id,
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status":  "success",
		"message": "Sign in successful",
		"data": gin.H{
			"name":   StoreUser.Name,
			"email":  StoreUser.Email,
			"image":  StoreUser.Image,
			"token":  tokenString,
			"userId": StoreUser.Id,
		},
	})
}

// @Summary Sign up a new user
// @Description Register a new user
// @Tags Auth
// @Accept json
// @Produce json
// @Param name formData string true "Name"
// @Param email formData string true "Email"
// @Param password formData string true "Password"
// @Param image formData file true "Image"
// @Param gender formData string true "Gender (male/female)"
// @Param phoneNo formData string true "Phone Number"
// @Param dob formData string true "Date of Birth (YYYY-MM-DD)"
// @Success 200 "Success"
// @Failure 400 "Image upload failed"
// @Failure 500 "Internal Server Error"
// @Router /Auth/sign-up [post]
func SignUp(c *gin.Context) {
	name := c.PostForm("name")
	email := c.PostForm("email")
	password := c.PostForm("password")
	gender := c.PostForm("gender")
	phoneNo := c.PostForm("phoneNo")
	dob := c.PostForm("dob")
	file, fileHeader, err := c.Request.FormFile("image")

	if name == "" || email == "" || password == "" || gender == "" || phoneNo == "" || dob == "" || err != nil {
		log.Println("All fields are required")
		c.JSON(http.StatusBadRequest, gin.H{"error": "All fields are required"})
		return
	}

	if gender != "male" && gender != "female" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Gender must be either 'male' or 'female'"})
		return
	}

	_, err = time.Parse("2006-01-02", dob)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid date format. Use YYYY-MM-DD"})
		return
	}

	defer file.Close()

	var exists bool
	err = database.DB.QueryRow("SELECT COUNT(1) FROM Users WHERE email = ?", email).Scan(&exists)
	if err != nil {
		log.Println("Failed to check email:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check email"})
		return
	}
	if exists {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		log.Println("Failed to hash password:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	imageURL, err := Upload_Image(c, file, fileHeader)
	if err != nil {
		log.Println("Failed to upload image:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to upload image"})
		return
	}

	query := `INSERT INTO Users (id, name, email, password, image, gender, phoneNo, dob) 
			 VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
	id := uuid.NewString()
	_, err = database.DB.Exec(query, id, name, email, string(hashedPassword), imageURL, gender, phoneNo, dob)
	if err != nil {
		log.Println("Failed to insert data:", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to insert data"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "success", "message": "User signed up successfully"})
}
