-include .env

# Redefinir MAKEFILE_LIST pour qu'il ne contienne que le Makefile
MAKEFILE_LIST := Makefile

ifeq ($(APP_ENV),dev)
  CONTAINER_NAME := todof-front
  COMPOSE_FILES := -f docker/compose.yaml -f docker/compose.override.yaml
else ifeq ($(APP_ENV),preprod)
  CONTAINER_NAME := todof-front-preprod
  COMPOSE_FILES := -f docker/compose.preprod.yaml
else ifeq ($(APP_ENV),prod)
  CONTAINER_NAME := todof-front-prod
  COMPOSE_FILES := -f docker/compose.prod.yaml
endif

# Variables
GO_COMMAND_CONTAINER_TEST := docker exec -i -e APP_ENV=test $(CONTAINER_NAME) go
GO_COMMAND_CONTAINER := docker exec -i $(CONTAINER_NAME) go
BASH_CONTAINER := docker exec -it $(CONTAINER_NAME) sh

.PHONY: help cm dev devb devbnod ddev tidy addget
.DEFAULT_GOAL = help

## —— 🐳 ALL 🐳 ——————————————————————————————————
help: ## Afficher l'aide
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— 🐳 CONTAINER 🐳 ——————————————————————————————————

## Attention définisser l'environement avec APP_ENV=dev, APP_ENV=prod, APP_ENV=preprod
## dans le .env

up: ## Demarre l'environnement
	docker compose --env-file .env $(COMPOSE_FILES) up -d

upb: ## Demarre l'environnement avec build
	docker compose --env-file .env $(COMPOSE_FILES) up -d --build

down: ## Arrête les conteneurs
	docker compose --env-file .env $(COMPOSE_FILES) down

## —— 🐳 TOOl 🐳 ——————————————————————————————————

tidy: ## Execute go mod tidy pour nettoyer les dependances
	$(GO_COMMAND_CONTAINER) mod tidy

gg: ## Ajoute une dependance - usage: make gg dep=path_de_la_dependance
	$(GO_COMMAND_CONTAINER) get $(dep)

s: ## Ouvre un shell dans le conteneur app
	$(BASH_CONTAINER)

l: ## Affiche les logs du conteneur app
	docker logs -f $(CONTAINER_NAME)

t: ## Execute les tests
	$(GO_COMMAND_CONTAINER_TEST) test -v -cover ./...