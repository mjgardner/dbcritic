package DBIx::Class::Schema::Critic::Policy::NullableTextColumn;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use DBI ':sql_types';
use Moo;
use namespace::autoclean -also => qr{\A _}xms;

has description => (
    is      => 'ro',
    default => quote_sub q{'Nullable text column'},
);
has explanation => (
    is      => 'ro',
    default => quote_sub
        q{'Text columns should not be nullable. Default to empty string instead.'},
);

sub violates {
    my $source = shift->element;

    ## no critic (ProhibitAccessOfPrivateData,ProhibitCallsToUndeclaredSubs)
    my @text_types = (
        qw(TEXT NTEXT CLOB NCLOB CHARACTER CHAR NCHAR VARCHAR VARCHAR2 NVARCHAR2),
        'CHARACTER VARYING',
        map     { uc $_->{TYPE_NAME} }
            map { $source->storage->dbh->type_info($_) } (
            SQL_CHAR,        SQL_CLOB,
            SQL_VARCHAR,     SQL_WVARCHAR,
            SQL_LONGVARCHAR, SQL_WLONGVARCHAR,
            ),
    );

    my %column = %{ $source->columns_info };
    return join "\n", map {"$_ is a nullable text column."} grep {
        uc( $column{$_}{data_type} // q{} ) ~~ @text_types
            and $column{$_}{is_nullable}
    } keys %column;
}

with 'DBIx::Class::Schema::Critic::PolicyType::ResultSource';
1;

# ABSTRACT: Check for ResultSources with nullable text columns

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;

    my $critic = DBIx::Class::Schema::Critic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has nullable text
columns.

=attr description

"Nullable text column"

=attr explanation

"Text columns should not be nullable. Default to empty string instead."

=attr applies_to

This policy applies to L<ResultSource|DBIx::Class::ResultSource>s.

=method violates

Returns details of each column from the
L<"current element"|DBIx::Class::Schema::Critic::Policy> that maps to
following data types and
L<"is nullable"|DBIx::Class::ResultSource/is_nullable>:

=over

=item C<TEXT>

=item C<NTEXT>

=item C<CLOB>

=item C<NCLOB>

=item C<CHARACTER>

=item C<CHAR>

=item C<NCHAR>

=item C<VARCHAR>

=item C<VARCHAR2>

=item C<NVARCHAR2>

=item C<CHARACTER VARYING>

=item C<SQL_CHAR>

=item C<SQL_CLOB>

=item C<SQL_VARCHAR>

=item C<SQL_WVARCHAR>

=item C<SQL_LONGVARCHAR>

=item C<SQL_WLONGVARCHAR>

=back
