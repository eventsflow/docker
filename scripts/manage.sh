#!/bin/sh

set -eu

if [[ $# -eq 0 ]]; then
    echo "[ERROR] Please specify 'help' argument for more information"
    exit 1
fi


# GitLab Docker Registry
GITLAB_DOCKER_REGISTRY="gitlab.com"


case ${1} in
    help)
        echo 'Available options:'
        echo ' update-base-images       - update base images: alpine, ubuntu, ..'
        echo ' build                    - build docker image'
        echo ' test                     - run tests for docker image'
        echo ' remove                   - remove docker image'
        echo ' publish-to-gl-registry   - publish docker image to GitLab Registry'
        echo ' console                  - run console for specific image'
        ;;
    update-base-images)
        echo "[INFO] Updating base images" && \
            docker pull alpine:3.12
            docker pull ubuntu:20.04
        ;;
    build)
        shift
        DOCKERFILE_PATH=${1:-}

        [ -z "${DOCKERFILE_PATH}" ] && {
            echo "[ERROR] Please specify the image name by 'image' parameter"
            exit 1
        } || {
            echo "[INFO] Building image: ${DOCKERFILE_PATH}"
            cd ${DOCKERFILE_PATH}
            source metadata

            # Build docker image
            docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} .
        }
        ;;
    test)
        shift
        DOCKERFILE_PATH=${1:-}

        [ -z "${DOCKERFILE_PATH}" ] && {
            echo "[ERROR] Please specify the image name by 'image' parameter"
            exit 1
        } || {
            echo "[INFO] Tesing image: ${DOCKERFILE_PATH}"
            cd ${DOCKERFILE_PATH}
            source metadata

            # Run tests for docker image
            docker run --rm -v $(pwd)/tests:/tests \
		            ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} /tests/run-tests.sh
        }
        ;;
    remove)
        shift
        DOCKERFILE_PATH=${1:-}

        [ -z "${DOCKERFILE_PATH}" ] && {
            echo "[ERROR] Please specify the image name by 'image' parameter"
            exit 1
        } || {
            echo "[INFO] Removing image from path: ${DOCKERFILE_PATH}"
            cd ${DOCKERFILE_PATH}
            source metadata
            
            # Remove docker image 
            docker image rm ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}
        }
        ;;
    # publish-to-gh-registry)
    #     shift
    #     DOCKERFILE_PATH=${1:-}
    #     GITHUB_USERNAME=${2:-}
    #     GITHUB_TOKEN=${3:-}

    #     [ -z "${DOCKERFILE_PATH}" ] && {
    #         echo "[ERROR] Please specify the image name by 'image' parameter"
    #         exit 1
    #     } || {
    #         echo "[INFO] Publish image from path: ${DOCKERFILE_PATH} to GitHub Registry: ${GITHUB_DOCKER_REGISTRY}"
    #         cd ${DOCKERFILE_PATH}
    #         source metadata
    #         echo "${GITHUB_TOKEN}" | docker login ${GITHUB_DOCKER_REGISTRY} \
    #                                         -u ${GITHUB_USERNAME} --password-stdin
            
    #         # GITHUB_DOCKER_IMAGE_ID
    #         GITHUB_DOCKER_IMAGE_ID=${GITHUB_DOCKER_REGISTRY}/eventsflow/eventsflow-docker
    #         GITHUB_DOCKER_IMAGE_ID=${GITHUB_DOCKER_IMAGE_ID}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}

    #         # Tag docker image with GitHub Docker Registry
    #         docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${GITHUB_DOCKER_IMAGE_ID}
            
    #         # Push docker image to GitHub Docker Registry
    #         docker push ${GITHUB_DOCKER_IMAGE_ID}
    #     }
    #     ;;
    console)
        shift
        DOCKERFILE_PATH=${1:-}

        [ -z "${DOCKERFILE_PATH}" ] && {
            echo "[ERROR] Please specify the path to Dockerfile"
            exit 1
        } || {
            echo "[INFO] Running console for image: ${DOCKERFILE_PATH}"
            cd ${DOCKERFILE_PATH}
            source metadata
            echo "[INFO] The image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}, the container name: ${DOCKER_IMAGE_NAME}-console"

            # Open console
            docker run -ti --rm --name ${DOCKER_IMAGE_NAME}-console \
                ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} \
                ${DOCKER_IMAGE_SHELL}
        }
        ;;
    *)
        if [ ! "$@" ]; then
            echo "[WARNING] No arguments specified, use help for more details" 
        else
            exec "$@"
        fi
        ;;
esac 
