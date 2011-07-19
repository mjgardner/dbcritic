package DBIx::Class::Schema::Critic::Policy::NoPrimaryKey;

# ABSTRACT: Check for DBIx::Class::Schema::ResultSources without primary keys

use Moose;
use MooseX::Types::DBIx::Class 'ResultSource';
use namespace::autoclean;

my %ATTR = (
    description => 'No primary key',
    explanation =>
        'Tables should have one or more columns defined as a primary key.',
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( is => 'ro', isa => 'Str', default => $default );
}

=attr applies_to

This policy applies to L<MooseX::Types::DBIx::Class|MooseX::Types::DBIx::Class>
I<ResultSource>s.

=cut

has applies_to => ( is => 'ro', default => sub { [ResultSource] } );

=method violates

Returns true if the L<"current element"|DBIx::Class::Schema::Critic::Policy>'s
C<primary_columns> method returns nothing.

=cut

sub violates { return !scalar shift->element->primary_columns }

with 'DBIx::Class::Schema::Critic::Policy';
__PACKAGE__->meta->make_immutable();
1;

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;
    my $critic = DBIx::Class::Schema::Critic->new();
    $critic->critique();

=head1 DESCRIPTION

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has zero primary columns.
