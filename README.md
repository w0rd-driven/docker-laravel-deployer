# docker-laravel-deployer-5.6
Docker image build for use with Laravel 5.x, including [deployer](http://deployer.org/).

Based on work from [Ian Olson](https://gist.github.com/iolson), specifically https://gist.github.com/iolson/791fb1c1d1a8cfb5ffa7 and https://gist.github.com/iolson/5e3695bc5c9f7afafeb3 as well as [The Laravel 5.1 Starter](https://gitlab.com/nasirkhan/laravel-5-starter/blob/master/.gitlab-ci.yml).

As a general rule, to speed up GitLab CI builds it is better to bake in any apt-get or composer package, within reason. The largest bottleneck is the network latency of working with the various package managers on the Digital Ocean network. 

Configuring a dedicated droplet showed identical build times that I initially thought may have been attributed to load but that doesn't appear to be the case. Even with caching both apt-get and eventually composer and vendor directories, builds were still comparable.

As of 10/5/2016, this image was largely in a private registry which meant it could only be ran via a dedicated runner. Shared runners don't have the capability to expose the "docker login" requisite yet, but it is coming. The hope in making this public is the shared runners can benefit from a relatively streamlined and custom image for our needs.

There are more feature-rich Laravel docker images like https://hub.docker.com/r/bobey/docker-gitlab-ci-runner-php5.6/ if this isn't suitable for your needs.
