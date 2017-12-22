# edx-ginkgo-docker
A dockerized version of Open edX running `open-release/ginkgo.master` version.
(Only LMS and Studio for now)

### Requirements:

```
docker (version 17.09 or higher)
docker-compose (version 1.17.1 or higher)
```

### Installation

If you want to build your own images rename `karacic/<image_name>` with `<username>/<image_name>`
in the Makefile and run these commands:

1. `make build.base`
2. `make build.edxapp`

If you want to use the existing ones run these commands to install the containers:

1. `make clone`
2. `make provision`
3. `docker-compose stop`
4. `make up`

### Theming

You will notice that a new `edx-themes` directory has been created next to the cloned `edx-platform` directory.
That directory is mapped to `/edx-themes` in the LMS and Studio containers. With that information continue following
[these instruction](http://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/open-release-ginkgo.master/configuration/changing_appearance/theming/enable_themes.html) on how to apply a new theme.

### Troubleshooting

In case the CSS is missing in either LMS or Studio, you can run `make static` to rebuild the static assets for both.

### Bug reporting

I would very much appreciate any bug reports, so if you find a bug please [open an issue](https://github.com/vkaracic/edx-ginkgo-docker/issues/new) for it.
