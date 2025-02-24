package models

type Course struct {
	Image       string  `json:"image"`
	Category    string  `json:"category"`
	Title       string  `json:"name"`
	Description string  `json:"description"`
	Price       float32 `json:"price"`
	IsBookMark  bool    `json:"isbookmark"`
}
