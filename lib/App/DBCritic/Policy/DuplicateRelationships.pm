package App::DBCritic::Policy::DuplicateRelationships;

# ABSTRACT: Check for ResultSources with unnecessary duplicate relationships

=head1 SYNOPSIS

    use App::DBCritic;

    my $critic = App::DBCritic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has relationships to
other tables that are identical in everything but name.

=cut

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use Algorithm::Combinatorics 'combinations';
use Data::Compare;
use English '-no_match_vars';
use Moo;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;

has description => (
    is      => 'ro',
    default => quote_sub q{'Duplicate relationships'},
);

=attr description

"Duplicate relationships"

=cut

has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Each connection between tables should only be expressed once.'},
);

=attr explanation

"Each connection between tables should only be expressed once."

=cut

sub violates {
    my $source = shift->element;
    return if $source->relationships < 2;

    return join "\n" => map { sprintf '%s and %s are duplicates', @{$_} }
        grep {
        Compare( map { $source->relationship_info($_) } @{$_} )
        } combinations( [ $source->relationships ], 2 );
}

=method violates

Returns details if the
L<"current element"|App::DBCritic::Policy>'s C<relationship_info>
hashes for any defined relationships are duplicated.

=cut

with 'App::DBCritic::PolicyType::ResultSource';

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=cut

1;
