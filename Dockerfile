FROM golang:latest
WORKDIR /app
COPY . .

RUN go get -u "github.com/labstack/echo"
RUN go get -u "github.com/labstack/echo/middleware"
RUN go get -u "github.com/dgrijalva/jwt-go"

RUN go build -o main .

EXPOSE 8080

CMD ["/app/main"]
