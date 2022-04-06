FROM szkiba/xk6bundler as builder
ENV XK6BUNDLER_WITH=github.com/mridehalgh/xk6-sqs@latest
ENV XK6BUNDLER_PLATFORM=linux/amd64
RUN xk6bundler

FROM alpine:3.13
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=builder /go/dist/go_linux_amd64/k6 /usr/bin/k6
USER 12345
ENTRYPOINT ["k6"]
