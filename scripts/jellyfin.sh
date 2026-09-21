#!/bin/sh -e
# SPDX-License-Identifier: GPL-2.0-only

REQUIRED_INTERFACES="network network-bind"
OPTIONAL_INTERFACES="home removable-media mount-observe opengl firewall-control"

missing_required=""
for intf in ${REQUIRED_INTERFACES}; do
        if ! snapctl is-connected "${intf}"; then
                missing_required="${missing_required} ${intf}"
        fi
done

if [ -n "${missing_required}" ]; then
        echo "Required interfaces are not connected:${missing_required}"
        echo ""
        echo "Please connect them using the following commands:"
        for intf in ${missing_required}; do
                echo "snap connect ${SNAP_NAME}:${intf}"
        done
        exit 1
fi

missing_optional=""
for intf in ${OPTIONAL_INTERFACES}; do
        if ! snapctl is-connected "${intf}"; then
                missing_optional="${missing_optional} ${intf}"
        fi
done

if [ -n "${missing_optional}" ]; then
        echo "Optional interfaces are not connected:${missing_optional}"
        echo "Connecting them is recommended to ensure best usage of this program."
        echo ""
        echo "Please connect them using the following commands:"
        for intf in ${missing_optional}; do
                echo "snap connect ${SNAP_NAME}:${intf}"
        done
fi

exec "${SNAP}"/usr/lib/jellyfin/bin/jellyfin --service \
        --ffmpeg "${SNAP}"/usr/lib/jellyfin-ffmpeg/ffmpeg \
        --datadir "${SNAP_COMMON}"/data \
        --configdir "${SNAP_COMMON}"/config \
        --cachedir "${SNAP_COMMON}"/cache \
        --logdir "${SNAP_DATA}"/logs \
        --webdir "${SNAP}"/usr/share/jellyfin/web
