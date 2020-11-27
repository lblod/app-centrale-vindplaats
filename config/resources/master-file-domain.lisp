(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:filename :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "nfo:fileCreated")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download"))
  :resource-base (s-url "http://data.lblod.info/files/")
  :features `(include-uri)
  :on-path "files")

(define-resource remote-data-object ()
 :class (s-prefix "nfo:RemoteDataObject")
 :properties `((:source :url ,(s-prefix "nie:url"))
               (:created :datetime ,(s-prefix "dct:created"))
               (:modified :datetime ,(s-prefix "dct:modified"))
               (:request-header :url ,(s-prefix "rpioHttp:requestHeader"))
               (:status :url ,(s-prefix "adms:status"))
               (:creator :url ,(s-prefix "dct:creator")))
 :has-one `((file :via ,(s-prefix "nie:dataSource")
                  :inverse t
                  :as "download"))
 :resource-base (s-url "http://data.lblod.info/id/remote-data-objects/")
 :features `(include-uri)
 :on-path "remote-data-objects")



