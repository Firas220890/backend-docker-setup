php bin/magento maintenance:enable;
php bin/magento setup:upgrade;
php bin/magento setup:di:compile;
php bin/magento setup:static-content:deploy -f;
php bin/magento cache:flush;
php bin/magento cache:clean;
php bin/magento maintenance:disable;
