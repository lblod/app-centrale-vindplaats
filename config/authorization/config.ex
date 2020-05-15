alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec

defmodule Delta.Config do
  def targets do
    [ "http://deltanotifier" ]
  end
end

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/application",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://data.vlaanderen.be/ns/mandaat#Mandataris",
                        "http://www.w3.org/ns/person#Person",
                        "http://data.vlaanderen.be/ns/mandaat#TijdsgebondenEntiteit",
                        "http://data.vlaanderen.be/ns/mandaat#Fractie",
                        "http://data.vlaanderen.be/ns/besluit#Bestuurseenheid",
                        "http://www.w3.org/ns/prov#Location",
                        "http://data.vlaanderen.be/ns/besluit#Bestuursorgaan",
                        "http://data.vlaanderen.be/ns/persoon#Geboorte",
                        "http://www.w3.org/ns/org#Membership",
                        "http://data.vlaanderen.be/ns/mandaat#Mandaat",
                        "http://mu.semte.ch/vocabularies/ext/BestuursfunctieCode",
                        "http://mu.semte.ch/vocabularies/ext/MandatarisStatusCode",
                        "http://mu.semte.ch/vocabularies/ext/BeleidsdomeinCode",
                        "http://mu.semte.ch/vocabularies/ext/GeslachtCode",
                        "http://mu.semte.ch/vocabularies/ext/BestuurseenheidClassificatieCode",
                        "http://mu.semte.ch/vocabularies/ext/BestuursorgaanClassificatieCode",
                        "http://www.w3.org/ns/org#Organization",
                        "http://schema.org/PostalAddress",
                        "http://www.w3.org/ns/org#Role",
                        "http://www.w3.org/ns/org#Site",
                        "http://schema.org/ContactPoint",
                        "http://www.w3.org/ns/locn#Address",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Bestuursfunctie",
                        "http://data.lblod.info/vocabularies/leidinggevenden/Functionaris",
                        "http://data.lblod.info/vocabularies/leidinggevenden/FunctionarisStatusCode",
                        "http://www.w3.org/2004/02/skos/core#Concept",
                        "http://www.w3.org/2004/02/skos/core#ConceptScheme"
                      ]
                    } } ] }
    ]
  end
end



