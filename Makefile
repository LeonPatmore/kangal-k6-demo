include .env

init-k6:
	docker network create kangal
	docker run --name simple-http --network kangal --rm -it -d -p 8800:80 strm/helloworld-http

init-kangal:
	minikube start
	helm repo add kangal https://hellofresh.github.io/kangal
	helm dependency build kangal-local-chart
	helm upgrade --create-namespace --namespace kangal --install kangal kangal-local-chart --set kangal.secrets.AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --set kangal.secrets.AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --set kangal.configMap.AWS_DEFAULT_REGION=${REGION} --set kangal.configMap.AWS_BUCKET_NAME=${BUCKET_NAME}
	helm install simple-http simple-http-chart
	kubectl -n kangal port-forward service/kangal-proxy 12567:80

install-kangal:
	cd kangal-local-chart && helm dependency build
	helm upgrade --create-namespace --namespace kangal --install kangal kangal-local-chart --set kangal.secrets.AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --set kangal.secrets.AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --set kangal.configMap.AWS_DEFAULT_REGION=${REGION} --set kangal.configMap.AWS_BUCKET_NAME=${BUCKET_NAME}

run-example:
	cat example.js | docker run --network kangal -i grafana/k6 run --vus 10 --duration 10s -

run-sqs-example:
	cat sqs_example.js | docker run --network kangal -i k6-custom run --vus 10 --duration 10s -

build-k6:
	docker build . -t leonpatmore/k6-sqs:latest
	docker push leonpatmore/k6-sqs:latest
