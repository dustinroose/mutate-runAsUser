FROM golang:1.12-alpine AS build
ENV GO111MODULE on
ENV CGO_ENABLED 0

RUN apk add git make openssl

WORKDIR /go/src/github.com/dustinroose/mutate-runasuser
ADD . .
RUN make test
RUN make app

FROM scratch
WORKDIR /app
COPY --from=build /go/src/github.com/dustinroose/mutate-runasuser/mutateme .
COPY --from=build /go/src/github.com/dustinroose/mutate-runasuser/ssl ssl
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
CMD ["/app/mutateme"]
