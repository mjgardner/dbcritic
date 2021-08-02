package App::DBCritic::Policy::BidirectionalRelationship;

# ABSTRACT: Check for missing bidirectional relationships in ResultSources

=head1 SYNOPSIS

    use App::DBCritic;

    my $critic = App::DBCritic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if one or more of a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>'s relationships does not
have a corresponding reverse relationship in the other class.

=cut

use strict;
use utf8;
use Modern::Perl '2011';

# VERSION
use English '-no_match_vars';
use Moo;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;

has description => (
    is      => 'ro',
    default => quote_sub q{'Missing bidirectional relationship'},
);

=attr description

"Missing bidirectional relationship"

=cut

has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Related tables should have relationships defined in both classes.'},
);

=attr explanation

"Related tables should have relationships defined in both classes."

=cut

sub violates {
    my $source = shift->element;

    return join "\n",
        map { _message( $source->name, $source->related_source($_)->name ) }
        grep { !keys %{ $source->reverse_relationship_info($_) } }
        $source->relationships;
}

=method violates

If the L<"current element"|App::DBCritic::Policy>'s
L<relationships|DBIx::Class::ResultSource/relationships> do not all have
corresponding
L<"reverse relationships"|DBIx::Class::ResultSource/reverse_relationship_info>,
returns a string describing details of the issue.

=cut

sub _message { return "$_[0] to $_[1] not reciprocated" }

with 'App::DBCritic::PolicyType::ResultSource';

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=cut

1;
