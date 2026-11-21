start-exporter:
	TRANSMISSION_HOST=http://localhost:9091 \
	TRANSMISSION_USER=admin \
	TRANSMISSION_PASSWORD=password \
	PORT=2112 \
	EXPORT_TORRENT_LEVEL_METRICS=true \
	go run ./cmd/exporter/main.go

build-exporter:
	go build ./cmd/exporter

DOCKER_USERNAME ?= szpaczyn
IMAGE_NAME ?= transmission-exporter
IMAGE_TAG ?= v1.0.0
PLATFORMS ?= linux/amd64,linux/arm64
BUILD_BY ?= shpaq

docker-build-exporter:
	docker buildx build \
		--file Dockerfile \
		--label=build-by=$(BUILD_BY) \
		--platform $(PLATFORMS) \
		-t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(DOCKER_USERNAME)/$(IMAGE_NAME):latest \
		.

docker-push-exporter:
	docker buildx build \
		--file Dockerfile \
		--label=build-by=$(BUILD_BY) \
		--push \
		--platform $(PLATFORMS) \
		-t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(DOCKER_USERNAME)/$(IMAGE_NAME):latest \
		.

docker-build-push-exporter: docker-push-exporter

fmt:
	gofmt -w .

vet:
	go vet ./...

test:
	go test ./... -race
