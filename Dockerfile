FROM golang:1.16-alpine as builder
WORKDIR $GOPATH/src/go.k6.io/k6
ADD . .
RUN apk --no-cache add git
RUN CGO_ENABLED=0 go install -a -trimpath -ldflags "-s -w -X go.k6.io/k6/lib/consts.VersionDetails=$(date -u +"%FT%T%z")/$(git describe --always --long --dirty)" 
RUN go install -trimpath github.com/k6io/xk6/cmd/xk6@latest
RUN xk6 build --with https://github.com/mridehalgh/xk6-sqs@latest
RUN cp k6 $GOPATH/bin/k6

FROM alpine:3.13
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=builder /go/bin/k6 /usr/bin/k6

#no volumes because I initiate those in docker-compose separately, this is just for image
USER 12345
ENTRYPOINT ["k6"]
