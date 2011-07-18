package DBIx::Class::Schema::Critic::Violation;

# ABSTRACT: A violation of a DBIx::Class::Schema::Critic::Policy

use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use DBIx::Class::Schema::Critic::Types 'DBICType';
use namespace::autoclean;

=attr description

A short string describing what's wrong.  Only settable at construction.

=attr explanation

A string giving further details.  Only settable at construction.

=cut

has [qw(description explanation)] => ( ro, isa => Str );

=attr element

The schema element that violated a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>,
as an instance of L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.
Only settable at construction.

=cut

has element => ( ro, isa => DBICType );

__PACKAGE__->meta->make_immutable();
1;
