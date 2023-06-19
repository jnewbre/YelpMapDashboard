airflow:
	docker compose up airflow-init
perms:
	sudo mkdir -p logs plugins temp dags && sudo chmod -R u=rwx,g=rwx,o=rwx logs plugins temp dags tests
up:
	docker compose --env-file .env up 
down:
	docker compose down --volumes
rmi:
	docker rmi $(docker images -q)
cloud-metabase:
	terraform -chdir=./terraform output -raw private_key > private_key.pem && chmod 600 private_key.pem && ssh -o "IdentitiesOnly yes" -i private_key.pem ubuntu@$$(terraform -chdir=./terraform output -raw ec2_public_dns) -N -f -L 3001:$$(terraform -chdir=./terraform output -raw ec2_public_dns):3000 && open http://localhost:3001 && rm private_key.pem