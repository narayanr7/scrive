# Scribe - An Alternative Medium Frontend

This is a project written using [Lucky](https://luckyframework.org). It's main website is [scribe.rip](https://scribe.rip).

## Deploying Your Own

I'd love it if you deploy your own version of this app! To do so currently will take some knowledge of how a webserver runs. If you want to give it a shot, there are a bunch of different ways to deploy. The main site runs on [Ubuntu](https://luckyframework.org/guides/deploying/ubuntu) but there are also directions for [Heroku](https://luckyframework.org/guides/deploying/heroku) or [Dokku](https://luckyframework.org/guides/deploying/dokku).

One thing to note is that this app doesn't currently use a database. Any instructions around postgres can be safely ignored. Lucky (and it's dependency Avram) however does need a `DATABASE_URL` formatted for postgres. It doesn't need to be the URL of an actual database server though. Here's mine: `DATABASE_URL=postgres://does@not/mater`

Hopefully a more comprehensive guide will be written at some point, but for now feel free to reach out if you have any questions. My contact info can be found on [my website](https://edwardloveall.com).

### Docker

A Dockerfile is included to build and run your own OCI images. To build:

```
$ docker build [--build-arg PUID=1000] [--build-arg PGID=1000] -t scribe:latest -f ./Dockerfile .
```

To run (generating a base config from environment variables):

```
$ docker run -it --rm -p 8080:8080 -e SCRIBE_PORT=8080 -e SCRIBE_HOST=0.0.0.0 -e SCRIBE_DB=postgres://does@not/matter scribe:latest
```

To run with mounted config from local fs:

```
$ docker run -it --rm -v `pwd`/config/watch.yml:/app/config/watch.yml -p 8080:8080 scribe:latest
```

## Contributing

1. Install required dependencies (see sub-sections below)
1. Run `script/setup`
1. Run `lucky dev` to start the app
1. [Send a patch](https://man.sr.ht/git.sr.ht/#sending-patches-upstream) to `~edwardloveall/Scribe@lists.sr.ht` (yes that's an email address).
  * To be honest, I'm not sure how I feel about the send patch git workflow as opposed to the GitHub style pull request workflow. I'm trying it out for now. If you can't figure it out, get in contact and we can figure out a way to get your contributions in.

### Installing dependencies

General instructions for installing Lucky and its dependencies can be found at <https://luckyframework.org/guides/getting-started/installing#install-required-dependencies>.

### Installing dependencies with Nix

If you are using the [Nix](https://nixos.org/) package manager, you can get a shell with all dependencies with the following command(s):

``` shell
nix-shell

# Or if you are using the (still experimental) Nix Flakes feature
nix flake update # Update dependencies (optional)
nix develop
```

### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
