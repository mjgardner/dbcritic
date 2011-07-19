package DBIx::Class::Schema::Critic::Policy;

# ABSTRACT: Role for criticizing database schemas

use Moose::Role;
use MooseX::Has::Sugar;
use DBIx::Class::Schema::Critic::Types 'DBICType';
use DBIx::Class::Schema::Critic::Violation;
use namespace::autoclean;

=head1 REQUIRED METHODS

=head2 description

Returns a short string describing what's wrong.

=head2 explanation

Returns a string giving further details.

=head2 applies_to

Returns an array reference of L<TypeConstraint|Moose::Meta::TypeConstraint>s
s indicating what part(s) of the schema the policy is interested in.  Select
from the list defined in
L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.

=cut

has applies_to => ( ro, isa => 'ArrayRef[Moose::Meta::TypeConstraint]' );

=head2 violates

Role consumers must implement a C<violates> method that returns true if the
policy is violated and false otherwise, based on attributes provided by the
role.  Callers should call the C<violates> method as the following:

    $policy->violates($element, $schema);

=over

=item Arguments: I<$element>, I<$schema>

=item Return value: nothing if the policy passes, or a
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object if it doesn't.

=back

=cut

requires qw(description explanation applies_to violates);

around violates => sub {
    my ( $orig, $self, $element, $schema ) = splice @_, 0, 2;
    $self->_set_element(shift);
    $self->_set_schema(shift);
    return $self->violation if $self->$orig(@_);
    return;
};

=attr element

Read-only accessor for the current schema element being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>,
as an instance of L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.

=cut

has element =>
    ( ro, init_arg => undef, isa => DBICType, writer => '_set_element' );

=attr schema

Read-only accessor for the current schema object being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=cut

has schema => ( ro, isa => 'DBIx::Class::Schema', writer => '_set_schema' );

=method violation

Read-only accessor for a
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object based on the state of the current policy.

=cut

sub violation {
    my $self = shift;
    return DBIx::Class::Schema::Critic::Violation->new(
        map { $_ => $self->$_ } qw(description explanation element) );
}

1;

=head1 SYNOPSIS

    package DBIx::Class::Schema::Critic::Policy::MyPolicy;
    use Moose;
    use MooseX::Types::DBIx::Class 'ResultSource';

    has description => (default => 'Follow my policy');
    has explanation => (default => 'My way or the highway');
    has applies_to => (
        isa     => 'ArrayRef[Moose::Meta::TypeConstraint]',
        default => sub { [ResultSource] },
    );
    with 'DBIx::Class::Schema::Critic::Policy';

    sub violates { $_[0]->element ne '' }

=head1 DESCRIPTION

This is a L<Moose::Role|Moose::Role> consumed by all
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> policy plugins.
