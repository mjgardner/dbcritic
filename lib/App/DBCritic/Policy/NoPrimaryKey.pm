package App::DBCritic::Policy::NoPrimaryKey;

# ABSTRACT: Check for DBIx::Class::Schema::ResultSources without primary keys

=head1 SYNOPSIS

    use App::DBCritic;

    my $critic = App::DBCritic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has zero primary columns.

=cut

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use Moo;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;

has description => ( is => 'ro', default => quote_sub q{'No primary key'} );

=attr description

"No primary key"

=cut

has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Tables should have one or more columns defined as a primary key.'},
);

=attr explanation

"Tables should have one or more columns defined as a primary key."

=cut

sub violates {
    my $source = shift->element;
    return $source->name . ' has no primary key' if !$source->primary_columns;
    return;
}

=method violates

Returns details if the
L<"current element"|App::DBCritic::Policy>'s C<primary_columns>
method returns nothing.

=cut

with 'App::DBCritic::PolicyType::ResultSource';

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=cut

1;
