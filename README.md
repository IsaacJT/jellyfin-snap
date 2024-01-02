# jellyfin-snap

Snap package for the [Jellyfin media server](https://jellyfin.org/).

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/itrue-jellyfin)

*This is a community-developed snap and not officially supported or released by Jellyfin.*

## Instructions

Make sure that all of the Snap interfaces are connected before running:

```
snap connect itrue-jellyfin:home
snap connect itrue-jellyfin:removable-media
snap connect itrue-jellyfin:mount-observe
snap connect itrue-jellyfin:firewall-control
```

Verify that there are no unconnected interfaces with the `snap connections` command. The output should look something like this:

```
$ snap connections itrue-jellyfin
Interface         Plug                             Slot               Notes
firewall-control  itrue-jellyfin:firewall-control  :firewall-control  manual
home              itrue-jellyfin:home              :home              -
mount-observe     itrue-jellyfin:mount-observe     :mount-observe     manual
network           itrue-jellyfin:network           :network           -
network-bind      itrue-jellyfin:network-bind      :network-bind      -
opengl            itrue-jellyfin:opengl            :opengl            -
removable-media   itrue-jellyfin:removable-media   :removable-media   manual
```

Due to Snap restrictions, any external storage needs to be mounted to a directory under `/media`.

The web UI will be available at the default Jellyfin address <http://localhost:8096>.

Hardware acceleration support can be tested and debugged using the `itrue-jellyfin.vainfo`, `itrue-jellyfin.ffmpeg`, and `itrue-jellyfin.clinfo` commands.

## TODO

- Hardware acceleration support
  - Intel partially supported (YMMV)
  - AMD is a work-in-progress
  - Nvidia is not supported due to the proprietary binaries
