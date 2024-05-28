#!/bin/sh -ex

REQUIRED_INTERFACES="network network-bind"
OPTIONAL_INTERFACES="home removable-media mount-observe opengl firewall-control"

for intf in ${REQUIRED_INTERFACES}; do
        if ! snapctl is-connected "${intf}"; then
                echo "Required interface is not connected: ${intf}"
                echo ""
                echo "Please connect this interface using the following command:"
                echo "snap connect ${SNAP_NAME}:${intf}"
                exit 1
        fi
done

for intf in ${OPTIONAL_INTERFACES}; do
        if ! snapctl is-connected "${intf}"; then
                echo "Optional interface is not connected: ${intf}"
                echo "This is recommended to ensure best usage of this program."
                echo ""
                echo "Please connect this interface using the following command:"
                echo "snap connect ${SNAP_NAME}:${intf}"
        fi
done

exec "${SNAP}"/usr/lib/jellyfin/bin/jellyfin --service \
        --ffmpeg "${SNAP}"/usr/lib/jellyfin-ffmpeg/ffmpeg
