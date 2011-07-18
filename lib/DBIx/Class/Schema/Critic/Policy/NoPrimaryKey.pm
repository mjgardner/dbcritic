package DBIx::Class::Schema::Critic::Policy::NoPrimaryKey;

# ABSTRACT: Check for DBIx::Class::Schema::ResultSources without primary keys

use English '-no_match_vars';
use Const::Fast;
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::DBIx::Class 'ResultSource';
use MooseX::Types::Moose qw(ArrayRef Str);
use namespace::autoclean;

=attr description

Returns the short description of what this policy checks.
Required by
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=attr explanation

Returns the long description of what this policy checks.
Required by
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=cut

const my %ATTR => (
    description => 'No primary key',
    explanation =>
        'ResultSource tables should have one or more columns defined as a primary key.',
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( ro, isa => Str, default => $default );
}

=attr applies_to

Returns a reference to an array with one element: a
L<Moose::Meta::TypeConstraint|Moose::Meta::TypeConstraint> for a
L<MooseX::Types::DBIx::Class|MooseX::Types::DBIx::Class> I<ResultSource>.
Required by
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=cut

has applies_to => ( ro,
    isa     => 'ArrayRef[Moose::Meta::TypeConstraint]',
    default => sub { [ResultSource] },
);

with 'DBIx::Class::Schema::Critic::Policy';

=method violates

This policy returns a violation if a
L<DBIx::Class::ResultSource|DBIx::Class::ResultSource> has zero primary columns.

=cut

sub violates { return !scalar $ARG[0]->element->primary_columns }

__PACKAGE__->meta->make_immutable();
1;
