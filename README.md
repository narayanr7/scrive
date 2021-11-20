# Scribe - An Alternative Medium Frontend

This is a project written using [Lucky](https://luckyframework.org). It's main website is [scribe.rip](https://scribe.rip).

## Deploying Your Own

I'd love it if you deployed your own version of this app! A [few others](docs/instances.md) have already. To do so currently will take some knowledge of how a webserver runs. This app is built with the [Lucky framework](https://luckyframework.org) and there are a bunch of different ways to deploy. The main instance runs on [Ubuntu](https://luckyframework.org/guides/deploying/ubuntu) but there are also directions for [Heroku](https://luckyframework.org/guides/deploying/heroku) or [Dokku](https://luckyframework.org/guides/deploying/dokku).

One thing to note is that this app doesn't currently use a database. Any instructions around postgres can be safely ignored. However, Lucky (and it's dependency Avram) do require a `DATABASE_URL` formatted for postgres. It doesn't need to be the URL of an actual database server though. Here's mine: `DATABASE_URL=postgres://does@not/mater`

Hopefully a more comprehensive guide will be written at some point, but for now feel free to reach out to the [mailing list](https://lists.sr.ht/~edwardloveall/scribe) if you have any questions.

### Docker (Unsupported)

A Dockerfile is included to build and run your own OCI images. I don't use Docker personally so this is all community created and supported. If it breaks, please write to the [mailing list](https://lists.sr.ht/~edwardloveall/scribe).

To build:

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

## Project goals

I believe that Medium is a bad actor on the web. They offer a [bad reading experience](https://twitter.com/BretFisher/status/1206766086961745920). Writing there [benefits Medium](https://www.manton.org/2016/01/15/silos-as-shortcuts.html) more than the author. Counter to their promise of a wider reach, [they offer worse SEO](https://pawelurbanek.com/medium-blogging-platform-seo). They use [extortionist business tactics](https://www.cdevn.com/why-medium-actually-sucks/). Finally, they want to [centralize the currently decentralized world of blogging](http://scripting.com/liveblog/users/davewiner/2016/01/20/0900.html).

Since Scribe uses Medium content, I don't want to help people engage with it more than they must. My goal here is not to make a nicer Medium to engage with, but to make a less bad experience when people are forced to engage with it. I want Scribe to be a tool, not a platform.

It's intentional that there is no way to browse content from a user, see popular posts, consume via an RSS feed, or further engage with an article via comments or "claps". I want to spend my time encouraging writers to move to worthy platforms, not making a bad platform worthy.

## Contributing

1. Install required dependencies (see sub-sections below)
1. Run `script/setup`
1. Run `lucky dev` to start the app
1. [Send a patch](https://man.sr.ht/git.sr.ht/#sending-patches-upstream) to `~edwardloveall/Scribe@lists.sr.ht` (it may not look like it at first, but that's an email address).

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
