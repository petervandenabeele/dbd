require 'dbd'

provenance = Dbd::ProvenanceResource.new

# PREFIX prov: <https://data.vandenabeele.com/ontologies/provenance#>
# PREFIX dcterms: <http://purl.org/dc/terms/>
fact_context_public  = Dbd::ProvenanceFact.new(predicate: "prov:context", object: "public")
fact_source_dbd      = Dbd::ProvenanceFact.new(predicate: "prov:source",  object: "http://github.com/petervandenabeele/dbd")
fact_creator_peter_v = Dbd::ProvenanceFact.new(predicate: "dcterms:creator", object: "@peter_v")
fact_created_now     = Dbd::ProvenanceFact.new(predicate: "dcterms:created", object: Time.now.utc)
provenance << fact_context_public
provenance << fact_source_dbd
provenance << fact_creator_peter_v
provenance << fact_created_now

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

puts "facts in short representation:"
puts graph.map(&:short)
# [ prov ] : bbc2248e : prov:context             : public
# [ prov ] : bbc2248e : prov:source              : http://github.com/petervandenabeele/dbd
# [ prov ] : bbc2248e : dcterms:creator          : @peter_v
# [ prov ] : bbc2248e : dcterms:created          : 2013-05-26 22:01:50 UTC
# bbc2248e : 78edb900 : base:nobelPeacePriceWinn : 2012
# bbc2248e : 78edb900 : rdfs:label               : EU
# bbc2248e : 78edb900 : rdfs:comment             : European Union
# bbc2248e : 78edb900 : base:story               : A long period of peace,_ that is a "bliss".

puts "facts in full detail in CSV:"
puts graph.to_CSV
# "4c825f73-eda9-4b7f-a925-352f079857fb","2013-05-26 22:01:50.446202656 UTC","","bbc2248e-89f0-4480-853d-1dba51f1801d","prov:context","public"
# "09fc0e21-4749-44ab-858b-254dc24ee5a4","2013-05-26 22:01:50.446241720 UTC","","bbc2248e-89f0-4480-853d-1dba51f1801d","prov:source","http://github.com/petervandenabeele/dbd"
# "8db7f62a-d94b-43b1-b3de-827fd0e8b324","2013-05-26 22:01:50.446259428 UTC","","bbc2248e-89f0-4480-853d-1dba51f1801d","dcterms:creator","@peter_v"
# "0a76e215-cca5-44c7-9f58-f093e3ef0da7","2013-05-26 22:01:50.446272919 UTC","","bbc2248e-89f0-4480-853d-1dba51f1801d","dcterms:created","2013-05-26 22:01:50 UTC"
# "fe7c7b67-5344-4e64-a690-49c5e054b862","2013-05-26 22:01:50.446288352 UTC","bbc2248e-89f0-4480-853d-1dba51f1801d","78edb900-0ab7-4dc3-9e00-272de6d47c03","base:nobelPeacePriceWinner","2012"
# "f22bc359-e2e1-4ef1-bd8a-7f6b01d1b703","2013-05-26 22:01:50.446307209 UTC","bbc2248e-89f0-4480-853d-1dba51f1801d","78edb900-0ab7-4dc3-9e00-272de6d47c03","rdfs:label","EU"
# "7ddc9674-fcff-40bf-9fc9-d5ccdf80cfad","2013-05-26 22:01:50.446321315 UTC","bbc2248e-89f0-4480-853d-1dba51f1801d","78edb900-0ab7-4dc3-9e00-272de6d47c03","rdfs:comment","European Union"
# "dc664aee-44cd-4fc8-a6f0-fdcf4242e9c5","2013-05-26 22:01:50.446333480 UTC","bbc2248e-89f0-4480-853d-1dba51f1801d","78edb900-0ab7-4dc3-9e00-272de6d47c03","base:story","A long period of peace,
# that is a ""bliss""."
