package models

import "time"

type LoginReq struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type StoreUser struct {
	Id       string    `json:"id"`
	Name     string    `json:"name"`
	Image    string    `json:"image"`
	Email    string    `json:"email"`
	Password string    `json:"password"`
	PhoneNo  string    `json:"PhoneNo"`
	Dob      time.Time `json:"dob"`
	Gender   string    `json:"gender"`
	IsMentor bool      `json:"isMentor"`
}
