use v6;
unit class Net::Github::V4:ver<0.0.1>:auth<cpan:MATIASL>;

use Cro::HTTP::Client;

has Cro::HTTP::Client $!client;
has Str $!access-token is built;

has Int $.rate-limit;
has Int $.rate-limit-remaining;
has DateTime $.rate-limit-reset;


submethod BUILD(:$!access-token) {
    my %auth = bearer => $!access-token;
    $!client .= new(
        base-uri => “https://api.github.com”,
        headers => [
                    User-Agent => “Net::Github::V4”
                ],
        auth => { bearer => $!access-token }
    );
}

method query(Str $query, *%variables --> Hash) {
    my %data = query => $query;

    %data<variables> = %variables if %variables;

    my $request = $!client.post(
        '/graphql',
        content-type => 'application/json',
        body => %data
    );
    my $response = await $request;

    $!rate-limit = $response.header("X-RateLimit-Limit").Int;
    $!rate-limit-remaining = $response.header("X-RateLimit-Remaining").Int;
    $!rate-limit-reset = DateTime.new($response.header("X-RateLimit-Reset").Int);

    return await $response.body;
}




=begin pod

=head1 NAME

Net::Github::V4 - Github GraphQL API

=head1 SYNOPSIS

=begin code :lang<raku>

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
=end code

=head1 DESCRIPTION

Net::Github::V4 is a library to talk to the v4 of github apis

=head1 Methods

=head2 new

Defined as:

=begin code :lang<raku>
method new(:$access-token! --> Net::Github::V4:D)
=end code

Create and returns an instance of C<Net::Github::V4>.

=head2 query

Defined as:

=begin code :lang<raku>
method query(Str $query, *%variables --> Map)
=end code

Query the Github API with C<$query>. C<*%variables> are the variables
that will be replaced on the C<$query> parameter.

=head2 rate-limit

=begin code :lang<raku>
method rate-limit(Net::Github::V4:D: --> Int)
=end code

Returns the amount of queries that the server will accept before
rate limiting the client.

=head2 rate-limit-remaining

=begin code :lang<raku>
method rate-limit-remaining(Net::Github::V4:D: --> Int)
=end code

Returns the remaining queries before rate limiting.

=head2 rate-limit-reset

=begin code :lang<raku>
method rate-limit-reset(Net::Github::V4:D: --> DateTime)
=end code

Returns when the rate limit will reset to the C<rate-limit> number.

=head1 AUTHOR

Matias Linares <matiaslina@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Matias Linares

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
