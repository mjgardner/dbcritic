package DBIx::Class::Schema::Critic::PolicyType;

use strict;
use utf8;
use Modern::Perl;

# VERSION
require Devel::Symdump;
use List::MoreUtils;
use Moo::Role;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;
with 'DBIx::Class::Schema::Critic::Policy';

has applies_to => (
    is   => 'ro',
    lazy => 1,
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    default => quote_sub( <<'END_SUB' => { '$package' => \__PACKAGE__ } ),
        [   List::MoreUtils::apply {s/\A .+ :://xms}
            grep { shift->does($_) } Devel::Symdump->packages($package),
        ];
END_SUB
);

1;

# ABSTRACT: Role for types of database criticism policies

=head1 SYNOPSIS

    package DBIx::Class::Schema::Critic::PolicyType::ResultClass;
    use Moo;
    with 'DBIx::Class::Schema::Critic::PolicyType';
    1;

=head1 DESCRIPTION

This is a L<role|Moo::Role> consumed by all
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> policy types.

=attr applies_to

Returns an array reference containing the last component of all the
C<DBIx::Class::Schema::Critic::PolicyType>
roles composed into the consuming class.
