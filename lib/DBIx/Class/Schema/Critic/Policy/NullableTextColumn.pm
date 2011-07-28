package DBIx::Class::Schema::Critic::Policy::NullableTextColumn;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use DBI ':sql_types';
use Moose;
use MooseX::Types::DBIx::Class 'ResultSource';
use namespace::autoclean -also => qr{\A _}xms;

my %ATTR = (
    description => 'Nullable text column',
    explanation =>
        'Text columns should not be nullable. Default to empty string instead.',
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( is => 'ro', isa => 'Str', default => $default );
}

has applies_to => ( is => 'ro', default => sub { [ResultSource] } );

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
        uc( $column{$_}{data_type} ) ~~ @text_types
            and $column{$_}{is_nullable}
    } keys %column;
}

with 'DBIx::Class::Schema::Critic::Policy';
__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Check for ResultSources with nullable text columns

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;
    my $critic = DBIx::Class::Schema::Critic->new();
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has nullable text
columns.

=attr applies_to

This policy applies to L<MooseX::Types::DBIx::Class|MooseX::Types::DBIx::Class>
I<ResultSource>s.

=method violates

Returns details of each column from the
L<"current element"|DBIx::Class::Schema::Critic::Policy> that maps to the
following standard SQL types and
L<"is nullable"|DBIx::Class::ResultSource/is_nullable>.
