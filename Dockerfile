FROM drupal:7

RUN apt-get update && apt-get install -y --no-install-recommends \
      # for bz2
      bzip2 libbz2-dev \
      # for ftp
      libssl-dev \
      # for gd
      libfreetype6-dev \
      # for intl
      libicu-dev \
      # for dom
      libxml2-dev \
      # for ldap
      libldap2-dev \
      # for mcrypt
      libmcrypt-dev \
      # for memcached
      libz-dev libmemcached-dev \
      # for mysql
      mysql-client \
      # for drush sql:sync
      rsync \
      # for git
      git \
      # for ssh client only
      openssh-client \
      # For image optimization
      jpegoptim \
      optipng \
      pngquant \
      # For imagick
      imagemagick \
      libmagickwand-dev \
      # for yaml
      libyaml-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) \
      bcmath \
      bz2 \
      calendar \
      exif \
      ftp \
      gettext \
      intl \
      ldap \
      mcrypt \
      mysqli \
      pcntl \
      shmop \
      soap \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
    && pecl install apcu memcached raphf propro yaml imagick \
    && docker-php-ext-enable apcu memcached raphf propro yaml imagick \
    && pecl install pecl_http-3.1.0 \
    && docker-php-ext-enable http \
    && printf "upload_max_filesize = 128M\npost_max_size = 128M" > $PHP_INI_DIR/conf.d/00-max_filesize.ini
