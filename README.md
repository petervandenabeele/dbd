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

Also see the file `docs/test.rb` to execute the script below.

```
require 'dbd'

provenance = Dbd::ProvenanceResource.new

provenance << Dbd::ProvenanceFact.new(predicate: "prov:context", object: "public")
provenance << Dbd::ProvenanceFact.new(predicate: "prov:source",  object: "http://github.com/petervandenabeele/dbd")
provenance << Dbd::ProvenanceFact.new(predicate: "dcterms:creator", object: "@peter_v")
provenance << Dbd::ProvenanceFact.new(predicate: "dcterms:created", object: Time.now.utc)
provenance << Dbd::ProvenanceFact.new(predicate: "prov:license", object: "MIT")

nobel_peace_2012 = Dbd::Resource.new(provenance_subject: provenance.subject)

nobel_peace_2012 << Dbd::Fact.new(predicate: "todo:nobelPeacePriceWinner", object: "2012")
nobel_peace_2012 << Dbd::Fact.new(predicate: "rdfs:label", object: "EU") #  this will use some RDF predicates in future
nobel_peace_2012 << Dbd::Fact.new(predicate: "rdfs:comment", object: "European Union")
nobel_peace_2012 << Dbd::Fact.new(predicate: "todo:story", object: "A long period of peace,\n that is a \"bliss\".")

graph = Dbd::Graph.new

graph << provenance << nobel_peace_2012

puts "facts in short representation:"
puts graph.map(&:short)

# facts in short representation:
# [ prov ] : 5eb1ea27 : prov:context             : public
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
# "4720034a-01ea-4b6b-b9aa-45cb8c7c5e64","2013-06-19 22:02:20.489834224 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:context","public"
# "d05a0a6c-a003-4320-b52b-a6e49e854437","2013-06-19 22:02:20.489889896 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:source","http://github.com/petervandenabeele/dbd"
# "fc47abbd-da2d-4562-bb6b-ed8b84005734","2013-06-19 22:02:20.489913758 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","dcterms:creator","@peter_v"
# "f240e975-5d39-41eb-bb5a-cc59ede4c1a6","2013-06-19 22:02:20.489932320 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","dcterms:created","2013-06-19 22:02:20 UTC"
# "d592b1e8-2910-4329-b502-7d960cebb399","2013-06-19 22:02:20.489950713 UTC","","5eb1ea27-6691-4a57-ab13-8a59021968e1","prov:license","MIT"
# "a2d55e46-03f2-470e-8347-c36b31e7facc","2013-06-19 22:02:20.489973271 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","todo:nobelPeacePriceWinner","2012"
# "0766dd24-70e5-487d-a018-d58da75dcdad","2013-06-19 22:02:20.489996422 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","rdfs:label","EU"
# "eda61baa-b331-462e-b7b5-5d6eb2e9a053","2013-06-19 22:02:20.490014676 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","rdfs:comment","European Union"
# "a3da9295-b43a-4c3a-8e8c-97c3f04c1fa3","2013-06-19 22:02:20.490036790 UTC","5eb1ea27-6691-4a57-ab13-8a59021968e1","3767c493-79d3-4a97-a832-79e6361ddc4c","todo:story","A long period of peace,
#  that is a ""bliss""."

imported_graph = Dbd::Graph.from_CSV(csv)

puts imported_graph.map(&:short)

# [ prov ] : 5eb1ea27 : prov:context             : public
# [ prov ] : 5eb1ea27 : prov:source              : http://github.com/petervandenabeele/dbd
# [ prov ] : 5eb1ea27 : dcterms:creator          : @peter_v
# [ prov ] : 5eb1ea27 : dcterms:created          : 2013-06-19 22:02:20 UTC
# [ prov ] : 5eb1ea27 : prov:license             : MIT
# 5eb1ea27 : 3767c493 : todo:nobelPeacePriceWinn : 2012
# 5eb1ea27 : 3767c493 : rdfs:label               : EU
# 5eb1ea27 : 3767c493 : rdfs:comment             : European Union
# 5eb1ea27 : 3767c493 : todo:story               : A long period of peace,_ that is a "bliss".
```

## Performance tests on 10 M facts

In version 0.0.9 a number of test programs where added (e.g. ../bin/test_5.rb)
that where used to populate in memory and write to disk a data set with 10 M facts.

This function was tested on ruby-2.0.0, ruby-1.9.3 and jruby-1.7.4. The facts
had an approximate size of 250 Bytes each (80 Bytes object).

The time needed and memory size (RSS) for populating the in-memory dataset was:

10 M facts (of 250 Bytes; 2.5 GB netto data):

| ruby	     | time        | memory (RSS) |
|------------|-------------| ------------:|
| ruby-1.9.3 | 863 seconds |       8.1 GB |
| ruby-2.0.0 | 862 seconds |       9.0 GB |
|jruby-1.7.4 | 345 seconds |      10.8 GB |


[RDF]:              http://www.w3.org/RDF/
[Rationale]:        http://github.com/petervandenabeele/dbd/blob/master/docs/rationale.md
[MIT]:              https://github.com/petervandenabeele/dbd/blob/master/LICENSE.txt
