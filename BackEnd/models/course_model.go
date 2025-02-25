package models

type Course struct {
	Id          string  `json:"id"`
	Image       string  `json:"image"`
	Category    string  `json:"category"`
	Title       string  `json:"name"`
	Description string  `json:"description"`
	Price       float32 `json:"price"`
	IsBookMark  bool    `json:"isbookmark"`
}
