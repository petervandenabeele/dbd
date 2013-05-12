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

provenance.each {|provenance_fact| graph << provenance_fact}
nobel_peace_2012.each {|fact| graph << fact}

puts graph.to_CSV
