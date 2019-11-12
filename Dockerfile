FROM golang:1.12.5 as builder

WORKDIR /workspace
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY apis/ apis/
COPY cmd/ cmd/
COPY generated/ generated/
COPY image/ image/
COPY k8sutils/ k8sutils/
COPY labeller/ labeller/
COPY prometheus/ prometheus/
COPY secscan/ secscan/
COPY Makefile Makefile

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make build

FROM alpine:3.10
WORKDIR /
COPY --from=builder /workspace/bin/security-labeller /bin/security-labeller
ENTRYPOINT ["/bin/security-labeller"]
