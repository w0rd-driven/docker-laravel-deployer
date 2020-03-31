# docker-laravel-deployer

## Introduction

Docker image build for use with Laravel 5.x, including [deployer](http://deployer.org/).

Based on work from [Ian Olson](https://gist.github.com/iolson), specifically
[https://gist.github.com/iolson/791fb1c1d1a8cfb5ffa7](https://gist.github.com/iolson/791fb1c1d1a8cfb5ffa7) and
[https://gist.github.com/iolson/5e3695bc5c9f7afafeb3](https://gist.github.com/iolson/5e3695bc5c9f7afafeb3) as well as
[The Laravel 5.1 Starter](https://gitlab.com/nasirkhan/laravel-5-starter/blob/master/.gitlab-ci.yml).

As a general rule, to speed up GitLab CI builds it is better to bake in
any apt-get or composer package, within reason. The largest bottleneck is
the network latency of working with the various package managers on the
Digital Ocean network.

Configuring a dedicated droplet showed identical build times that I initially
thought may have been attributed to load but that doesn't appear to be the
case. Even with caching both apt-get and eventually composer and vendor
directories, builds were still comparable.

As of 10/5/2016, this image was largely in a private registry which meant
it could only be ran via a dedicated runner. Shared runners don't have the
capability to expose the "docker login" requisite yet, but it is coming. The
hope in making this public is the shared runners can benefit from a
relatively streamlined and custom image for our needs.

There are more feature-rich Laravel docker images like
[https://hub.docker.com/r/bobey/docker-gitlab-ci-runner-php5.6/](https://hub.docker.com/r/bobey/docker-gitlab-ci-runner-php5.6/) if this
isn't suitable for your needs.

## Development

To support a new version of PHP:

1. Create a new top level directory, i.e. `7.3`.
2. Replicate the prior `Dockerfile`, essentially `cp 7.2/Dockerfile 7.3`.
3. Change the line `FROM php:7.2-fpm` to `FROM php:7.3-fpm`.
   1. This assumes the internal build tags don't change. Fortunately this tag is rather stable.
4. Build your new image to test: `docker build ./7.3 -t w0rd-driven/docker-laravel-deployer:7.3`.
5. Troubleshoot any breaking changes.
   1. Occasionally you may have to track a deviation further up the stack.
      1. Since we're running `php:7.3-fpm` you should inspect [the list of supported tags](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links) to see what that image is built from.
   2. In the case of 7.3, `libzip` is no longer included so it needs to be added explicitly.
      1. 7.2 also removed extensions so this is the most common type of problem you'll run into.
   3. Remove any previously cached images via the rmi command: `docker rmi w0rd-driven/docker-laravel-deployer:7.3`.
   4. Remove any unused images `docker image prune --all`.

Official PHP image links

   1. [Docker Hub for official PHP image](https://hub.docker.com/_/php).
   2. [Github repository for official PHP image](https://github.com/docker-library/php).
