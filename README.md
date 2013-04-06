# A data store that (almost) never forgets

I am tired of keeping data in many different data stores for different purposes, different contexts and losing long term data (old phone numbers, old contacts, meeting notes, etc. etc.). I want to add new data from personal and online sources and then combine, query, reason on all that data in different contexts (private, professional, for a certain customer, ...).

For _all_ facts in the data store, I want to know the "original source" of the data (provenance), who added it, when, etc., so I can check back the sources, filter on the source origin to query and reason only in a certain context, and also use it as a basis for a soft or hard delete of certain data.

One feature of the "context" is that a "partial export" is possible of data in a certain context (only private, only professional, only for a certain customer etc.). To enforce the separation between the contexts, an advanaced feature is to have separate encryption schemes or keys for different context (initially an overall external encryption is possible, e.g. by mounting the back-end store on encrypted partitions and encrypting the separate "fact stream" files)

To allow easy (incremental) backup, synchronization, distributed processing, caching, the low level "fact stream" must be of a "logging" type and the operations must be idempotent. I see this as the fundamental aspect of "Big Data". Older facts are never removed, never modified, although they could be "invalidated" by newer facts (and then possibly replaced on a logical level by new facts). An other advantage of "invalidation" at a certain time stamp, is that it is possible to go back to the logical state at a certain historical moment.

One exception is the "human right to be forgotten" to which I fully agree. So the possibility for a "hard delete" on certain older facts in the data store is a requirement, implemented in such a way that the resulting data graph after the new "hard delete" of older facts is always valid and exactly equivalent to the "soft delete" case. Because all other data (except "hard deleted" data) is always retained, a newer export will function as a _complete_ back-up, so this can replace the older back-ups and so remove the "hard deleted" entries from all back-ups (to fully implement the "right to be forgotten", also in the back-ups).

The logical structure of the data must be defined by a descriptive ontology, so no hard programming is needed to set-up or modify a schema.

Only for the provenance (meta) level, a hard set of properties is defined (created_by, created_at, valid_from, valid_until, original_source, context, etc.)

Based on the ontology of the data, clients can then query this data store and build automated interfaces for inserting and viewing the logical data graph.

(written in Breskens, on 6 April 2013, after a good day of sailing on the Westerschelde)

## Installation

Add this line to your application's Gemfile:

    gem 'dbd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dbd

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
