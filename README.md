# Dbd: A data store that (almost) never forgets

This is facts based data store, inspired by [RDF] concepts, but adding a log based structure and fine-grained provenance.

* [Why?][Rationale]
* <http://github.com/petervandenabeele/dbd>

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

    $ gem install dbd      # Ruby 1.9.2, 1.9.3, 2.0.x, jruby (see .travis.yml)

## Examples

Also see the file `docs/test.rb`.

```
require 'dbd'

provenance = Dbd::ProvenanceResource.new

fact_context_public  = Dbd::ProvenanceFact.new(predicate: "prov:context", object: "public")
fact_source_dbd      = Dbd::ProvenanceFact.new(predicate: "prov:source",  object: "http://github.com/petervandenabeele/dbd")
fact_creator_peter_v = Dbd::ProvenanceFact.new(predicate: "dcterms:creator", object: "@peter_v")
fact_created_now     = Dbd::ProvenanceFact.new(predicate: "dcterms:created", object: Time.now.utc)
fact_license_MIT     = Dbd::ProvenanceFact.new(predicate: "prov:license", object: "MIT")
provenance << fact_context_public
provenance << fact_source_dbd
provenance << fact_creator_peter_v
provenance << fact_created_now
provenance << fact_license_MIT

nobel_peace_2012 = Dbd::Resource.new(provenance_subject: provenance.subject)

fact_nobel_peace_2012 = Dbd::Fact.new(predicate: "todo:nobelPeacePriceWinner", object: "2012")
fact_EU_label = Dbd::Fact.new(predicate: "rdfs:label", object: "EU") #  this will use some RDF predicates in future
fact_EU_comment = Dbd::Fact.new(predicate: "rdfs:comment", object: "European Union")
fact_EU_story = Dbd::Fact.new(predicate: "todo:story", object: "A long period of peace,\n that is a \"bliss\".")
nobel_peace_2012 << fact_nobel_peace_2012
nobel_peace_2012 << fact_EU_label
nobel_peace_2012 << fact_EU_comment
nobel_peace_2012 << fact_EU_story

graph = Dbd::Graph.new

graph << [provenance, nobel_peace_2012]

puts "facts in short representation:"
puts graph.map(&:short)
# facts in short representation:
# [ prov ] : 78b0d99b : prov:context             : public
# [ prov ] : 78b0d99b : prov:source              : http://github.com/petervandenabeele/dbd
# [ prov ] : 78b0d99b : dcterms:creator          : @peter_v
# [ prov ] : 78b0d99b : dcterms:created          : 2013-05-29 22:10:14 UTC
# [ prov ] : 78b0d99b : prov:license             : MIT
# 78b0d99b : 0db0caee : todo:nobelPeacePriceWinn : 2012
# 78b0d99b : 0db0caee : rdfs:label               : EU
# 78b0d99b : 0db0caee : rdfs:comment             : European Union
# 78b0d99b : 0db0caee : todo:story               : A long period of peace,_ that is a "bliss".

puts "facts in full detail in CSV:"
puts graph.to_CSV
# facts in full detail in CSV:
# "58c33e41-87c7-4403-b058-60e4ebf063ed","2013-05-29 22:10:14.811038737 UTC","","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","prov:context","public"
# "44f72707-f0af-4e1e-8674-8009aedda826","2013-05-29 22:10:14.811075014 UTC","","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","prov:source","http://github.com/petervandenabeele/dbd"
# "dd409d99-cdb5-4a99-a3c1-cfb64b1eaa62","2013-05-29 22:10:14.811092335 UTC","","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","dcterms:creator","@peter_v"
# "a135916e-b055-4da5-805f-6adba927c935","2013-05-29 22:10:14.811105102 UTC","","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","dcterms:created","2013-05-29 22:10:14 UTC"
# "345d455d-3f2d-4b9e-9084-d866c767feba","2013-05-29 22:10:14.811116493 UTC","","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","prov:license","MIT"
# "1d49db69-9b7a-49b7-be87-7ca7e88a20f6","2013-05-29 22:10:14.811135641 UTC","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","0db0caee-cc05-4f02-b90e-1ad4e72050a5","todo:nobelPeacePriceWinner","2012"
# "ce620335-a661-4a72-a932-1fe904f3db8a","2013-05-29 22:10:14.811151313 UTC","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","0db0caee-cc05-4f02-b90e-1ad4e72050a5","rdfs:label","EU"
# "a694f74b-219d-4e23-936a-5f10b77fe321","2013-05-29 22:10:14.811164540 UTC","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","0db0caee-cc05-4f02-b90e-1ad4e72050a5","rdfs:comment","European Union"
# "85732e38-79d9-48d0-8611-0bed25883bd3","2013-05-29 22:10:14.811176113 UTC","78b0d99b-aaf9-4b67-9b84-43c3b7d44729","0db0caee-cc05-4f02-b90e-1ad4e72050a5","todo:story","A long period of peace,
# that is a ""bliss""."
```

[RDF]:              http://www.w3.org/RDF/
[Rationale]:        http://github.com/petervandenabeele/dbd/blob/master/docs/rationale.md
[MIT]:              https://github.com/petervandenabeele/dbd/blob/master/LICENSE.txt
