# Dbd: A data store that (almost) never forgets

This is facts based data store, inspired by [RDF] concepts, but adding a log based structure and fine-grained provenance.

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
  * can have a context that allows filtering data (e.g. private, professional, …)
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
# [ cont ] : 7d0ccaa8 : prov:context_fact        : public
# [ cont ] : 7d0ccaa8 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : 7d0ccaa8 : dcterms:creator          : @peter_v
# [ cont ] : 7d0ccaa8 : dcterms:created          : 2013-07-10 21:34:32 UTC
# [ cont ] : 7d0ccaa8 : prov:license             : MIT
# 7d0ccaa8 : 47acd35d : todo:nobelPeacePriceWinn : 2012
# 7d0ccaa8 : 47acd35d : rdfs:label               : EU
# 7d0ccaa8 : 47acd35d : rdfs:comment             : European Union
# 7d0ccaa8 : 47acd35d : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts "facts in full detail in CSV:"
puts csv

# facts in full detail in CSV:
# "be44bc07-0c0e-450b-8bbc-4cc1f472be33","2013-07-10 21:34:32.759424573 UTC","","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","prov:context_fact","public"
# "dae577a3-f210-4aab-9079-d87a4a362bd5","2013-07-10 21:34:32.759475097 UTC","","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","prov:source","http://github.com/petervandenabeele/dbd"
# "750904f8-c052-46af-8b0a-266a701a6e06","2013-07-10 21:34:32.759497534 UTC","","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","dcterms:creator","@peter_v"
# "a62ff09f-76a5-42ab-be9a-fc66c727ba41","2013-07-10 21:34:32.759513249 UTC","","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","dcterms:created","2013-07-10 21:34:32 UTC"
# "427f9dc3-0544-4f33-9b30-ffa32930f5a8","2013-07-10 21:34:32.759528346 UTC","","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","prov:license","MIT"
# "a8dbdfe6-6ead-4a35-bb6e-ec3f233aed5b","2013-07-10 21:34:32.759546366 UTC","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","47acd35d-f2b1-4b36-8a37-90b0f08217d5","todo:nobelPeacePriceWinner","2012"
# "186571ac-1eca-4621-8b7e-9f263550e27b","2013-07-10 21:34:32.759564395 UTC","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","47acd35d-f2b1-4b36-8a37-90b0f08217d5","rdfs:label","EU"
# "5a58d782-59bc-4ac0-b410-7ac637572f74","2013-07-10 21:34:32.759579688 UTC","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","47acd35d-f2b1-4b36-8a37-90b0f08217d5","rdfs:comment","European Union"
# "2c3e9e63-fd94-4c0f-ac39-7a85b4dbb20d","2013-07-10 21:34:32.759594496 UTC","7d0ccaa8-b641-4f1b-82ad-f36ba3757aa0","47acd35d-f2b1-4b36-8a37-90b0f08217d5","todo:story","A long period of peace,
#  that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)

# [ cont ] : 7d0ccaa8 : prov:context_fact        : public
# [ cont ] : 7d0ccaa8 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : 7d0ccaa8 : dcterms:creator          : @peter_v
# [ cont ] : 7d0ccaa8 : dcterms:created          : 2013-07-10 21:34:32 UTC
# [ cont ] : 7d0ccaa8 : prov:license             : MIT
# 7d0ccaa8 : 47acd35d : todo:nobelPeacePriceWinn : 2012
# 7d0ccaa8 : 47acd35d : rdfs:label               : EU
# 7d0ccaa8 : 47acd35d : rdfs:comment             : European Union
# 7d0ccaa8 : 47acd35d : todo:story               : A long period of peace,_ that is a "bliss".
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

Read from CSV (to_CSV) 10 M facts (of 250 Bytes; 2.5 GB netto data):

| ruby	     | time          |  memory (RSS) |
|------------|---------------|--------------:|
| ruby-1.9.3 | 4434  seconds | approx. 10 GB |
| ruby-2.0.0 | 5163  seconds | approx. 15 GB |
|jruby-1.7.4 | 1513  seconds | approx. 14 GB |

The significantly larger times to read from_CSV versus writing to_CSV are _not_
significantly caused by input validation (a test in JRuby without validation on
reading 1M facts was only 6% faster with the input validation turned off).

[RDF]:              http://www.w3.org/RDF/
[Rationale]:        http://github.com/petervandenabeele/dbd/blob/master/docs/rationale.md
[MIT]:              https://github.com/petervandenabeele/dbd/blob/master/LICENSE.txt
