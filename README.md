
# app-centrale-vindplaats

  

## Table of content

	
* [Description](#description)
* [List of services](#list-of-services)
* [Setup](#setup)
* [Importing Data](#importing-data)
   *  [Data sources](#data-sources) 
 * [Frontend](#frontend)
   * [Technologies](#technologies) 
   *  [Usage](#usage)
* [Debugging/logging](#debugginglogging)
* [More information](#more-information)

## Description

This App is part of the program  <b> Lokale Besluiten als Gelinkt Open Data </b> (lblod). It provides user-friendly interface to lookup data using Sparql, accessing that data in both a human as well as a machine readable way.  Based on the mu-semtech microservice architecture for the backend en Emberjs for the frontend. 

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
  

## Importing data

By default there is already data you can use. In case you want to add/modify/remove data you can simply do so by manipulating the files inside the ```app-centrale-vindplaats/config/migrations``` folder. When changes have been made inside the migrations folder you should restart docker-compose and the migration-service will take care of the rest. 
<small> > More info about migrations can be found on the [migrations-service](https://github.com/mu-semtech/mu-migrations-service) repo's readme.

#### Data sources

  *  [Mandatendatabank](https://mandaten.lokaalbestuur.vlaanderen.be/)

   *  [Leidinggevendendatabank](https://leidinggevenden.lokaalbestuur.vlaanderen.be/)

## Frontend

### Technologies

The frontend is what the user actually interacts with. With the use of our addons you are presented with a sparql interface and when visiting different routes with the corresponding , rdf-friendly, data. 
It is build on top of the [Ember.js](https://emberjs.com/) framework. And server side rendered by [Fastboot](#https://ember-fastboot.com/)

### Usage
When you first visit the ```http://localhost:80``` you will be redirected to a sparql interface. This will already have performed a search query that presents you with data from the database. ( Only in case your migrations folder and therefor Triplestore is populated with data ). If you are running the app locally and you want to get more information about a subject then you will have to copy part of the url into your browsers searchbar. 

##### Example
 * The results of on the sparql route will probably be displayed like so:
   ```Subject-uri | predicate-uri | object-uri```

 * Let's take an arbitrary subject-uri as an example 
```<http://data.lblod.info/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```

 * Trim of the the protocol, subdomain and domain name so you only have the path left
    ```/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```
    
 *  Inside your searchbar, prepend that path by ``` http://localhost:80``` and hit enter
     ```http://localhost:80/id/bestuursorganen/293a6433b88c65f11071c86fff60459cfa80c6623984e9da9757a6e4c648c079>```


 If info exists about that subject then you should be met by a table with data about that uri, both direct and invers. The [resource-label](https://github.com/lblod/resource-label-service) service automatically looks for labels & description for each uri and displays them if they exists. You can now just simply click through each link that starts with ```http://data.lblod.info/``` to get more information of the clicked uri inside this frontend or click on any other link to get redirected outside it. 



### Relevant Addons 
#### Ember-metis
The frontend uses our [metis](https://github.com/redpencilio/ember-metis) addon to take care of the routes and calls to the coresponding info and labels.

#### Ember-cli-yasgui
The [yasgui](https://github.com/nvdk/ember-cli-yasgui) addon that gives you a sparql interface when visiting ```http://localhost/sparql``` .


#### Ember-fastboot
The ember-fastboot addon makes it possible to render the page in nodejs. The frontend is server by our [fastboot-server container](https://hub.docker.com/r/redpencil/fastboot-app-server).

### Debugging/logging
The mu-semtech stack also provides a [http-logger](https://github.com/redpencilio/app-http-logger) based on [Kibana](https://www.elastic.co/kibana). You can run this independently from app-centrale-vindplaats. All services inside the docker-compose file of the app-centrale-vindplaats that have the label logging ( the value after that does not really matter ) will be logged by the http-logger. More info on the http-loggers [readme](https://github.com/redpencilio/app-http-logger) file inside the repo 

### More information
If you have any questions about a particular service then you can simply visit that service's repo and read the readme file. These should mostly all be up to date and help a lot in understanding the service. All links are displayed above in de [Service list](#list-of-services)



