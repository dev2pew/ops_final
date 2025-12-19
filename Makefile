.PHONY: build up down logs clean test wrapper

wrapper:
	cd app && gradle wrapper

build:
	docker compose -f docker/compose.yml --project-directory . build

up:
	docker compose -f docker/compose.yml --project-directory . up -d

down:
	docker compose -f docker/compose.yml --project-directory . down

logs:
	docker compose -f docker/compose.yml --project-directory . logs -f

clean:
	docker compose -f docker/compose.yml --project-directory . down -v
	docker system prune -f

test:
	cd app && ./gradlew test
