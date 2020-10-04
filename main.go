package main

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Static("/static", "static")
	e.File("/", "./static/index.html")
	e.Logger.Fatal(e.Start(":8080"))
}
