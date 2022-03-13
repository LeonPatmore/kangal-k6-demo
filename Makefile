init:
	minikube start
	docker network create kangal
	docker run --name mock --network kangal --rm -it -d -p 8800:80 strm/helloworld-http

run-example:
	cat example.js | docker run --network kangal -i grafana/k6 run --vus 10 --duration 10s -
