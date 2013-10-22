# Dbd: A data store that (almost) never forgets

This is facts based data store, inspired by [RDF] concepts, but adding a
log based structure and fine-grained context (with provenance) for each fact.
I am building a simple demo application in [DbdDemo].

* [Why?][Rationale]
* <https://github.com/petervandenabeele/dbd>
* <http://rubydoc.info/github/petervandenabeele/dbd/frames/>
* <https://rubygems.org/gems/dbd>

[![Gem Version](https://badge.fury.io/rb/dbd.png)](http://badge.fury.io/rb/dbd)
[![Build Status](https://travis-ci.org/petervandenabeele/dbd.png?branch=master)](http://travis-ci.org/petervandenabeele/dbd)
[![Code Climate](https://codeclimate.com/github/petervandenabeele/dbd.png)](https://codeclimate.com/github/petervandenabeele/dbd)

## Features

* Facts are immutable and ordered (log structured "fact stream")
  * "Big Data" mantra: base facts are immutable (store now, analyse later)
  * only 1 backup file needed: the fact stream contains the full history
  * synchronisation between remote sources is cheap (easy caching)
  * 1 data source has _all_ my data : never more loose stuff :-)
  * facts can be invalidated (and replaced) later on
* Privacy
  * a "hard delete" is possible: all downstream readers of the fact stream  
    must remove this fact and replace the back-up
  * since one single back-up file suffices, replacing the *single* back-up  
    file will actually remove the hard deleted fact(s) for good
* Fine grained context (including provenance)
  * Each base Fact points to a Context, so separate context and  
    provenance is possible per fact (e.g. different properties about the same  
    resource can come from different sources, different visibility etc.)
  * can keep the original_source reference, creator, date, …
  * can have a context that allows filtering data (e.g. public, private, professional, …)
  * separate encryption schemes per context are possible
  * Context is flexible, since built itself from Facts
* Schemaless
  * uses the [RDF] (subject, predicate, object) concepts
  * predicates, types can be defined in an ontology for declaring meaning
* Graph based
  * the object of each Fact can be another Resource
  * aimed at exporting to a graph database (e.g. Neo4j) for analysis

## License

Open Source [MIT]

## Installation

    $ gem install dbd      # Ruby 1.9.3, 2.0.x, jruby (see .travis.yml)

## Examples

Running `ruby docs/test.rb` will execute the script below.

* Facts are logically grouped (by subject) in a Resource
* ContextFacts are logically grouped (by subject) in a Context
* each Fact refers to a Context with its context_subject
* all Facts and ContextFacts are stored sequentially and immutably
  in a Graph

```
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
```

## Performance tests on 10 M facts

In version 0.0.9 a number of test programs where added (e.g. ../bin/test_5.rb)
that where used to populate in memory and write to disk a data set with 10 M facts.

This function was tested on ruby-2.0.0, ruby-1.9.3 and jruby-1.7.4. The facts
had an approximate size of 250 Bytes each (80 Bytes object).

The time needed and memory size (RSS) for populating the in-memory dataset was:

Generate in memory 10 M facts (of 250 Bytes; 2.5 GB netto data):

| ruby	     | time        | memory (RSS) |
|------------|-------------| ------------:|
| ruby-1.9.3 | 863 seconds |       8.1 GB |
| ruby-2.0.0 | 862 seconds |       9.0 GB |
|jruby-1.7.4 | 345 seconds |      10.8 GB |

In version 0.0.10 a test for reading a fact stream from a CSV file was added
(e.g. ../bin/test_6.rb). Reading back a CSV file that was written earlier with
10 M facts (with test_5.rb) was tested on jruby-1.7.4. and ruby-2.0.0.

This version also has input validation on the strings in the CSV. The time needed
and memory size (RSS) for reading the file (and populating the in-memory dataset
was):

Read from CSV (from_CSV) 10 M facts (of 250 Bytes; 2.5 GB netto data):

| ruby	     | time          |  memory (RSS) |
|------------|---------------|--------------:|
| ruby-1.9.3 | 4434  seconds | approx. 10 GB |
| ruby-2.0.0 | 5163  seconds | approx. 15 GB |
|jruby-1.7.4 | 1513  seconds | approx. 14 GB |

The significantly larger times to read from_CSV versus writing to_CSV are _not_
significantly caused by input validation (a test in JRuby without validation on
reading 1M facts was only 6% faster with the input validation turned off).

Version 0.0.13 introduced newline escaping for to_CSV and from_CSV and this
has added a performance penalty of approx. 30% (all strings are sent through
gsub with a regexp).

[RDF]:              http://www.w3.org/RDF/
[Rationale]:        http://github.com/petervandenabeele/dbd/blob/master/docs/rationale.md
[MIT]:              https://github.com/petervandenabeele/dbd/blob/master/LICENSE.txt
[DbdDemo]:          https://github.com/petervandenabeele/dbd_demo#readme
