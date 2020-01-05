package main

import (
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"github.com/newrelic/go-agent/v3/integrations/nrecho-v3"
	"github.com/newrelic/go-agent/v3/newrelic"
)

func main() {
	app, err := newrelic.NewApplication(
		newrelic.ConfigAppName("shannon echo website"),
		newrelic.ConfigLicense(os.Getenv("NEW_RELIC_LICENSE_KEY")),
		newrelic.ConfigDebugLogger(os.Stdout),
	)
	if err != nil {
		log.Fatal(err)
	}

	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(nrecho.Middleware(app))

	e.Static("/static", "static")
	e.File("/", "./static/index.html")
	e.File("/posts", "./static/index.html")
	e.File("/contact", "./static/contact.html")
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
