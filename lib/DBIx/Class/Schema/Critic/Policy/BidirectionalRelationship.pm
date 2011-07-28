package DBIx::Class::Schema::Critic::Policy::BidirectionalRelationship;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Moose;
use MooseX::Types::DBIx::Class 'ResultSource';
use namespace::autoclean -also => qr{\A _}xms;

my %ATTR = (
    description => 'Missing bidirectional relationship',
    explanation =>
        'Related tables should have relationships defined in both classes.',
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( is => 'ro', isa => 'Str', default => $default );
}

has applies_to => ( is => 'ro', default => sub { [ResultSource] } );

sub violates {
    my $source = shift->element;

    return join "\n",
        map { _message( $source->name, $source->related_source($_)->name ) }
        grep { !keys %{ $source->reverse_relationship_info($_) } }
        $source->relationships;
}

sub _message { return "$_[0] to $_[1] not reciprocated" }

with 'DBIx::Class::Schema::Critic::Policy';
__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Check for missing bidirectional relationships in ResultSources

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;
    my $critic = DBIx::Class::Schema::Critic->new();
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if one or more of a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>'s relationships does not
have a corresponding reverse relationship in the other class.

=attr applies_to

This policy applies to L<MooseX::Types::DBIx::Class|MooseX::Types::DBIx::Class>
I<ResultSource>s.

=method violates

If the L<"current element"|DBIx::Class::Schema::Critic::Policy>'s
L<relationships|DBIx::Class::ResultSource/relationships> do not all have
corresponding
L<"reverse relationships"|DBIx::Class::ResultSource/reverse_relationship_info>,
returns a string describing details of the issue.
