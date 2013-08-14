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
