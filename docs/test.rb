require 'dbd'

context = Dbd::Context.new

context << Dbd::ContextFact.new(predicate: 'prov:visibility', object_type: 's', object: 'public')
context << Dbd::ContextFact.new(predicate: 'prov:source',  object_type: 's', object: 'http://github.com/petervandenabeele/dbd')
context << Dbd::ContextFact.new(predicate: 'dcterms:creator', object_type: 's', object: '@peter_v')
context << Dbd::ContextFact.new(predicate: 'dcterms:created', object_type: 's', object: Time.now.utc)
context << Dbd::ContextFact.new(predicate: 'prov:license', object_type: 's', object: 'MIT')

nobel_peace_2012 = Dbd::Resource.new(context_subject: context.subject)

nobel_peace_2012 << Dbd::Fact.new(predicate: 'todo:nobelPeacePriceWinner', object_type: 's', object: '2012')
nobel_peace_2012 << Dbd::Fact.new(predicate: 'rdfs:label', object_type: 's', object: 'EU') #  this will use some RDF predicates in future
nobel_peace_2012 << Dbd::Fact.new(predicate: 'rdfs:comment', object_type: 's', object: 'European Union')
nobel_peace_2012 << Dbd::Fact.new(predicate: 'todo:story', object_type: 's', object: "A long period of peace,\n that is a \"bliss\".")

graph = Dbd::Graph.new

graph << context << nobel_peace_2012

puts 'facts in short representation:'
puts graph.map(&:short)

# facts in short representation:
# [ cont ] : f53e7ac0 : prov:visibility          : public
# [ cont ] : f53e7ac0 : prov:source
# : http://github.com/petervandenabeele/dbd
# [ cont ] : f53e7ac0 : dcterms:creator          : @peter_v
# [ cont ] : f53e7ac0 : dcterms:created          : 2013-10-22 19:59:20 UTC
# [ cont ] : f53e7ac0 : prov:license             : MIT
# f53e7ac0 : 3da097f5 : todo:nobelPeacePriceWinn : 2012
# f53e7ac0 : 3da097f5 : rdfs:label               : EU
# f53e7ac0 : 3da097f5 : rdfs:comment             : European Union
# f53e7ac0 : 3da097f5 : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts 'facts in full detail in CSV:'
puts csv

# facts in full detail in CSV:
# "2013-10-22 19:59:20.797321024 UTC","10909776-cce4-4723-b6ce-1860a4322447","","f53e7ac0-c7b8-4f27-a90d-464faea98c98","prov:visibility","s","public"
# "2013-10-22 19:59:20.797374506 UTC","c31e582e-2f12-4c75-8593-3ae39b7292a3","","f53e7ac0-c7b8-4f27-a90d-464faea98c98","prov:source","s","http://github.com/petervandenabeele/dbd"
# "2013-10-22 19:59:20.797406087 UTC","f1822dd9-4863-4f8c-96f0-c3a2bd46f301","","f53e7ac0-c7b8-4f27-a90d-464faea98c98","dcterms:creator","s","@peter_v"
# "2013-10-22 19:59:20.797422478 UTC","494fc3d8-0968-4b86-a4f9-a4b1d3359d14","","f53e7ac0-c7b8-4f27-a90d-464faea98c98","dcterms:created","s","2013-10-22 19:59:20 UTC"
# "2013-10-22 19:59:20.797438736 UTC","9f8034b9-4d18-475a-b111-4ab9535e03ac","","f53e7ac0-c7b8-4f27-a90d-464faea98c98","prov:license","s","MIT"
# "2013-10-22 19:59:20.797456038 UTC","27819476-fbb3-4386-a4a8-dfe9af02ac7a","f53e7ac0-c7b8-4f27-a90d-464faea98c98","3da097f5-2792-4825-8148-286d102b65cc","todo:nobelPeacePriceWinner","s","2012"
# "2013-10-22 19:59:20.797484871 UTC","9e8c25a2-4a50-4020-81b8-ea1713c87885","f53e7ac0-c7b8-4f27-a90d-464faea98c98","3da097f5-2792-4825-8148-286d102b65cc","rdfs:label","s","EU"
# "2013-10-22 19:59:20.797499339 UTC","1f048c70-772c-429c-ad9f-6b6633205876","f53e7ac0-c7b8-4f27-a90d-464faea98c98","3da097f5-2792-4825-8148-286d102b65cc","rdfs:comment","s","European # Union"
# "2013-10-22 19:59:20.797514292 UTC","2c9c5e3c-d8d4-49b4-b133-384cf4a49e83","f53e7ac0-c7b8-4f27-a90d-464faea98c98","3da097f5-2792-4825-8148-286d102b65cc","todo:story","s","A long period of peace,\n that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)

# [ cont ] : f53e7ac0 : prov:visibility          : public
# [ cont ] : f53e7ac0 : prov:source
# : http://github.com/petervandenabeele/dbd
# [ cont ] : f53e7ac0 : dcterms:creator          : @peter_v
# [ cont ] : f53e7ac0 : dcterms:created          : 2013-10-22 19:59:20 UTC
# [ cont ] : f53e7ac0 : prov:license             : MIT
# f53e7ac0 : 3da097f5 : todo:nobelPeacePriceWinn : 2012
# f53e7ac0 : 3da097f5 : rdfs:label               : EU
# f53e7ac0 : 3da097f5 : rdfs:comment             : European Union
# f53e7ac0 : 3da097f5 : todo:story               : A long period of peace,_ that is a "bliss".
