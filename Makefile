DOCKER_IMAGE = lidarr-build

all: build package

build:
	#find . -name '*.csproj' -exec dotnet restore {} \;
	rm -rf Lidarr.linux.tar.gz Lidarr/ _artifacts/ _output/ _temp/ _tests/
	bash build.sh

package:
	rm -rf Lidarr.linux.tar.gz Lidarr
	cp -r ./_artifacts/linux-x64/netcoreapp3.1/Lidarr Lidarr
	tar -zcvf Lidarr.linux.tar.gz ./Lidarr/*

docker_image:
	docker build \
		-t $(DOCKER_IMAGE) $(CURDIR)

docker_%: docker_image
	docker run -it \
		-v $(CURDIR):/workspace \
		$(DOCKER_IMAGE) \
		make $*
