# Dockerfile

# Use an official Golang image as the base image
FROM golang:1.20

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container's working directory
COPY main.go /app

# Build the Go application
RUN go mod init load-gen
RUN go mod tidy
RUN go build -o load-gen .

# Set the command to run the binary executable when the container starts
CMD ["./load-gen"]
