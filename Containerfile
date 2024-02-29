ARG BASE_IMAGE_NAME=fedora
ARG BASE_IMAGE_TAG=39
ARG BASE_IMAGE_REGISTRY=

ARG DIGITAL_COCKPIT_USER=digital-cockpit
ARG DIGITAL_COCKPIT_HOME=/var/lib/digital-cockpit

# Build stage
###############################################################################
FROM ${BASE_IMAGE_REGISTRY}${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} as build

WORKDIR /code

COPY ./meson.build /code/meson.build
COPY ./demo-app.c  /code/demo-app.c

RUN dnf -y install gtk4-devel                                                 \
                   meson                                                      \
                   ninja-build                                                \
                   gcc                                                        \
    && meson setup --prefix=/usr/local builddir                               \
    && ninja -C builddir                                                      \
    && ninja -C builddir install                                              \
    && dnf clean all && rm -rf /var/cache/dnf

# Demo App Image
###############################################################################
FROM ${BASE_IMAGE_REGISTRY}${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} AS base

ARG DIGITAL_COCKPIT_USER
ARG DIGITAL_COCKPIT_HOME

RUN dnf -y install gtk4                                                      \
    && dnf clean all && rm -rf /var/cache/dnf
COPY --from=build /usr/local/bin/demo-app /usr/local/bin/autosd-demo

USER $DIGITAL_COCKPIT_USER
WORKDIR $DIGITAL_COCKPIT_HOME
