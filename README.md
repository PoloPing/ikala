# Ikala

### Installing sassc package might be slow.
refer : https://github.com/sass/sassc-ruby/issues/189

### How to start in local
```
# start docker-compose
docker-compose -f dev_backend.yml up -d

# go into the web container
docker docker exec -it {web_container_name} bash

# build database and do migrations
bin/rake db:migrate

# load fixtures
FIXTURES_PATH="spec/fixtures" rails db:fixtures:load 
```


### How to deploy Production
```
# start docker-compose
docker-compose -f production_backend.yml up -d

# go into the web container
docker docker exec -it {web_container_name} bash

# build database and do migrations
bin/rake db:migrate

# load fixtures
FIXTURES_PATH="spec/fixtures" rails db:fixtures:load 

```

### How to do SSL at first time
```
docker run -d --name nginx -v /data/certbot/letsencrypt:/etc/letsencrypt 
-v /data/certbot/www:/var/www/certbot -p 80:80 -v {pwd}/ikala/nginx_conf/ssl_vertify_helper:/etc/nginx
/conf.d nginx
```

```
docker run --rm --name temp_certbot \
    -v /data/certbot/letsencrypt:/etc/letsencrypt \
    -v /data/certbot/www:/tmp/letsencrypt \
    -v /data/servers-data/certbot/log:/var/log \
    certbot/certbot:v1.8.0 \
    certonly --webroot --agree-tos --renew-by-default \
    --preferred-challenges http-01 --server https://acme-v02.api.letsencrypt.org/directory \
    --text --email {email} \
    -w /tmp/letsencrypt -d {domain_name}
```

### How to test
```
docker docker exec -it {web_container_name} bash
RAILS_ENV=test bundle exec rspec
```


### 測試API選擇
主要測試範圍是針對models的create, update, delete
考慮此範圍的主要原因是都涉計到DB變動。
其他只有顯示頁面的接口，會選擇在後面的整合測試一併處理。

