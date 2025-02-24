package utils

import (
	"errors"

	"github.com/golang-jwt/jwt/v5"
)

var jwtKey = []byte("agfgdfdsgfdfgdertwcvb")

func ValidateToken(tokenString string) (*jwt.RegisteredClaims, error) {
	if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
		tokenString = tokenString[7:]
	}

	claims := &jwt.RegisteredClaims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil || !token.Valid {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}

var TechCategories = []string{
	"Programming", "App Development", "Web Development", "Artificial Intelligence",
	"Machine Learning", "Graphics Design", "Cloud Computing", "Cybersecurity",
	"Databases", "Networking", "Video Editing", "Image Editing",
	"Data Structures", "Algorithms", "Operating Systems", "Software Engineering",
	"Computer Graphics", "Mobile Development", "Game Development", "DevOps",
	"Big Data", "Internet of Things (IoT)", "UI/UX Design", "Blockchain",
	"Augmented Reality (AR)", "Virtual Reality (VR)", "Robotics",
	"Embedded Systems", "Quantum Computing", "Data Science",
	"Business Intelligence", "System Administration", "IT Support",
	"Ethical Hacking", "Penetration Testing", "Digital Forensics",
	"3D Modeling", "Animation", "Motion Graphics", "Audio Engineering",
	"Full Stack Development", "Frontend Development", "Backend Development",
	"API Development", "Microservices", "Serverless Computing",
	"Natural Language Processing (NLP)", "Computer Vision", "Parallel Computing",
	"High-Performance Computing", "Bioinformatics",
	"Geographic Information Systems (GIS)", "E-commerce Development",
	"Content Management Systems (CMS)", "Search Engine Optimization (SEO)",
	"Digital Marketing Technology", "Agile Methodologies", "Project Management Tools",
	"Version Control Systems", "Containerization", "Edge Computing",
}
