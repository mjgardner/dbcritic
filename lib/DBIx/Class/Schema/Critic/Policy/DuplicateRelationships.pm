package DBIx::Class::Schema::Critic::Policy::DuplicateRelationships;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Algorithm::Combinatorics 'combinations';
use Data::Compare;
use Moo;
use namespace::autoclean -also => qr{\A _}xms;

my %ATTR = (
    description => 'Duplicate relationships',
    explanation =>
        'Each connection between tables should only be expressed once.',
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( is => 'ro', default => sub {$default} );
}

sub violates {
    my $source = shift->element;
    return if $source->relationships < 2;

    return join "\n" => map { sprintf '%s and %s are duplicates', @{$_} }
        grep {
        Compare( map { $source->relationship_info($_) } @{$_} )
        } combinations( [ $source->relationships ], 2 );
}

with 'DBIx::Class::Schema::Critic::PolicyType::ResultSource';
1;

# ABSTRACT: Check for ResultSources with unnecessary duplicate relationships

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;

    my $critic = DBIx::Class::Schema::Critic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has relationships to
other tables that are identical in everything but name.

=attr description

"Duplicate relationships"

=attr explanation

"Each connection between tables should only be expressed once."

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=method violates

Returns details if the
L<"current element"|DBIx::Class::Schema::Critic::Policy>'s C<relationship_info>
hashes for any defined relationships are duplicated.
