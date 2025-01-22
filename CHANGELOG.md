# Changelog
## 0.24.6 (2025-01-22)
- Add Jaarrekening PEVA form [DL-6284]
## 0.24.5 (2025-01-10)
 - Import classification codes `ext:GeregistreerdeOrganisatieClassificatieCode` from OP [OP-3470]
### Deploy instructions
#### Re-init op-public-consumer
- Ensure backup (check crontab to get the command the create one)
- Ensure in `docker-compose.override.yml` (on prod)
  ```
   op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_LANDING_ZONE_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_REMAPPING_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
  ```
- Remove previous initial sync job and re-trigger initial sync
  ```
  drc exec op-public-consumer curl -X DELETE http://localhost/initial-sync-jobs
  drc exec op-public-consumer curl -X POST http://localhost/initial-sync-jobs
  ```
- Wait until the consumer is finished. (If you see failing on the last step, the mapping, boost the virtuoso config)
- Ensure op-public-consumer in `docker-compose.override.yml` is syncing with database again. The final `docker-compose.override.yml` will look like
  ```
   op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "false"
  ```
## 0.24.4 (2025-01-09)
- Bump consumers [DL-6347]
## 0.24.3 (2024-12-11)
 - Add OCMW to notification rule of samenstelling bestuursorganen [DL-6344]
## 0.24.2 (2024-11-28)
 - general data clean up https://github.com/lblod/app-centrale-vindplaats/pull/63 [DL-6320]
## 0.24.1 (2024-11-13)
- update missing notficationrule
## 0.24.0 (2024-11-13)
- update besluittype [DL-6298]
## 0.23.2 (2024-11-08)
- update mapping
### Deploy instructions
- If you didn't deploy yet, you should just follow the deploy instructions from `v0.23.0`.
- else: `drc down; drc up -d migrations; drc up -d`
## 0.23.1 (2024-10-24)
- forgot to add a mapping. (DL-6102 and also OP-3422)
### Deploy instructions
- If you didn't deploy yet, you should just follow the deploy instructions from `v0.23.0`.
- else: `drc restart migrationns op-public-consumer`
## 0.23.0 (2024-10-23)
- Re-init op-public-consumer with new consumer (DL-6102 and also OP-3422)
- bump other consumers
- Added cleanup job (DL-6216)
- Update 'Besluit APB over retributies' besluittype (DL-5977)
### Deploy instructions
#### Re-init op-public-consumer
- Note: the application will be down for a while.
- Ensure backup
- Ensure application goes down: `drc down`
- Ensure in `docker-compose.override.yml` (on prod)
  ```
   op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_LANDING_ZONE_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_REMAPPING_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
  ```
- `drc up -d migrations`
  - That might take a while.
- `drc up -d database op-public-consumer --remove-orphans `
- Wait until the consumer is finished. (If you see failing on the last step, the mapping, boost the virtuoso config)
- Ensure op-public-consumer in `docker-compose.override.yml` is syncing with database again
- So the final `docker-compose.override.yml` will look like
  ```
   op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "false"
  ```
#### remaining bits of deploy
  - ``drc up -d`
## 0.22.3 (2024-10-11)
 - Add decision type `Samenstelling bestuursorganen` (DL-6196)
### Deploy Notes
#### Docker Commands
 - `drc restart migrations && drc logs -ft --tail=200 migrations`
 - `drc restart resource cache`
## 0.22.2  (2024-09-03)
 - Remove duplicate URI for IBEG. (DL-5770)
### Deploy Notes
#### Docker Commands
 - `drc restart migrations && drc logs -ft --tail=200 migrations`
 - `drc restart resource cache`
## 0.22.1 (2024-05-07)
 - Remove language tagged labels from the database (DL-5889)
## 0.22.0 (2024-04-10)
- Bundle new forms and their rules (DL-5671)
- Add missing restart and logging configs to a couple of services (DL-5818)
### Deploy Notes
#### Docker Commands
- `drc up -d resource-labels migrations delta-report-generator leidinggevenden-consumer`
- `drc restart migrations`
- `drc restart resource cache`
## 0.21.0 (2024-03-07)
- Update the frontend to `v0.3.0` & `v0.3.1`: https://github.com/lblod/frontend-centrale-vindplaats/blob/master/CHANGELOG.md#v031-2024-02-21 (DL-5658)
- Add `gn-publications-consumer` to consume `Gelink-Notuleren` publications (DL-5659)
  - Gives users the ability to have dereferencable URIs for their decisions, which allows them to click on a decision URI and access additional information.
### Deploy notes
#### `gn-publication-consumer`
- Follow the steps listed under [this section](https://github.com/lblod/app-centrale-vindplaats/?tab=readme-ov-file#gn-publications-consumer) to perform the consumer setup.
#### Docker Commands
- `drc up -d frontend`
- `drc up -d gn-publications-consumer`
## 0.20.0 (2024-01-17)
- fixing https by http in lblodlg prefix of `op-consumer/public/delta-context-config.js` [#48](https://github.com/lblod/app-centrale-vindplaats/pull/48)
- adding new besluitTypes and besluitDocumentTypes with their rules [#49](https://github.com/lblod/app-centrale-vindplaats/pull/49)
  - LEKP-rapport - Sloopbeleidsplan, LEKP-rapport - Collectieve energiebesparende renovatie and LEKP-rapport - Fietspaden
  - Niet-bindend advies op oprichting and Niet-bindend advies op statuten
### Deploy notes
- drc restart migrations resource cache
## 0.19.0 (2023-12-15)
- update notification rules
### Deploy notes
- drc restart migrations resource cache
## 0.18.0 (2023-11-15)
- adding new codelists for "Besluit over budget wijziging eredienstbestuur" BesluitType
### Deploy notes
- drc restart migrations resource cache
## 0.17.7 (2023-11-14)
- fixed conflicting obligation to report
## 0.17.6 (2023-11-10)
- fixed broken label
## 0.17.5 (2023-11-10)
- fixed conflicting obligation to report
## 0.17.4 (2023-11-10)
- fix reasoner rule
## 0.17.3 (2023-11-09)
- bump consumers
- fix endpoint
## 0.17.2 (2023-11-09)
- fix endpoint in intial sync
## 0.17.1 (2023-10-30)
- fix migration
## 0.17.0 (2023-10-30)
### General
 - documentation
 - bump consumers
 - remove obsolete services
 - bump database
 - updated obligation to report
### Deploy instructions
  - re-sync erediensten from OP
    - flush, rerun op sync migrations to fix typeBetrokkenheid. (see `README.md`)
  - once done:
  ```
  drc up -d --remove-orphans
  ```
## 0.16.2 (2023-09-21)
 - bump identifier
## 0.16.1 (2023-05-04)
 - updated wrong organen labels
## 0.16.0 (2023-04-24)
 - added notification rules
## 0.15.0 (2023-04-17)
 - added OP consumer
## 0.14.0 (2023-04-06)
 - Added waarnemende Imam
 - Updated publication rules
## 0.13.3 (2023-01-17)
- Correct wrong RO for 6 bestuurseenheden (Bisdom Antwerpen > Aartsbisdom Mechelen-Brussel)
## 0.13.2 (2023-01-17)
- bug in accident ingesting triples from QA
## 0.13.1 (2023-01-03)
- bugfix migrations
## 0.13.0 (2023-01-03)
- remove mandaat: bestuurslid van bestuur van eredienst
- update consumers
- betrokken besturen
- update meldingsrules + decision types
## 0.12.0 (2022-11-10)
- added missing data EB
## 0.11.0 (2022-11-08)
- update data set:` ?bestuursorgaanInTijd generiek:isTijdspecialisatieVan ?bestuursorgaan`
## 0.10.0 (2022-11-03)
- added up to data EB data
- added missing types Reglementaire bijlage
## 0.9.0 (2022-10-25)
- added leidinggevenden vocabulary

## 0.8.0 (2022-10-21)
- added LEKP codelists
- added extra old decision types
## 0.7.0 (2022-09-02)
- bump dispatcher
- bump fronted
  - Fixed METIS_BASE_URL not resolving in non-fastboot mode
  - pinnend fastboot base image
## 0.6.0 (2022-07-25)
- Added updated rule:NotificationRule data
- Added codelists for erediensten
## 0.5.0 (2022-07-12)
- Added rule:NotificationRule data
## 0.4.1 (2022-07-01)
- Rerun migrations to add labels to organen

## 0.4.0 (2022-06-29)
- Add data from OP

## 0.3.2 (2022-02-25)
- Fix broken migration

## 0.3.1 (2022-02-22)
- Fix broken migration

## 0.3.0 (2022-02-22)
- First (static) version of Erediensten

## 0.2.0 (2021-09-07)

### :rocket: Enhancement
 - added besluiten-consumer
 - added leidinggevenden-consumer
 - added mandaten-consumer
