# Kangal K6 Demo

## Intro

### K6

K6 is a performance testing tool written in GO, allowing you to run different types of performance tests via node js files.

### Kangal

Kangal is a K8 performance tool scheduler, which provides a REST API to query and start performance tests.

## Running Examples

### Running K6 in Docker

Init: `make init-k6`

`make run-example`

### Running via Kangal in K8

First setup the environment: `init-kangal`.

If running the example locally with minikube, you must expose the `kangal-proxy` service locally first. Replace `53028` in the snippets below with the port it is exposed under on your computer.

1.  ```
    curl --location --request POST 'localhost:12567/load-test' \
    --form 'type="K6"' \
    --form 'distributedPods="2"' \
    --form 'testFile=@"./example.js"'
    ```

    `curl --location --request POST 'localhost:12567/load-test' --form 'type="K6"' --form 'distributedPods="2"' --form 'testFile=@"./example.js"'`

2.  Note the load test name in the response.

3.  See the result in the browser `http://localhost:12567/load-test/<load test name>/report`.
