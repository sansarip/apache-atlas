VERSION:=2.0.0
ATLAS_BIN:=target/apache-atlas-sources-${VERSION}/distro/target/apache-atlas-${VERSION}-server/apache-atlas-${VERSION}/bin
ATLAS_DISTROS:=target/apache-atlas-sources-${VERSION}/distro/target/

users:
	groupadd -r -g 47144 atlas || true
	useradd -r -u 47145 -g atlas atlas || true
patch:
	cp atlas_start.py.patch ${ATLAS_BIN}
	cp atlas_config.py.patch ${ATLAS_BIN}
	cd ${ATLAS_BIN} \
		&& patch -b -f < atlas_start.py.patch \
		&& patch -b -f < atlas_config.py.patch
permissions:
	chown -R atlas:atlas ${ATLAS_DISTROS}/apache-atlas-${VERSION}-server
	chmod -R u=rwx,g=rwx ${ATLAS_DISTROS}/apache-atlas-${VERSION}-server

extract:
	cd ${ATLAS_DISTROS} && \
		tar -czvf apache-atlas-${VERSION}-server.tar.gz -C apache-atlas-${VERSION}-server .
	cp -p ${ATLAS_DISTROS}/apache-atlas-${VERSION}-server.tar.gz target/

setup:
	mkdir -p target
	tar -xzvf packages/apache-atlas-${VERSION}-sources.tar.gz -C target
	chmod -R a+wrx target/apache-atlas-sources-${VERSION}

maven-build:
	docker volume create --name maven-repo
	docker run --rm -v maven-repo:/root/.m2 -v "$$(pwd)/target/apache-atlas-sources-${VERSION}/":/usr/src/mymaven -e MAVEN_OPTS="-Xms2g -Xmx2g" -w /usr/src/mymaven maven:3.6-jdk-8 mvn clean -DskipTests package -Pdist,embedded-hbase-solr
	
build:
	make setup
	make maven-build
	make users
	make patch
	make permissions
	make extract

docker-build:
	docker build . -t sansarip/apache-atlas

docker-push:
	docker push sansarip/apache-atlas

docker-run:
	docker run --name atlas -v /var/tmp/atlas-test/:/opt/apache-atlas-2.0.0 -p 21000:21000 -it --rm -u atlas sansarip/apache-atlas

docker-stop:
	docker stop -t 30 atlas
