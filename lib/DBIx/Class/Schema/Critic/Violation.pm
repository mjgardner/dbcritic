package DBIx::Class::Schema::Critic::Violation;

# ABSTRACT: A violation of a DBIx::Class::Schema::Critic::Policy

use utf8;
use Modern::Perl;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use DBIx::Class::Schema::Critic::Types 'DBICType';
use namespace::autoclean;

has [qw(description explanation)] => ( ro, isa => Str );

has element => ( ro, isa => DBICType );

__PACKAGE__->meta->make_immutable();
1;
