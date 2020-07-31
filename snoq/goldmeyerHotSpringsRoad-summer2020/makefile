ID = 31jul2020
APP_IMAGE_NAME = snoqmap_app_$(ID)

build:
	docker build -t $(APP_IMAGE_NAME) -f Dockerfile .

bash:
	docker run -it \
           -p 3838:6789 \
           --entrypoint /bin/bash \
           $(APP_IMAGE_NAME)

