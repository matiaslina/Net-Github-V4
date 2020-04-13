NAME
====

Net::Github::V4 - Github GraphQL API

SYNOPSIS
========

```raku
use Net::Github::V4;

my $client = Net::Github::V4.new(
    :access-token(%*ENV<GITHUB_ACCESS_TOKEN>)
);

my $data = $client.query(q:to/IQL/, limit => 2);
query($limit:Int!) {
    repository(owner: "rakudo", name: "rakudo") {
        issues(last: $limit, states:OPEN) {
            edges {
                node {
                    title
                    url
                }
            }
        }
    }
}
IQL

for $data<data><repository><issues><edges> -> $edge {
    my $node = $edge<node>;
    say "The link for '{$node<title>}' is {$node<url>}"
}
```

DESCRIPTION
===========

Net::Github::V4 is a library to talk to the v4 of github apis

Methods
=======

new
---

Defined as:

```raku
method new(:$access-token! --> Net::Github::V4:D)
```

Create and returns an instance of `Net::Github::V4`.

query
-----

Defined as:

```raku
method query(Str $query, *%variables --> Map)
```

Query the Github API with `$query`. `*%variables` are the variables that will be replaced on the `$query` parameter.

rate-limit
----------

```raku
method rate-limit(Net::Github::V4:D: --> Int)
```

Returns the amount of queries that the server will accept before rate limiting the client.

rate-limit-remaining
--------------------

```raku
method rate-limit-remaining(Net::Github::V4:D: --> Int)
```

Returns the remaining queries before rate limiting.

rate-limit-reset
----------------

```raku
method rate-limit-reset(Net::Github::V4:D: --> DateTime)
```

Returns when the rate limit will reset to the `rate-limit` number.

AUTHOR
======

Matias Linares <matiaslina@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Matias Linares

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

