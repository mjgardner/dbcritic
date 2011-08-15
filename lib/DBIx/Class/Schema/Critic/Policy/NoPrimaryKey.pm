package DBIx::Class::Schema::Critic::Policy::NoPrimaryKey;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Moo;
use namespace::autoclean -also => qr{\A _}xms;

has description => ( is => 'ro', default => quote_sub q{'No primary key'} );
has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Tables should have one or more columns defined as a primary key.'},
);

sub violates {
    my $source = shift->element;
    return $source->name . ' has no primary key' if !$source->primary_columns;
    return;
}

with 'DBIx::Class::Schema::Critic::PolicyType::ResultSource';
1;

# ABSTRACT: Check for DBIx::Class::Schema::ResultSources without primary keys

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;

    my $critic = DBIx::Class::Schema::Critic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has zero primary columns.

=attr description

"No primary key"

=attr explanation

"Tables should have one or more columns defined as a primary key."

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=method violates

Returns details if the
L<"current element"|DBIx::Class::Schema::Critic::Policy>'s C<primary_columns>
method returns nothing.
