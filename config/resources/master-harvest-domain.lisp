(define-resource harvesting-task ()
  :class (s-prefix "hrvst:HarvestingTask")
  :properties `((:status :url ,(s-prefix "adms:status"))
                (:created :datetime ,(s-prefix "dct:created"))
                (:modified :datetime ,(s-prefix "dct:modified"))
                (:creator :url ,(s-prefix "dct:creator")))
  :has-one `((harvesting-collection :via ,(s-prefix "prov:generated")
                        :as "generated"))
  :resource-base (s-url "http://data.lblod.info/id/harvesting-task/")
  :features '(include-uri)
  :on-path "harvesting-tasks")

(define-resource harvesting-collection ()
  :class (s-prefix "hrvst:HarvestingCollection")
  :properties `((:status :url ,(s-prefix "adms:status")))
  :has-one `((remote-data-object :via ,(s-prefix "dct:hasPart")
                        :as "has-part"))
  :resource-base (s-url "http://data.lblod.info/id/harvesting-collection/")
  :features '(include-uri)
  :on-path "harvesting-collections")



