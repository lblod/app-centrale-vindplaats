# Changelog
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
