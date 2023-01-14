# Magento 2.4.x Docker + MailHog + Multiple Website + Blackfire + Redis/Redisinsight + Elasticsearch + Rabbitmq

Docker based Magento local dev environment:

Magento 2.4.3, Nginx 1.18, PHP 7.4-fpm-buster, Mariadb 10.4, Xdebug(Phpstorm), Redis/Redisinsight, Elasticsearch, Rabbitmq, Mariadb, Phpmyadmin, Varnish.

Usage:

This configuration is intended to be used as a Docker-based local development environment for Magento 2.4.3.

Prerequisites:

This setup assumes you are running Docker on a computer with at least 6GB of RAM allocated to Docker, a dual-core, and an SSD hard drive. Download & Install Docker Desktop.

This configuration has been tested on Mac Intel chip.

For mac with M1 chip kindly add the below line for each image as below in services in docker-compose.yml file

Reference image link: https://ibb.co/7Jn1DrX

* platform: linux/x86_64

Configuration Steps:

Step 1: Create folder for the project and git clone magento2-docker repository by clicking here

Step 2: Navigate to magento2-docker, create folder magento24 where our magento instance will be configured at the later stage and build the docker images.

  * docker-compose up --build -d

Step 3: To view the running docker containers use docker ps on the terminal.

Reference image: https://ibb.co/8jgj7hx

Step 4: Execute below command to install the fresh Magento project

run composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.3-p1 .
The above will download Magento 2.4.3-p1 in root directory which is magento24
Install M2 by via CLI
bin/magento setup:install \
--db-host=mariadb \
--db-name=mage24_db \
--db-user=mage24_user \
--db-password=mage24_pass \
--base-url=http://magento2.local/ \
--backend-frontname=admin \
--admin-user=admin \
--admin-password=admin123 \
--admin-email=firasath90@gmail.com \
--admin-firstname=Firas \
--admin-lastname=Mohammed \
--language=en_US \
--currency=AED \
--timezone=America/Chicago \
--use-rewrites=1 \
--skip-db-validation \
--search-engine=elasticsearch7 \
--elasticsearch-host=elasticsearch \
--elasticsearch-port=9200 \
&& chown -R www-data:www-data .

Step 5: Cross check if ES is configured, if not update the below setting in app/etc/env.php

'system' => [
                'default' => [
                    'catalog' => [
                        'search' => [
                            'engine' => 'elasticsearch7',
                            'elasticsearch7_server_hostname' => 'elasticsearch',
                            'elasticsearch7_server_port' => '9200',
                            'elasticsearch7_index_prefix' => 'magento24_index'
                        ]
                    ]
                ]
            ],

Step 6: Make sure cache enabled

* bin/magento cache:enable

Step 7: Configure Redis default/page caching

* php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-port=6379 --cache-backend-redis-db=0
* bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1

Step 8: Configure Redis for session storage

* bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis --session-save-redis-port=6379 --session-save-redis-log-level=4 --session-save-redis-db=2

Step 9: Run deploy.sh(get it from github ()) file via CLI

* sh deploy.sh

Step 10: Configure your hosts file to add 127.0.0.1 magento2.local:

-> For mac: 127.0.0.1 magento2.local in /etc/hosts

-> For Windows: 127.0.0.1 magento2.local c:\Windows\System32\Drivers\etc\hosts

Project setup is now complete and use below links to navigate to the project:

->Open for frontend: http://magento2.local/

->Open for admin panel: http://magento2.local/admin

->Admin credentials (for fresh magento installation only this is given at the time of installing magento via CLI):

  * username: admin

  * password: admin123

Tree
```
├── CHANGELOG.md
├── README.md
├── docker
│   ├── nginx
│   │   ├── Dockerfile
│   │   ├── default.conf
│   │   └── m2-config
│   │       └── nginx.conf
│   └── php
│       ├── Dockerfile
│       └── www.conf
│   └── varnish
│       ├── varnish6
│       │   ├── Dockerfile
│       │   └── start.sh
│       ├── newsecret.sh
│       ├── varnish.secret
│       └── varnish6.vcl
├── docker-compose.dev.yml
├── docker-compose.yml
└── magento24
```

In case of any questions please feel free to contact: firasath90@gmail.com
