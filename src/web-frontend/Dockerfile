FROM node:12.11.1 as builder

RUN apt-get update

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY . /app
RUN npm install
RUN npm install -g @angular/cli
RUN ng build --prod --output-path=/app/dist

FROM nginx:1.17.0-alpine as production

USER root

COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/default.conf /etc/nginx/conf.d

RUN nginx

EXPOSE 80

LABEL maintainer="Engin Polat (polatengin) <enpolat@microsoft.com>" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name="Oslo project" \
      org.label-schema.vcs-type="Git" \
      org.label-schema.vcs-url="https://github.com/polatengin/oslo"
