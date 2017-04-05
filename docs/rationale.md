# A data store that (almost) never forgets

I am tired of keeping data in many different data stores for different purposes, different contexts and losing long term data (old phone numbers, old contacts, meeting notes, etc. etc.). I want to add new data from personal and online sources and then combine, query, reason on all that data in different contexts (private, professional, for a certain customer, ...).

For _all_ facts in the data store, I want to know the "original source" of the data (a very fine grained provenance), who added it, when, etc., so I can check back the sources, filter on the source origin to query and reason only in a certain context, and also use it as a basis for a soft or hard delete of certain data. Typical provenance attributes can be: *context*, *original_source*, *license*, *created_by*, *created_at*, *valid_from*, *valid_until*, etc. 

One feature of the "context" in the provenance is that a "partial export" is possible of data in a certain context (only private, only professional, only for a certain customer etc.). To enforce the separation between the contexts, an advanaced feature is to have separate encryption schemes or keys for different context (initially an overall external encryption is possible, e.g. by mounting the back-end store on encrypted partitions and encrypting the separate "fact stream" files)

To allow easy (incremental) backup, synchronization, distributed processing, caching, the low level "fact stream" must be of a "logging" type and the operations must be idempotent. I see this as the fundamental aspect of "Big Data". Older facts are never removed, never modified, although they could be "invalidated" by newer facts (and then possibly replaced on a logical level by new facts). An other advantage of "invalidation" at a certain time stamp, is that it is possible to go back to the logical state at a certain historical moment.

One exception is the **"human right to be forgotten"** to which I fully agree. So the possibility for a "hard delete" on certain older facts in the data store is a requirement, implemented in such a way that the resulting data graph after the new "hard delete" of older facts is always valid and exactly equivalent to the "soft delete" case. Because all other data (except "hard deleted" data) is always retained, a newer export will function as a _complete_ back-up, so this can replace the older back-ups and so remove the "hard deleted" entries from all back-ups (to fully implement the "right to be forgotten", also in the back-ups).

The logical structure of the data must be defined by a descriptive ontology, so no hard programming is needed to set-up or modify a schema.  For the provenance (meta) level, the facts of a provenance entry are also stored in the same fact stream. A specific requirement is that all provenance facts for a provenance subject must be in the fact stream, before any fact uses this provenance subject (the reason is that when a fact is processed, to be loaded e.g. in a back-end for analytics, the full provenance for the fact must be known).

Based on the ontology of the data, clients can then query this data store and build automated interfaces for inserting and viewing the logical data graph.

(written in Breskens, on 6 April 2013, after a good day of sailing on the Westerschelde)
