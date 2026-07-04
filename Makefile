SHELL=cmd.exe

FRONT_END_BINARY=frontApp.exe
BROKER_BINARY=brokerApp

## up: starts all containers in the background without forcing build
up:
	@echo Starting Docker images...
	docker compose up -d

## up_build: stops docker compose (if running), builds all projects and starts docker compose
up_build: build_broker
	@echo Stopping Docker images...
	docker compose down
	docker compose up --build -d

## down: stop docker compose
down:
	@echo Stopping docker compose...
	docker compose down

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo Building broker binary...
	cd broker-service && set GOOS=linux&& set GOARCH=amd64&& set CGO_ENABLED=0&& go build -o $(BROKER_BINARY) ./cmd/api
	@echo Done!

## build_front: builds the front end binary
build_front:
	@echo Building front end binary...
	cd front-end && set CGO_ENABLED=0&& set GOOS=windows&& go build -o $(FRONT_END_BINARY) ./cmd/web
	@echo Done!

## start: starts the front end
start: build_front
	@echo Starting front end...
	cd front-end && start /B $(FRONT_END_BINARY)

## stop: stop the front end
stop:
	@echo Stopping front end...
	taskkill /IM "$(FRONT_END_BINARY)" /F
	@echo Stopped front end!