.PHONY: all dev clean build env-up env-down run

all: clean build env-up run

dev: build run

##### BUILD
build:
	@echo "Build ..."
	@govendor sync
	@go build
	@echo "Build done"

##### ENV
env-up:
	@echo "Start environnement ..."
	@cd fixtures && docker-compose up --force-recreate -d
	@echo "Sleep 15 seconds in order to let the environment setup correctly"
	@sleep 15
	@echo "Environnement up"

env-down:
	@echo "Stop environnement ..."
	@cd fixtures && docker-compose down
	@echo "Environnement down"

##### RUN
run:
	@echo "Start app ..."
	@./servntire-demo

##### CLEAN
clean: env-down
	@echo "Clean up ..."
	@rm -rf /tmp/enroll_user /tmp/msp servntire-service
	@docker rm -f -v `docker ps -a --no-trunc | grep "servntire-service" | cut -d ' ' -f 1` 2>/dev/null || true
	@docker rmi `docker images --no-trunc | grep "servntire-service" | cut -d ' ' -f 1` 2>/dev/null || true
	@echo "Clean up done"
