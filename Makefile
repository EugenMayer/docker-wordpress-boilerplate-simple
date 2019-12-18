build:
	docker pull wordpress
	docker-compose build wordpress

push:
	docker push eugenmayer/wordpress