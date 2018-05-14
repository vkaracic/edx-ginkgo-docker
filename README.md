# edx-ginkgo-docker
A dockerized version of Open edX running `open-release/ginkgo.master` version.
(Only LMS and Studio for now)

## Requirements:

```
docker (version 17.09 or higher)
docker-compose (version 1.17.1 or higher)
```

## Installation

### Before installation

Export the `CONTAINER_PREFIX` environment variable to differentiate container between projects:

`export CONTAINER_PREFIX=<project_name>`

If you want to build your own images rename `karacic/<image_name>` with `<username>/<image_name>`.

Now your edxapp image will be named `<username>/<CONTAINER_PREFIX-ginkgo.master`.
If you haven't renamed the image in the Makefile file, the edxapp image will be named `karacic/<CONTAINER_PREFIX>-ginkgo.master`.

**IMPORTANT:** if you already have a set of devstack containers that you are working with on a different project, rename the volumes in `doker-compose.yml` to something unique, otherwise both projects use the same volumes and override each other.

### Installation

1. `make build.base`
2. `make build.edxapp`
3. `make clone`
4. `make provision`
5. `docker-compose stop`
6. `make up`

The provision step will create a new `.env` file that contains the `CONTAINER_PREFIX` variable so that you don't need to export it every time you start up the containers.

### After installation

In your `edx-platform` folder search for `edx.devstack.` term. Change those instance with your `CONTAINER_PREFIX` value (for example: `edx.devstack.lms -> my_project.lms`). Most of them are related to tests which you can skip if you don't intend to run tests.

## Theming

You will notice that a new `edx-themes` directory has been created next to the cloned `edx-platform` directory.
That directory is mapped to `/edx-themes` in the LMS and Studio containers. With that information continue following
[these instruction](http://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/open-release-ginkgo.master/configuration/changing_appearance/theming/enable_themes.html) on how to apply a new theme.

## Troubleshooting

In case the CSS is missing in either LMS or Studio, you can run `make static` to rebuild the static assets for both.

## Bug reporting

I would very much appreciate any bug reports, so if you find a bug please [open an issue](https://github.com/vkaracic/edx-ginkgo-docker/issues/new) for it.
