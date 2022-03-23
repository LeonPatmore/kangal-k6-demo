FROM node as builder
WORKDIR /npm
RUN npm install aws-sdk

FROM grafana/k6
COPY --from=builder /npm /npm
WORKDIR /home/k6
ENTRYPOINT ["k6"]
