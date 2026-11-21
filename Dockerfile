FROM --platform=$BUILDPLATFORM golang:1.27.4-alpine AS builder
ARG TARGETOS TARGETARCH
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ENV CGO_ENABLED=0
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /out/transmission-exporter ./cmd/exporter

FROM alpine:3.21
RUN apk add --no-cache ca-certificates
COPY --from=builder /out/transmission-exporter /usr/bin/transmission-exporter
RUN chmod 0755 /usr/bin/transmission-exporter
USER 65532:65532
ENTRYPOINT ["/usr/bin/transmission-exporter"]
