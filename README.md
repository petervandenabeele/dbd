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
* Fine grained context (including provenance)
  * Each base Fact points to a ContextResource, so separate context and  
    provenance is possible per fact (e.g. different properties about the same  
    resource can come from different sources, different visibility etc.)
  * can keep the original_source reference, creator, date, …
  * can have a context that allows filtering data (e.g. private, professional, …)
  * separate encryption schemes per context are possible
  * ContextResource is flexible, since built itself from Facts
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

context = Dbd::ContextResource.new

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
# [ cont ] : 8e944a5b : prov:context             : public
# [ cont ] : 8e944a5b : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : 8e944a5b : dcterms:creator          : @peter_v
# [ cont ] : 8e944a5b : dcterms:created          : 2013-07-08 18:56:22 UTC
# [ cont ] : 8e944a5b : prov:license             : MIT
# 8e944a5b : ce210dee : todo:nobelPeacePriceWinn : 2012
# 8e944a5b : ce210dee : rdfs:label               : EU
# 8e944a5b : ce210dee : rdfs:comment             : European Union
# 8e944a5b : ce210dee : todo:story               : A long period of peace,_ that is a "bliss".

csv = graph.to_CSV

puts "facts in full detail in CSV:"
puts csv

# facts in full detail in CSV:
# "f851b1be-62c1-4304-b5ec-338d0f1db270","2013-07-08 18:56:22.104811959 UTC","","8e944a5b-9b88-4ec4-b920-5e6d34840442","prov:context","public"
# "56e46bd0-7b64-4fa0-aee1-2399c13eef18","2013-07-08 18:56:22.104857149 UTC","","8e944a5b-9b88-4ec4-b920-5e6d34840442","prov:source","http://github.com/petervandenabeele/dbd"
# "7da8b320-f7ef-470c-8ccb-4d2fa003320f","2013-07-08 18:56:22.104876326 UTC","","8e944a5b-9b88-4ec4-b920-5e6d34840442","dcterms:creator","@peter_v"
# "76c36dd8-929f-4284-a450-ab8fb1aeb418","2013-07-08 18:56:22.104894231 UTC","","8e944a5b-9b88-4ec4-b920-5e6d34840442","dcterms:created","2013-07-08 18:56:22 UTC"
# "a5b8573d-aef1-4dcd-8b73-c96f06ffc6ec","2013-07-08 18:56:22.104909283 UTC","","8e944a5b-9b88-4ec4-b920-5e6d34840442","prov:license","MIT"
# "0db3b6f8-96f4-4243-b0cf-6632e5aa6d4b","2013-07-08 18:56:22.104926520 UTC","8e944a5b-9b88-4ec4-b920-5e6d34840442","ce210dee-c0b4-4053-99ff-b4338cff1a06","todo:nobelPeacePriceWinner","2012"
# "61eeeb57-30d7-484e-acfc-e62db5e56ea4","2013-07-08 18:56:22.104943653 UTC","8e944a5b-9b88-4ec4-b920-5e6d34840442","ce210dee-c0b4-4053-99ff-b4338cff1a06","rdfs:label","EU"
# "94fd717b-f50f-4c02-a271-5012d26c248f","2013-07-08 18:56:22.104957856 UTC","8e944a5b-9b88-4ec4-b920-5e6d34840442","ce210dee-c0b4-4053-99ff-b4338cff1a06","rdfs:comment","European Union"
# "68782219-b2fc-41c2-b8f6-57ff1ac6e73b","2013-07-08 18:56:22.104971734 UTC","8e944a5b-9b88-4ec4-b920-5e6d34840442","ce210dee-c0b4-4053-99ff-b4338cff1a06","todo:story","A long period of peace,
#  that is a ""bliss""."

imported_graph = Dbd::Graph.new.from_CSV(csv)

puts imported_graph.map(&:short)
# [ cont ] : 8e944a5b : prov:context             : public
# [ cont ] : 8e944a5b : prov:source              : http://github.com/petervandenabeele/dbd
# [ cont ] : 8e944a5b : dcterms:creator          : @peter_v
# [ cont ] : 8e944a5b : dcterms:created          : 2013-07-08 18:56:22 UTC
# [ cont ] : 8e944a5b : prov:license             : MIT
# 8e944a5b : ce210dee : todo:nobelPeacePriceWinn : 2012
# 8e944a5b : ce210dee : rdfs:label               : EU
# 8e944a5b : ce210dee : rdfs:comment             : European Union
# 8e944a5b : ce210dee : todo:story               : A long period of peace,_ that is a "bliss".
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
