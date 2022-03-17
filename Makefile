init-k6:
	docker network create kangal
	docker run --name simple-http --network kangal --rm -it -d -p 8800:80 strm/helloworld-http

init-kangal:
	minikube start
	helm repo add kangal https://hellofresh.github.io/kangal
	helm dependency build kangal-local-chart
	helm install kangal kangal-local-chart
	helm install simple-http simple-http-chart

run-example:
	cat example.js | docker run --network kangal -i grafana/k6 run --vus 10 --duration 10s -
