(define-resource job ()
  :class (s-prefix "cogs:Job")
  :properties `((:created :datetime ,(s-prefix "dct:created"))
                (:modified :datetime ,(s-prefix "dct:modified"))
                (:creator :url ,(s-prefix "dct:creator")) ;;Later consider using proper relation in domain.lisp
                (:status :url ,(s-prefix "adms:status")) ;;Later consider using proper relation in domain.lisp
                (:operation :url ,(s-prefix "task:operation"))) ;;Later consider using proper relation in domain.lisp

  :has-one `((job-error :via ,(s-prefix "task:error")
                        :as "error"))

  :has-many `((task :via ,(s-prefix "dct:isPartOf")
                    :inverse t
                    :as "tasks"))

  :resource-base (s-url "http://redpencil.data.gift/id/job/")
  :features '(include-uri)
  :on-path "jobs")

(define-resource task ()
  :class (s-prefix "task:Task")
  :properties `((:created :datetime ,(s-prefix "dct:created"))
                (:modified :datetime ,(s-prefix "dct:modified"))
                (:status :url ,(s-prefix "adms:status")) ;;Later consider using proper relation in domain.lisp
                (:operation :url ,(s-prefix "task:operation")) ;;Later consider using proper relation in domain.lisp
                (:index :string ,(s-prefix "task:index")))

  :has-one `((job-error :via ,(s-prefix "task:error")
                    :as "error")
             (job :via ,(s-prefix "dct:isPartOf")
                    :as "job"))

  :has-many `((task :via ,(s-prefix "cogs:dependsOn")
                    :as "parent-tasks")
              ;; File and harvesting-collection may be considered nfo:DataContainer.
              ;; Inheritance is not (yet officialy) a thing in mu-cl-resource, hence we walk down the inheritance tree so our current frontend
              ;; can work with it. The type will eventually be changed to nfo:DataContainer
              (file :via ,(s-prefix "task:resultsContainer")
                    :as "results-containers")
              (harvesting-collection :via ,(s-prefix "task:inputContainer")
                    :as "input-containers")
              )

  :resource-base (s-url "http://redpencil.data.gift/id/task/")
  :features '(include-uri)
  :on-path "tasks")

(define-resource job-error ()
  :class (s-prefix "oslc:Error")
  :properties `((:message :string ,(s-prefix "oslc:message")))
  :resource-base (s-url "http://redpencil.data.gift/id/jobs/error/")
  :features '(include-uri)
  :on-path "job-errors")
