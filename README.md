# DOTS!
currently this is a somewhat experimental effort to generalize my nixos configuration for other distros.
why not just use home-manager, you ask? well, that isn't a bad question. perhaps i'll address it in a blog post.

## usage
```
./setup.sh
```
- attempts to link all the config files which have been ported from home-manager output.
- detect distro in use
- run the appropriate install script in `./distro`
