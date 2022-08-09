DOCKER_IMAGE_GRAFANA_NAME=grafana/grafana
DOCKER_IMAGE_INFLUXDB_NAME=influxdb:1.8
DOCKER_CONTAINER_INFLUXDB_NAME=influxdb

grafana:
	docker run -d \
	--name grafana \
	-p 3003:3000 \
	-v /data/lib/docker-influxdb-grafana/grafana:/var/lib/grafana \
	${DOCKER_IMAGE_GRAFANA_NAME}


influxdb:
	docker run -d \
	--name ${DOCKER_CONTAINER_INFLUXDB_NAME} \
	-p 8086:8086 \
	-p 25826:25826/udp \
	-v /data/lib/docker-influxdb-grafana/influxdb:/var/lib/influxdb \
	-v $(shell pwd)/influxdb.d/types.db:/usr/share/collectd/types.db:ro \
	-e DOCKER_INFLUXDB_INIT_USERNAME=root \
	-e DOCKER_INFLUXDB_INIT_PASSWORD='CookApps#tjdska' \
	-e DOCKER_INFLUXDB_INIT_ORG=cookapps \
	-e DOCKER_INFLUXDB_INIT_BUCKET=cookapps \
	-e INFLUXDB_COLLECTD_ENABLED=true \
	-e INFLUXDB_COLELCTD_DATABASE=collectd \
	-e INFLUXDB_COLLECTD_TYPESDB=/usr/share/collectd/types.db \
	${DOCKER_IMAGE_INFLUXDB_NAME}

influxdb-test:
	curl -i -X POST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE collectd"

exec:
	docker exec -it ${DOCKER_CONTAINER_INFLUXDB_NAME} bash
