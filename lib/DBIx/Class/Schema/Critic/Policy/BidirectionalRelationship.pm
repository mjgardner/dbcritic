package DBIx::Class::Schema::Critic::Policy::BidirectionalRelationship;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use English '-no_match_vars';
use Moo;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;

has description => (
    is      => 'ro',
    default => quote_sub q{'Missing bidirectional relationship'},
);
has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Related tables should have relationships defined in both classes.'},
);

sub violates {
    my $source = shift->element;

    return join "\n",
        map { _message( $source->name, $source->related_source($ARG)->name ) }
        grep { !keys %{ $source->reverse_relationship_info($ARG) } }
        $source->relationships;
}

sub _message { return "$ARG[0] to $ARG[1] not reciprocated" }

with 'DBIx::Class::Schema::Critic::PolicyType::ResultSource';
1;

# ABSTRACT: Check for missing bidirectional relationships in ResultSources

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;

    my $critic = DBIx::Class::Schema::Critic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if one or more of a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>'s relationships does not
have a corresponding reverse relationship in the other class.

=attr description

"Missing bidirectional relationship"

=attr explanation

"Related tables should have relationships defined in both classes."

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=method violates

If the L<"current element"|DBIx::Class::Schema::Critic::Policy>'s
L<relationships|DBIx::Class::ResultSource/relationships> do not all have
corresponding
L<"reverse relationships"|DBIx::Class::ResultSource/reverse_relationship_info>,
returns a string describing details of the issue.
