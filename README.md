# app-centrale-vindplaats

  <br>

## Table of content


* [Description](#description)
* [List of services](#list-of-services)
* [Setup](#setup)
* [Importing Data](#importing-data)
   * [Data sources](#data-sources)
 * [Frontend](#frontend)
   * [Technologies](#technologies)
   * [Usage](#usage)
   * [Environment](#environment)
* [Debugging/logging](#debugginglogging)
* [More information](#more-information)

<br>

## Description

This App is part of the program  <b> Lokale Besluiten als Gelinkt Open Data </b> (lblod). It provides user-friendly interface to lookup data using Sparql, accessing that data in both a human as well as a machine readable way.  Based on the mu-semtech microservice architecture for the backend and Emberjs for the frontend.

<br>

## List of Services


| Service  | Repository  |
|---|---|
| identifier  | https://github.com/mu-semtech/mu-identifier  |
| dispatcher  | https://github.com/mu-semtech/mu-dispatcher  |
| database  | https://github.com/mu-semtech/mu-authorization  |
| virtuoso  | https://github.com/tenforce/docker-virtuoso  |
| migrations | https://github.com/mu-semtech/mu-migrations-service |
| resource-labels  | https://github.com/lblod/resource-label-service  |
| cache | https://github.com/mu-semtech/mu-cache |
| delta-notifier | https://github.com/mu-semtech/delta-notifier |
| file | https://github.com/mu-semtech/file-service |
| harvesting-download-url | https://hub.docker.com/r/lblod/download-url-service  |
| harvesting-initiation  | https://github.com/lblod/harvesting-initiation-service |
| harvest-collector | https://github.com/lblod/harvest-collector-service |
| harvesting-import | https://github.com/lblod/harvesting-import-service |
| uri-info | https://github.com/redpencilio/mu-uri-info-service |
| resource | https://github.com/mu-semtech/mu-cl-resources |
| frontend | https://github.com/lblod/frontend-centrale-vindplaats |



<br>

## Setup


#### Clone this repository
```
git clone https://github.com/lblod/app-centrale-vindplaats.git
```


#### Move into the directory
```
cd app-centrale-vindplaats
```


#### Start the system
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

<small>It takes a minute before everything is up and running. In case there is an error the first time you launch, just stopping and relaunching docker compose should resolve any issues. </small>

#### Visit the App!

Simply visit http://localhost:80 and you will redirected to the yasgui sparql interface. More info about the frontend in the [frontend section](#frontend) below.

  <br>

### Sync data external data consumers
The procedure below describes how to set up the sync for `op-public-consumer`.
The procedures should be the similar for `leidinggevenden-consumer` and `mandatendatabank-consumer`. If there are variations in the steps for these consumers, it will be noted.

The synchronization of external data sources is a structured process divided into three key stages. The first stage, known as 'initial sync', requires manual interventions primarily due to performance considerations. Following this, there's a post-processing stage, where depending on the delta-consumer stream, it may be necessary to initiate certain background processes to ensure system consistency. The final stage involves transitioning the system to the 'normal operation' mode, wherein all functions are designed to be executed automatically.

#### `op-public-consumer`

##### 1. Initial sync
##### From scratch
Setting up the sync should happen work with the following steps:

- ensure docker-compose.override.yml has AT LEAST the following information

```yml
version: '3.7'

services:
#(...) there might be other services

  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be/" # you choose endpoint here
      DCR_DISABLE_DELTA_INGEST: "true"
      DCR_DISABLE_INITIAL_SYNC: "true"
# (...) there might be other information
```

- start the stack. `drc up -d`. Ensure the migrations have run and finished `drc logs -f --tail=100 migrations`
- Now the sync can be started. Ensure you update the `docker-compose.override.yml` to

```yml
version: '3.7'

services:
#(...) there might be other services

  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be/" # you choose endpoint here
      DCR_DISABLE_DELTA_INGEST: "false" # <------ THIS CHANGED
      DCR_DISABLE_INITIAL_SYNC: "false" # <------ THIS CHANGED
# (...) there might be other information
```

- start the sync `drc up -d op-public-consumer`.
  Data should be ingesting.
  Check the logs `drc logs -f --tail=200 op-public-consumer`

##### In case of a re-sync
In some cases, you may need to reset the data due to unforeseen issues. The simplest method is to entirely flush the triplestore and start afresh. However, this can be time-consuming, and if the app possesses an internal state that can't be recreated from external sources, a more granular approach would be necessary. We will outline this approach here. Currently, it involves a series of manual steps, but we hope to enhance the level of automation in the future.

###### op-public-consumer

- step 1: ensure the app is running and all migrations ran.
- step 2: ensure the besluiten-consumer stopped syncing, `docker-compose.override.yml` should AT LEAST contain the following information
```yml
version: '3.7'

services:
#(...) there might be other services

  op-public-consumer:
    environment:
      DCR_DISABLE_DELTA_INGEST: "true"
      DCR_DISABLE_INITIAL_SYNC: "true"
     # (...) there might be other information e.g. about the endpoint

# (...) there might be other information
```
- step 3: `docker-compose up -d op-public-consumer` to re-create the container.
- step 4: We need to flush the ingested data. Sample migrations have been provided.
    - In this case 3 migrations files because less load.
```
cp ./config/sample-migrations/flush-erediensten-op-[1-3].sparql-template ./config/migrations/local/[TIMESTAMP]-flush-erediensten-op-[1-3].sparql
docker-compose restart migrations
```
- step 5: Once migrations a success, further `op-public-consumer` data needs to be flushed too.
```
docker-compose exec op-public-consumer curl -X POST http://localhost/flush
docker-compose logs -f --tail=200 op-public-consumer
```
  - This should end with `Flush successful`.
- step 6: Proceed to consuming data from scratch again, ensure `docker-compose.override.yml` should AT LEAST contain the following information
```yml
version: '3.7'

services:
#(...) there might be other services

  op-public-consumer:
    environment:
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
     # (...) there might be other information e.g. about the endpoint

# (...) there might be other information
```
- step 8: Run `docker-compose up -d`
- step 9: This might take a while if `docker-compose logs op-public-consumer |grep success Returns: Initial sync http://redpencil.data.gift/id/job/URI has been successfully run`; you should be good. (Your computer will also stop making noise)

#### gn-publications-consumer

##### 1. Initial sync

##### From scratch

Setting up the sync should happen work with the following steps:

- Ensure `docker-compose.override.yml` has AT LEAST the following information:

```yml
version: '3.7'

services:
#(...) there might be other services

  gn-publications-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://gn-harvester.s.redhost.be/" # You can choose the endpoint here.
      DCR_DISABLE_DELTA_INGEST: "true"
      DCR_DISABLE_INITIAL_SYNC: "true"
# (...) there might be other information
```

- Start the stack: `drc up -d` and ensure the migrations have run and finished `drc logs -ft --tail=200 migrations`
- The sync can now be started; update the following in `docker-compose.override.yml`:

```yml
version: '3.7'

services:
#(...) there might be other services

  gn-publications-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://gn-harvester.s.redhost.be/" # You can choose the endpoint here.
      DCR_DISABLE_DELTA_INGEST: "false" # <------ THIS CHANGED
      DCR_DISABLE_INITIAL_SYNC: "false" # <------ THIS CHANGED
# (...) there might be other information
```

- Start the sync `drc up -d gn-publications-consumer`.
  Data should be ingesting.
  Check the logs `drc logs -ft --tail=200 gn-publications-consumer`
- This step might take a while. If `drc logs gn-publications-consumer | grep success` returns: `Initial sync http://redpencil.data.gift/id/job/URI has been successfully run`, things should be good to go.

##### In case of a re-sync

In some cases, you may need to reset the data due to unforeseen issues. The simplest method is to entirely flush the triplestore and start from a fresh slate. However, this can be time-consuming, and if the app possesses an internal state that cannot be recreated from external sources, a more granular approach would be necessary. We will outline this approach here.

- Step 1: Ensure the app is running, and all migrations have run.
- Step 2: Ensure `gn-publications-consumer` has stopped syncing; `docker-compose.override.yml` should AT LEAST contain the following information:
```yml
version: '3.7'

services:
#(...) there might be other services

  gn-publications-consumer:
    environment:
      DCR_DISABLE_DELTA_INGEST: "true"
      DCR_DISABLE_INITIAL_SYNC: "true"
     # (...) there might be other information e.g. about the endpoint

# (...) there might be other information
```

- Step 3: `drc up -d gn-publications-consumer` to re-create the container.
- Step 4: We need to flush the ingested data. Sample migrations have been provided.

```bash
cp ./config/sample-migrations/flush-erediensten-op-[1-3].sparql-template ./config/migrations/local/[TIMESTAMP]-flush-erediensten-op-[1-3].sparql
drc restart migrations
```
- Step 5: Once migrations are successful, more `gn-publications-consumer` data needs to be flushed.
```
drc exec gn-publications-consumer curl -X POST http://localhost/flush
drc logs -f --tail=200 gn-publications-consumer
```
  - This should end with `Flush successful`.
- Step 6: Proceed to consume data from scratch again and ensure `docker-compose.override.yml` contains the following information:
```yml
version: '3.7'

services:
#(...) there might be other services

  gn-publications-consumer:
    environment:
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
     # (...) there might be other information e.g. about the endpoint

# (...) there might be other information
```
- Step 8: Run `drc up -d`
- Step 9: This step might take a while. If `drc logs gn-publications-consumer | grep success` returns: `Initial sync http://redpencil.data.gift/id/job/URI has been successfully run`, things should be good to go.

###### op-public-consumer vs mandatendatabank-consumer

As of the time of writing, there is some overlap between the two data producers due to practical reasons. This issue will be resolved eventually. For the time being, if re-synchronization is required, it's advisable to re-sync both consumers.
The procedure is identical to the one for op-public-consumer, but with a bit of an extra synchronsation hassle.
For both consumers, you will need to first run steps 1 up to and including step 5. Once these steps are completed for both consumers, you can proceed and start ingesting the data again.

#### 2. post-processing

For all delta-streams, you'll have to run `drc restart resources cache`.

#### 3. switch to 'normal operation' mode

Essentially, we want to force the data to go through `mu-auth` again, which is responsible for maintaining the cached data in sync. Ensure in `docker-compose.override.yml` the following:
```yml
version: '3.7'

services:
#(...) there might be other services

  op-public-consumer:
    environment:
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
      BYPASS_MU_AUTH_FOR_EXPENSIVE_QUERIES: 'false'
     # (...) there might be other information e.g. about the endpoint

# (...) there might be other information
```
Again, at the time of writing, the same configuration is valid for the other consumers.
After updating `docker-compose.override.yml`, do not forget to run `drc up -d`

#### What endpoints can be used?

##### mandatendatabank-consumer

- Production data: https://loket.lokaalbestuur.vlaanderen.be/
- QA data: https://loket.lblod.info/
- DEV data: https://dev.loket.lblod.info/

##### op-public-consumer

- Production data: https://organisaties.abb.vlaanderen.be/
- QA data: https://organisaties.abb.lblod.info/
- DEV data: https://dev.organisaties.abb.lblod.info/

##### leidinggevenden-consumer

- Production data: https://loket.lokaalbestuur.vlaanderen.be/
- QA data: https://loket.lblod.info/
- DEV data: https://dev.loket.lblod.info/

#### OP consumer

- The next steps assume `.env` file has been set, cf. supra.
- Ensure the following configuration is defined in the `docker-compose.override.yml`
  ```
  op-public-consumer:
      environment:
        DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
        DCR_DISABLE_INITIAL_SYNC: "true"
        DCR_DISABLE_DELTA_INGEST: "true"
  update-bestuurseenheid-mock-login:
      entrypoint: ["echo", "Service-disabled to not confuse the service"]
  ```
- `docker-compose up -d`
- Ensure all migrations have run and the stack is started and running properly.
- Extra step in case of a resync, run:
  ```
  docker-compose exec op-public-consumer curl -X POST http://localhost/flush
  docker-compose logs -f --tail=200 op-public-consumer`
  ```
    - This should end with `Flush successful`.
- Update `docker-compose.override.yml` with
    ```
    op-public-consumer:
      environment:
        DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
        DCR_DISABLE_INITIAL_SYNC: "false" # -> this changed
        DCR_DISABLE_DELTA_INGEST: "false" # -> this changed
    update-bestuurseenheid-mock-login:
      entrypoint: ["echo", "Service-disabled to not confuse the service"]
  ```
- `docker-compose up -d`
- This might take a while if `docker-compose logs op-public-consumer | grep success`
      Returns: `Initial sync http://redpencil.data.gift/id/job/URI has been successfully run`; you should be good.
      (Your computer will also stop making noise)
- In `docker-compose.override.yml`, remove the disabled service
  ```
   update-bestuurseenheid-mock-login:
     entrypoint: ["echo", "Service-disabled to not confuse the service"]
  ```
  The mock-logins will be created when a cron job kicks in. You can control the moment it triggers by playing with the `CRON_PATTERN` variable.
  See the `README.md` of the related service for more options.

### Additional notes:
#### Performance
- The default virtuoso settings might be too weak if you need to ingest the production data. Hence, there is better config, you can take over in your `docker-compose.override.yml`
```
  virtuoso:
    volumes:
      - ./data/db:/data
      - ./config/virtuoso/virtuoso-production.ini:/data/virtuoso.ini
      - ./config/virtuoso/:/opt/virtuoso-scripts
```
#### delta-producer-report-generator
Not all required parameters are provided, since deploy specific, see [report-generator](https://github.com/lblod/delta-producer-report-generator)
#### deliver-email-service
Should have credentials provided, see [deliver-email-service](https://github.com/redpencilio/deliver-email-service)

## Frontend

### Technologies

The frontend is what the user actually interacts with. With the use of our addons you are presented with a sparql interface and when visiting different routes with the corresponding rdf-friendly data.
It is build on top of the [Ember.js](https://emberjs.com/) framework. And server side rendered by [Fastboot](#https://ember-fastboot.com/)

### Usage
When you first visit the ```http://localhost:80``` you will be redirected to a sparql interface. This will already have performed a search query that presents you with data from the database (only in case your migrations folder and therefor Triplestore is populated with data). If you are running the app locally and you want to get more information about a subject then you will have to copy part of the url into your browsers searchbar.

##### Example
 * The results of on the sparql route will probably be displayed like so:
   ```Subject-uri | predicate-uri | object-uri```
 * Let's take an arbitrary subject-uri as an example
```<http://data.lblod.info/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```
 * Trim of the protocol, subdomain and domain name so you only have the path left
    ```/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```
 *  Inside your searchbar, prepend that path by ``` http://localhost:80``` and hit enter
     ```http://localhost:80/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```


If info exists about that subject then you should be met by a table with data about that uri, both direct and invers. The [resource-label](https://github.com/lblod/resource-label-service) service automatically looks for labels & description for each uri and displays them if they exist. You can now just simply click through each link that starts with ```http://data.lblod.info/``` to get more information of the clicked uri inside this frontend or click on any other link to get redirected outside it.

### Environment

The frontend service accepts a base url, the default is <b> http://data.lblod.info/ </b>.
An environment variable is <b> required </b>.


 ```
   frontend:
    image: aatauil/frontend-centrale-vindplaats:1.1.0-fastboot
    environment:
      BASE_URL: "http://data.lblod.info/"

 ```

<br>

### Relevant Addons
#### Ember-metis
The frontend uses our [metis](https://github.com/redpencilio/ember-metis) addon to take care of the routes and calls to the coresponding info and labels.

#### Ember-cli-yasgui
The [yasgui](https://github.com/nvdk/ember-cli-yasgui) addon that gives you a sparql interface when visiting ```http://localhost/sparql``` .


#### Ember-fastboot
The ember-fastboot addon makes it possible to render the page in nodejs. The frontend is server by our [fastboot-server container](https://hub.docker.com/r/redpencil/fastboot-app-server).

<br>

### Debugging/logging
The mu-semtech stack also provides a [http-logger](https://github.com/redpencilio/app-http-logger) based on [Kibana](https://www.elastic.co/kibana). You can run this independently from app-centrale-vindplaats. All services inside the docker-compose file of the app-centrale-vindplaats that have the label logging ( the value after that does not really matter ) will be logged by the http-logger. More info on the http-loggers [readme](https://github.com/redpencilio/app-http-logger) file inside the repo

<br>

### More information
If you have any questions about a particular service then you can simply visit that service's repo and read the readme file. These should mostly all be up to date and help a lot in understanding the service. All links are displayed above in de [Service list](#list-of-services)
