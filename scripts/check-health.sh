#!/bin/sh -e
# SPDX-License-Identifier: GPL-2.0-only
#
# Checks the health of the Jellyfin daemon and reports it to snapd via
# "snapctl set-health". Invoked periodically by the "health-check" app
# (daemon: oneshot, timer: ...) in snap/snapcraft.yaml.

CURL="${SNAP}/usr/bin/curl"
HEALTH_URL="http://localhost:8096/health"

# These match REQUIRED_INTERFACES in scripts/jellyfin.sh: without them the
# daemon can't even start, so there's no point polling the health endpoint
# below -- go straight to "blocked" and point the user at the fix.
REQUIRED_INTERFACES="network network-bind"

for intf in ${REQUIRED_INTERFACES}; do
	if ! snapctl is-connected "${intf}"; then
		snapctl set-health blocked \
			"Required interface is not connected: ${intf}" \
			--code=interface-not-connected
		exit 0
	fi
done

# Give the daemon a short window to accept connections/respond before
# judging it. This keeps transient slow-starts from being reported as
# "error" on every run of this check.
ATTEMPTS=5
DELAY=1

i=0
while [ "$i" -lt "$ATTEMPTS" ]; do
	if body="$("${CURL}" --max-time 5 --silent --show-error --fail "${HEALTH_URL}" 2>/dev/null)"; then
		if [ "${body}" = "Healthy" ]; then
			snapctl set-health okay
			exit 0
		fi

		snapctl set-health error \
			"Jellyfin reported an unhealthy status: ${body}" \
			--code=unhealthy-response
		exit 0
	fi

	i=$((i + 1))
	[ "$i" -lt "$ATTEMPTS" ] && sleep "$DELAY"
done

# The service never became reachable. Distinguish "still starting up" from
# "crashed" using the daemon's own service state where possible.
if snapctl services 2>/dev/null | tail -n +2 | awk '{print $3}' | grep -q "^active$"; then
	snapctl set-health waiting \
		"Waiting for the Jellyfin web server to become reachable" \
		--code=waiting-for-web-server
else
	snapctl set-health error \
		"The Jellyfin daemon is not running" \
		--code=daemon-not-running
fi
