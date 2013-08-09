require 'dbd'

context = Dbd::Context.new

context << Dbd::ContextFact.new(predicate: "prov:visibility", object: "public")
context << Dbd::ContextFact.new(predicate: "prov:source",  object: "http://github.com/petervandenabeele/dbd")
context << Dbd::ContextFact.new(predicate: "dcterms:creator", object: "@peter_v")
context << Dbd::ContextFact.new(predicate: "dcterms:created", object: Time.now.utc)
context << Dbd::ContextFact.new(predicate: "prov:license", object: "MIT")

nobel_peace_2012 = Dbd::Resource.new(context_subject: context.subject)

nobel_peace_2012 << Dbd::Fact.new(predicate: "todo:nobelPeacePriceWinner", object: "2012")
nobel_peace_2012 << Dbd::Fact.new(predicate: "rdfs:label", object: "EU") #  this will use some RDF predicates in future
nobel_peace_2012 << Dbd::Fact.new(predicate: "rdfs:comment", object: "European Union")
nobel_peace_2012 << Dbd::Fact.new(predicate: "todo:story", object: "A long period of peace,\n that is a \"bliss\".")

graph = Dbd::Graph.new

graph << context << nobel_peace_2012

puts "facts in short representation:"
puts graph.map(&:short)

# facts in short representation:
# [ cont ] : d5ad0ca1 : prov:visibility          : public
# [ cont ] : d5ad0ca1 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : d5ad0ca1 : dcterms:creator          : @peter_v
# [ cont ] : d5ad0ca1 : dcterms:created          : 2013-08-09 20:15:24 UTC
# [ cont ] : d5ad0ca1 : prov:license             : MIT
# d5ad0ca1 : dede3cf8 : todo:nobelPeacePriceWinn : 2012
# d5ad0ca1 : dede3cf8 : rdfs:label               : EU
# d5ad0ca1 : dede3cf8 : rdfs:comment             : European Union
# d5ad0ca1 : dede3cf8 : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts "facts in full detail in CSV:"
puts csv

# facts in full detail in CSV:
#  "2013-08-09 20:15:24.022368550 UTC","9cc48236-cb12-40e8-8641-08407b9a03fb","","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","prov:visibility","public"
# "2013-08-09 20:15:24.022416066 UTC","86afeade-0802-4fe7-b0d7-9a09d5441dbf","","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","prov:source","http://github.com/petervandenabeele/dbd"
# "2013-08-09 20:15:24.022435168 UTC","97d7fd9f-77e1-45e9-bdaa-9a283345c8ec","","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dcterms:creator","@peter_v"
# "2013-08-09 20:15:24.022449630 UTC","aa0897ce-d5ea-497a-8c4b-3a9339f6cc52","","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dcterms:created","2013-08-09 20:15:24 UTC"
# "2013-08-09 20:15:24.022463761 UTC","154d2b46-99df-4eaf-8a75-9e3b7d5df2a7","","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","prov:license","MIT"
# "2013-08-09 20:15:24.022480963 UTC","0590f53a-346a-4ece-b510-fc1179e76e05","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dede3cf8-2d3f-4170-8ce5-3fe7c0db5529","todo:nobelPeacePriceWinner","2012"
# "2013-08-09 20:15:24.022497483 UTC","b28dc6fb-1779-47d3-9109-882075b28d08","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dede3cf8-2d3f-4170-8ce5-3fe7c0db5529","rdfs:label","EU"
# "2013-08-09 20:15:24.022512505 UTC","5474dbc0-ee47-4e7a-aa0a-cd60f8467d84","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dede3cf8-2d3f-4170-8ce5-3fe7c0db5529","rdfs:comment","European Union"
# "2013-08-09 20:15:24.022526505 UTC","a8c0a137-8c45-49bf-9a87-5915a24725b9","d5ad0ca1-645f-41a8-8384-7f411a1f94e2","dede3cf8-2d3f-4170-8ce5-3fe7c0db5529","todo:story","A long period of peace,\n that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)

# [ cont ] : d5ad0ca1 : prov:visibility          : public
# [ cont ] : d5ad0ca1 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : d5ad0ca1 : dcterms:creator          : @peter_v
# [ cont ] : d5ad0ca1 : dcterms:created          : 2013-08-09 20:15:24 UTC
# [ cont ] : d5ad0ca1 : prov:license             : MIT
# d5ad0ca1 : dede3cf8 : todo:nobelPeacePriceWinn : 2012
# d5ad0ca1 : dede3cf8 : rdfs:label               : EU
# d5ad0ca1 : dede3cf8 : rdfs:comment             : European Union
# d5ad0ca1 : dede3cf8 : todo:story               : A long period of peace,_ that is a "bliss".
