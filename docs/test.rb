require 'dbd'

context = Dbd::Context.new

context << Dbd::ContextFact.new(predicate: "prov:context_fact", object: "public")
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
# [ prov ] : 5eb1ea27 : prov:context_fact             : public
# [ prov ] : 5eb1ea27 : prov:source              : http://github.com/petervandenabeele/dbd
# [ prov ] : 5eb1ea27 : dcterms:creator          : @peter_v
# [ prov ] : 5eb1ea27 : dcterms:created          : 2013-06-19 22:02:20 UTC
# [ prov ] : 5eb1ea27 : prov:license             : MIT
# 5eb1ea27 : 3767c493 : todo:nobelPeacePriceWinn : 2012
# 5eb1ea27 : 3767c493 : rdfs:label               : EU
# 5eb1ea27 : 3767c493 : rdfs:comment             : European Union
# 5eb1ea27 : 3767c493 : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts "facts in full detail in CSV:"
puts csv

# facts in full detail in CSV:
# "4720034a-01ea-4b6b-b9aa-45cb8c7c5e64","2013-06-19 22:02:20.489834224 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:context_fact","public"
# "d05a0a6c-a003-4320-b52b-a6e49e854437","2013-06-19 22:02:20.489889896 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:source","http://github.com/petervandenabeele/dbd"
# "fc47abbd-da2d-4562-bb6b-ed8b84005734","2013-06-19 22:02:20.489913758 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","dcterms:creator","@peter_v"
# "f240e975-5d39-41eb-bb5a-cc59ede4c1a6","2013-06-19 22:02:20.489932320 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","dcterms:created","2013-06-19 22:02:20 UTC"
# "d592b1e8-2910-4329-b502-7d960cebb399","2013-06-19 22:02:20.489950713 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:license","MIT"
# "a2d55e46-03f2-470e-8347-c36b31e7facc","2013-06-19 22:02:20.489973271 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","todo:nobelPeacePriceWinner","2012"
# "0766dd24-70e5-487d-a018-d58da75dcdad","2013-06-19 22:02:20.489996422 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","rdfs:label","EU"
# "eda61baa-b331-462e-b7b5-5d6eb2e9a053","2013-06-19 22:02:20.490014676 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","rdfs:comment","European Union"
# "a3da9295-b43a-4c3a-8e8c-97c3f04c1fa3","2013-06-19 22:02:20.490036790 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","todo:story","A long period of peace,
#  that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)

# [ prov ] : 5eb1ea27 : prov:context_fact             : public
# [ prov ] : 5eb1ea27 : prov:source              : http://github.com/petervandenabeele/dbd
# [ prov ] : 5eb1ea27 : dcterms:creator          : @peter_v
# [ prov ] : 5eb1ea27 : dcterms:created          : 2013-06-19 22:02:20 UTC
# [ prov ] : 5eb1ea27 : prov:license             : MIT
# 5eb1ea27 : 3767c493 : todo:nobelPeacePriceWinn : 2012
# 5eb1ea27 : 3767c493 : rdfs:label               : EU
# 5eb1ea27 : 3767c493 : rdfs:comment             : European Union
# 5eb1ea27 : 3767c493 : todo:story               : A long period of peace,_ that is a "bliss".
