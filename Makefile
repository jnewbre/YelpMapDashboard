up:
	docker compose up 
down:
	docker compose down --volumes
rmi:
	docker rmi $(docker images -q)
