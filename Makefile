docker-spin-up:
	docker compose --env-file env up airflow-init && docker compose --env-file env up --build -d

perms:
	sudo mkdir -p logs plugins temp dags tests migrations && sudo chmod -R u=rwx,g=rwx,o=rwx logs plugins temp dags tests migrations

up: perms docker-spin-up warehouse-migration

down:
	docker compose down

sh:
	docker exec -ti webserver bash
