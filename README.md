# Dbd: A data store that (almost) never forgets

This is facts based data store, inspired by [RDF] concepts, but adding a log based structure and fine-grained provenance.

* [Why?][Rationale]
* <https://github.com/petervandenabeele/dbd>
* <http://rubydoc.info/github/petervandenabeele/dbd/frames/>
* <https://rubygems.org/gems/dbd>

[![Gem Version](https://badge.fury.io/rb/dbd.png)](http://badge.fury.io/rb/dbd)
[![Build Status](https://travis-ci.org/petervandenabeele/dbd.png?branch=master)](http://travis-ci.org/petervandenabeele/dbd)

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
* Fine grained Provenance
  * Each base Fact points to a ProvenanceResource, so separate provenance  
    possible for different facts about 1 resource
  * can keep the original_source reference, creator, date, …
  * can have a context that allows filtering data (e.g. private, professional, …)
  * separate encryption schemes per context are possible
  * ProvenanceResource is flexible, since built itself from Facts
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

```
require 'dbd'

context = Dbd::ProvenanceResource.new

context << Dbd::Context.new(predicate: "prov:context", object: "public")
context << Dbd::Context.new(predicate: "prov:source",  object: "http://github.com/petervandenabeele/dbd")
context << Dbd::Context.new(predicate: "dcterms:creator", object: "@peter_v")
context << Dbd::Context.new(predicate: "dcterms:created", object: Time.now.utc)
context << Dbd::Context.new(predicate: "prov:license", object: "MIT")

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
# [ cont ] : a1c5ee46 : prov:context             : public
# [ cont ] : a1c5ee46 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : a1c5ee46 : dcterms:creator          : @peter_v
# [ cont ] : a1c5ee46 : dcterms:created          : 2013-07-08 16:02:56 UTC
# [ cont ] : a1c5ee46 : prov:license             : MIT
# a1c5ee46 : c1337587 : todo:nobelPeacePriceWinn : 2012
# a1c5ee46 : c1337587 : rdfs:label               : EU
# a1c5ee46 : c1337587 : rdfs:comment             : European Union
# a1c5ee46 : c1337587 : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts "facts in full detail in CSV:"
puts csv

# facts in full detail in CSV:
# "185380bf-166d-4e6d-bc3f-010b42dc63f9","2013-07-08 16:02:56.069610807 UTC","","a1c5ee46-b8a1-422a-95c6-75f3a3022498","prov:context","public"
# "7a5e7f00-bc5e-4943-8de2-4bdc1c35c586","2013-07-08 16:02:56.069658035 UTC","","a1c5ee46-b8a1-422a-95c6-75f3a3022498","prov:source","http://github.com/petervandenabeele/dbd"
# "fc5f2328-07cb-496d-a4fd-7dbe8d18f814","2013-07-08 16:02:56.069687066 UTC","","a1c5ee46-b8a1-422a-95c6-75f3a3022498","dcterms:creator","@peter_v"
# "13956658-dd38-462e-bb6e-c46c81a5a885","2013-07-08 16:02:56.069702269 UTC","","a1c5ee46-b8a1-422a-95c6-75f3a3022498","dcterms:created","2013-07-08 16:02:56 UTC"
# "3d31affd-1a0f-4a29-aff6-53c9ccceee62","2013-07-08 16:02:56.069715865 UTC","","a1c5ee46-b8a1-422a-95c6-75f3a3022498","prov:license","MIT"
# "564302b7-3231-4904-a774-e61b60a87b4d","2013-07-08 16:02:56.069733020 UTC","a1c5ee46-b8a1-422a-95c6-75f3a3022498","c1337587-0635-4163-9e1e-111ddca8ca01","todo:nobelPeacePriceWinner","2012"
# "c4e6096e-087a-4eb5-bfe6-71dfd784ba1e","2013-07-08 16:02:56.069750945 UTC","a1c5ee46-b8a1-422a-95c6-75f3a3022498","c1337587-0635-4163-9e1e-111ddca8ca01","rdfs:label","EU"
# "be4f6f43-cfd2-4bc8-9173-cd3daadb9be5","2013-07-08 16:02:56.069765607 UTC","a1c5ee46-b8a1-422a-95c6-75f3a3022498","c1337587-0635-4163-9e1e-111ddca8ca01","rdfs:comment","European Union"
# "0da6d81b-8137-41e0-a1a0-fc1f6f1c1708","2013-07-08 16:02:56.069779069 UTC","a1c5ee46-b8a1-422a-95c6-75f3a3022498","c1337587-0635-4163-9e1e-111ddca8ca01","todo:story","A long period of peace,
#  that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)
# [ cont ] : a1c5ee46 : prov:context             : public
# [ cont ] : a1c5ee46 : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : a1c5ee46 : dcterms:creator          : @peter_v
# [ cont ] : a1c5ee46 : dcterms:created          : 2013-07-08 16:02:56 UTC
# [ cont ] : a1c5ee46 : prov:license             : MIT
# a1c5ee46 : c1337587 : todo:nobelPeacePriceWinn : 2012
# a1c5ee46 : c1337587 : rdfs:label               : EU
# a1c5ee46 : c1337587 : rdfs:comment             : European Union
# a1c5ee46 : c1337587 : todo:story               : A long period of peace,_ that is a "bliss".
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
