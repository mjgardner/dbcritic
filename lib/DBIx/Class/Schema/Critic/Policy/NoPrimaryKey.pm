package DBIx::Class::Schema::Critic::Policy::NoPrimaryKey;

# ABSTRACT: Check for DBIx::Class::Schema::ResultSources without primary keys

use Const::Fast;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::DBIx::Class 'ResultSource';
use MooseX::Types::Moose qw(ArrayRef Str);
use namespace::autoclean;

const my %ATTR => (
    description => 'No primary key for a ResultSource',
    explanation => <<'END_EXPLANATION',
ResultSource tables should have one or more columns defined as a primary key.
END_EXPLANATION
);

while ( my ( $name, $default ) = each %ATTR ) {
    has $name => ( ro, isa => Str, default => $default );
}
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
