require 'dbd'

provenance = Dbd::ProvenanceResource.new

# PREFIX provenance: <https://data.vandenabeele.com/ontologies/provenance#>
# PREFIX dcterms: <http://purl.org/dc/terms/>
fact_context_public = Dbd::ProvenanceFact.new(predicate: "provenance:context", object: "public")
fact_creator_peter_v = Dbd::ProvenanceFact.new(predicate: "dcterms:creator", object: "@peter_v")
fact_created_at_now = Dbd::ProvenanceFact.new(predicate: "provenance:created_at", object: Time.now.utc)
provenance << fact_context_public
provenance << fact_creator_peter_v
provenance << fact_created_at_now

nobel_peace_2012 = Dbd::Resource.new(provenance_subject: provenance.subject)

# PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
# PREFIX base: <https://data.vandenabeele.com/ontologies/base#>
fact_nobel_peace_2012 = Dbd::Fact.new(predicate: "base:nobelPeacePriceWinner", object: "2012")
fact_EU_label = Dbd::Fact.new(predicate: "rdfs:label", object: "EU") #  this will use some RDF predicates in future
fact_EU_comment = Dbd::Fact.new(predicate: "rdfs:comment", object: "European Union")
fact_EU_story = Dbd::Fact.new(predicate: "base:story", object: "A long period of peace,\n that is a \"bliss\".")
nobel_peace_2012 << fact_nobel_peace_2012
nobel_peace_2012 << fact_EU_label
nobel_peace_2012 << fact_EU_comment
nobel_peace_2012 << fact_EU_story

graph = Dbd::Graph.new

graph << provenance
graph << nobel_peace_2012

puts graph.to_CSV

# "9f868d99-af27-4d83-86ae-ea5f4a1fa654","2013-05-22 21:25:48.136527770 UTC","","a6e028dd-a340-49ce-b3f8-2f158e257a87","provenance:context","public"
# "28496b40-1891-4bd0-9ee1-0c6c2a878cc1","2013-05-22 21:25:48.136596276 UTC","","a6e028dd-a340-49ce-b3f8-2f158e257a87","dcterms:creator","@peter_v"
# "98b9dd72-3473-4500-814d-d955eec2c5ee","2013-05-22 21:25:48.136621174 UTC","","a6e028dd-a340-49ce-b3f8-2f158e257a87","provenance:created_at","2013-05-22 21:25:40 UTC"
# "a0482b46-414d-40df-b436-41142728fda6","2013-05-22 21:25:55.367834295 UTC","a6e028dd-a340-49ce-b3f8-2f158e257a87","cd66aece-0b21-4e3e-8286-4191efb3aea1","base:nobelPeacePriceWinner","2012"
# "c1af381d-800f-4279-a2cc-ccccf31f5134","2013-05-22 21:25:55.367891996 UTC","a6e028dd-a340-49ce-b3f8-2f158e257a87","cd66aece-0b21-4e3e-8286-4191efb3aea1","rdfs:label","EU"
# "ac08843a-baae-49ea-a725-81b7e199e8f9","2013-05-22 21:25:55.367910018 UTC","a6e028dd-a340-49ce-b3f8-2f158e257a87","cd66aece-0b21-4e3e-8286-4191efb3aea1","rdfs:comment","European Union"
# "6e91fa40-daa8-45d1-916e-f9b243d01f2c","2013-05-22 21:25:55.367928936 UTC","a6e028dd-a340-49ce-b3f8-2f158e257a87","cd66aece-0b21-4e3e-8286-4191efb3aea1","base:story","A long period of peace,
# that is a ""bliss""."

