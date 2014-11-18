# Apache Docker Container

This is a docker container for running websites under Apache 2. It is designed
to be very minimal, but in such a way that extending it is easy. Apache listens
on port 8080 inside the container and runs in the foreground under a
non-privileged user. [d11wtq/php-docker](https://github.com/d11wtq/php-docker)
is built based on this image.

## Usage

Apache is run in the foreground with a minimal config that can be found at in
the [www/](https://github.com/d11wtq/apache-docker/blob/master/www) directory
of the GitHub repository for this container.

### Testing

Without any special configuration, the index page will serve up an "It works!"
page. This should demonstrate that the container is working correctly.

```
docker run -p 8080:8080 d11wtq/apache
```

Accessing http://localhost:8080/ should show the "It works!" page and Apache
logs should be written to stdout.

### Defaults

I have made no attempts to create an exhaustive configuration for Apache,
rather focusing on setting a handful of minimal and sensible defaults and
ensuring it is easy to override these defaults. In summary, the defaults are:

  * mod_dir
  * mod_authz_core
  * mod_unixd
  * mod_mime
  * mod_log_config
  * mod_access_compat
  * Forking (not MPM)
  * Port 8080
  * Default charset 'UTF-8'
  * Loglevel 'info'
  * Logging to stdout

### Configuration

The document root is set to /www/htdocs/ and you are expected to mount this
directory as a volume, or add it to the container, using this image as the base
image.

The main httpd.conf file resides in /www/httpd.conf, however it only loads some
essential modules in order for Apache to function.

Extending the basic Apache 2 configuration can be done by adding \*.conf files
to /www/httpd.conf.d/, again either by mounting a volume, or by using this
image as a base image.

If you know what you're doing, feel free to mount the entire /www/ directory
as a volume and disregard the above, but make sure it contains at least an
httpd.conf. Apache has been installed with `--prefix=/usr/local`.

### Examples

Here's an example of serving a static website with mod_rewrite loaded, using
shared volumes.

```
# Start Apache, mounting a volume for the doc root
docker run -d                          \
  --name website                       \
  -p 8080:8080                         \
  -v /path/to/website:/www/htdocs      \
  -v /path/to/conf.d:/www/httpd.conf.d \
  d11wtq/apache
```

The contents of /path/to/website/ would be the directory including the
index.html of the website. The contents of /path/to/conf.d/ would be a file
named mod_rewrite.conf, with the contents:

``` apache
LoadModule rewrite_module modules/mod_rewrite.so
```

Now accessing http://localhost:8080/, you should see your website.

Here's the same example using a Dockerfile to create a new image, using this
image as the base image:

``` docker
FROM       d11wtq/apache:latest
MAINTAINER Your Name

ADD /path/to/website /www/htdocs
ADD /path/to/conf.d  /www/httpd.conf.d
```

Now build the new image:

```
docker build --rm -t your-website .
```

And run it with:

```
# Start the Website
docker run -d    \
  --name website \
  -p 8080:8080   \
  your-website
```

You should be able to provide most needed configuration using this layout.
