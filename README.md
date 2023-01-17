**Docker based Magento local dev environment:**

**Magento 2.4.3, Nginx 1.18, PHP 7.4-fpm-buster, Mariadb 10.4, Xdebug(Phpstorm), Redis/Redisinsight, Elasticsearch, Rabbitmq, Mariadb, Phpmyadmin, Varnish.**

**Usage**:

This configuration is intended to be used as a Docker-based local development environment for Magento 2.4.3.

**Prerequisites:**

This setup assumes you are running Docker on a computer with at least 6GB of RAM allocated to Docker, a dual-core, and an SSD hard drive. Download & Install Docker Desktop.

_This configuration has been tested on Mac Intel chip only._

For mac with **M1 chip** kindly add the below line for each image as below in services in docker-compose.yml file

Reference image link: https://ibb.co/7Jn1DrX

`platform: linux/x86_64`

**Configuration Steps for Docker:**

Step 1: Create folder for the project and git clone **backend-docker-setup** repository by clicking https://github.com/Firas220890/backend-docker-setup.git

Step 2: Once the repository is cloned inside **backend-docker-setup** directory kindly rename the file **docker.env to .env**

Step 3: Navigate to **backend-docker-setup**, it consist of a folder named **magento24** where our magento instance will be configured at the later stage.

Step 4: Build docker images by running the below cli from terminal

`docker-compose up --build -d`

Step 5: To view the running docker containers execute `docker ps` on the terminal.

Reference image: https://ibb.co/8jgj7hx

_At this stage your all the required services to run Magento should be successfully installed and started._

Additionally phpmyadmin have also been setup for the ease of accessing the database.

Link: 127.0.0.1:8081

**Database credentials:**
Server: mariadb
username: mage24_user
password: mage24_pass

**Steps to install Magento:**

Step 1: Navigate to folder **backend-docker-setup** if not already in it.

Step 2: Execute below command to navigate to php instance of the docker

`docker exec -it php bash`
Once the above command is executed you will be navigated to docker environment as below:

`/var/www/html#`

Run below commands to navigate to our directory where magento will be installed:

`cd ..` - To go one step previous directory
`cd magento24` - Navigate to magento24 directory here our Magento will be installed in next steps.

Step 3: Execute below command to install the fresh Magento in **magento24** directory

run `composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.3-p1 .`

The above will download Magento 2.4.3-p1 in root directory which is magento24

Install Magento 2 via CLI to do so run the below command

`
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
--elasticsearch-port=9200 \`

**Note: If it takes too long after magento is installed you can break it by pressing cltr + z for stopping chown - R command.**

Step 4: Cross-check if ES is configured, if not update the below setting in app/etc/env.php

`'system' => [
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
            ],`

Step 5: Make sure cache enabled

`bin/magento cache:enable`

Step 6: Configure Redis default/page caching

`php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-port=6379 --cache-backend-redis-db=0`
`bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1`

Step 7: Configure Redis for session storage

`bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis --session-save-redis-port=6379 --session-save-redis-log-level=4 --session-save-redis-db=2`

Step 9: Run deploy.sh(this can be found in the root directory of backend-docker-setup move it to magento24 directory) file via CLI

`sh deploy.sh`

Step 10: Configure your hosts file to add 127.0.0.1 magento2.local:

**For mac:** `127.0.0.1 magento2.local` in /etc/hosts

**For Windows:** `127.0.0.1 magento2.local` c:\Windows\System32\Drivers\etc\hosts

Congratulations! Once the above steps are executed in correct order by now you should have your Dockerized Magento setup ready for development.

Note: You may need to disable Magento_TwoFactorAuth module. `bin/magento module:disable Magento_TwoFactorAuth`

**Important Links:**

**Frontend:** http://magento2.local/

**Backend:** http://magento2.local/admin

**Admin credentials:**

username: **admin**
password: **admin123**

_Note: The above credentails are set at the time of Magento installation and can be updated as per requirement._

_In case of any questions related to the environment setup please feel free to write: firasath90@gmail.com_

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

That is it! I hope you guys had fun setting up docker based Magento environment. I am always open to feedback and learning. Any feedback will be highly appreciated :)

Thank you,
Firas,
Senior Magento Full-Stack Developer.
