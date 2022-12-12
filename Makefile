.PHONY: prepare
prepare:
	./scripts/preparation.sh

.PHONY: init
init:
	docker-compose run --rm default init

.PHONY: fmt
fmt:
	docker-compose run --rm default fmt

.PHONY: plan
plan:
	docker-compose run --rm default plan

.PHONY: apply
apply:
	docker-compose run --rm default apply -auto-approve

.PHONY: destroy
destroy:
	docker-compose run --rm default destroy -auto-approve
