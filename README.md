# docker-laravel-deployer

### Table of Contents

* [Introduction](#introduction)
* [Development](#development)
* [2023 September](#2023-september)
* [Potential Breaking Changes](#potential-breaking-changes)
* [Resources](#resources)

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
4. Build your new image to test: `docker build ./7.3 -t w0rddriven/docker-laravel-deployer:7.3`.
5. Troubleshoot any breaking changes.
   1. Occasionally you may have to track a deviation further up the stack.
      1. Since we're running `php:7.3-fpm` you should inspect [the list of supported tags](https://github.com/docker-library/docs/blob/master/php/README.md#supported-tags-and-respective-dockerfile-links) to see what that image is built from.
   2. In the case of 7.3, `libzip` is no longer included so it needs to be added explicitly.
      1. 7.2 also removed extensions so this is the most common type of problem you'll run into.
   3. Remove any previously cached images via the rmi command: `docker rmi w0rddriven/docker-laravel-deployer:7.3`.
   4. Remove any unused images `docker image prune --all`.
6. Push the local image to Docker Hub (required as automated builds are no longer enabled)
   1. `docker push w0rddriven/docker-laravel-deployer:8.1`
   2. Repeat as necessary for all tags. As of 8/2022 this should be 7.4, 8.0, 8.1, and latest (8.1).

## 2023 September

Due to what looks like breaking changes with `bookworm` based images, which affect PHP 8.1 and 8.2 so far, we've explicitly referenced the `bullseye` base via `FROM php:8.2-fpm-bullseye`.
There may be a trick to get this working or PHP upstream has to correct something but considering this affects Python, another dynamic interpreted language something tells me that may not happen unless `bookworm` itself handles it.

See [https://forum.gitlab.com/t/jobs-fails-shell-not-found-version-python/88340](https://forum.gitlab.com/t/jobs-fails-shell-not-found-version-python/88340) for details.

While I was on an older version of the Gitlab runner i.e. `Unpacking gitlab-runner (16.3.1) over (15.9.1) ...`, upgrading this didn't help.
I will try again moving the runner itself to a newer Ubuntu version because the VM needs a refresh but I don't expect anything new.

## Potential Breaking Changes

1. As of 8/2022 the PHP 8.0, 8.1, and latest images have moved to Composer 2. See [#25](https://github.com/w0rd-driven/docker-laravel-deployer/issues/25).
   1. This was due to `doctrine/dbal` needing `composer-runtime-api ^2` and not surprising given [something like this](https://www.doctrine-project.org/2017/07/25/php-7.1-requirement-and-composer.html).
   2. It's a little unclear what this may break downstream so far. At Rethink Group, we're likely going to have the requirement that Laravel 8+, PHP 8+, etc use Composer 2. This possibly requires manually patching older servers.
2. We're also only supporting 7.4, 8.0, and 8.1 to keep somewhat in lock step with Laravel Sail.
   1. Building any older images risks a very new deployer on a very old PHP version, which may be safe but I don't like risking it.
   2. It's very tempting to remove deployer but that also changes the name of the package if I'm being pedantic.
   3. It took a long time to realize deployer is likely best as a local dependency. There are trade offs and annoyances in any approach but you rely on a nebulous upstream otherwise.
   4. I don't have any user data to know if anyone outside of our organization really uses this. I would personally look into Laravel Sail if I were starting this in 2022 and in fact [had the idea and abandoned it with Fly.io](https://github.com/w0rd-driven/docker-laravel-fly-io). Sail may be completely usable as-is for development or CI/CD workloads but you want something like Nginx in front of production workloads. Sail does not have that.
3. I don't know how much longer I'll stay active in the Laravel/PHP community.
   1. I've been using PHP likely the longest at this point if I count the FAQs/knowledgebase I supported as a systems admin nearly 2 decades ago.
   2. I went from C#, to PHP, and now Elixir has been calling my name for some time.
   3. Elixir has amazing DX but it really has nowhere near the number of useful packages the Laravel community does. It may be completely unfair to want a company like Spatie in every ecosystem but no organization may ever have that kind of range in any ecosystem.
4. I would hand this off to the right entity but there is a lot currently tied to the w0rddriven/* builds that I intend to keep indefinitely.
   1. If this ever changes, I'd communicate it far ahead of time.
   2. All bets are obviously off if my Docker account gets hacked or they drop really old builds.

## Resources

    1. [Docker in Development](https://serversforhackers.com/s/docker-in-development)
    2. Docker
        1. [Docker Hub for official PHP image](https://hub.docker.com/_/php).
        2. [Github repository for official PHP image](https://github.com/docker-library/php).
