package main

import (
	"net/http"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Static("/static", "static")
	e.File("/", "./static/index.html")
	e.File("/posts", "./static/index.html")
	e.File("/contact", "./static/contact.html")
	// e.GET("/", helloWorld)
	// e.GET("/test/:id", getUser)
	e.Logger.Fatal(e.Start(":8080"))
}

func helloWorld(c echo.Context) error {
	return c.String(http.StatusOK, "Hello, World")
}

func getUser(c echo.Context) error {
	id := c.Param("id")
	if id == "" {
		return c.String(http.StatusBadRequest, "ID not valid")
	}

	return c.String(http.StatusOK, id)
}
