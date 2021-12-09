FROM node:13-stretch

RUN apt-get update -qq && apt-get install vim -yqq

# Download and install hugo
ENV HUGO_VERSION 0.82.0
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.tar.gz
RUN tar xzf /tmp/hugo.tar.gz -C /tmp \
  && mv /tmp/hugo /usr/local/bin/ \
  && rm /tmp/hugo.tar.gz \
  && mkdir -p /run

RUN npm install -g autoprefixer
RUN npm install -g postcss-cli

ADD . /app
WORKDIR /app

ARG URL
ENV URL=${URL:-"https://docs.storageos.com"}

ARG ROOT_VERSION
ENV ROOT_VERSION=${ROOT_VERSION:-v2.4}

ENV DEST_DIR="/tmp/docs-output"
RUN ./build/_generate-site-output.sh -d $DEST_DIR -u $URL -r $ROOT_VERSION

FROM nginx:1.19

ENV SOURCE_DIR="/tmp/docs-output"
COPY --from=0 $SOURCE_DIR /usr/share/nginx/html/
