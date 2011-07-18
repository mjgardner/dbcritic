package DBIx::Class::Schema::Critic::Policy;

# ABSTRACT: Role for criticizing database schemas

use utf8;
use Modern::Perl;
use English '-no_match_vars';
use Moose::Role;
use MooseX::Has::Sugar;
use MooseX::Types::DBIx::Class 'Schema';
use DBIx::Class::Schema::Critic::Types 'DBICType';
use namespace::autoclean;

=head1 REQUIRED METHODS

=head2 description

Returns a short string describing what's wrong.

=head2 explanation

Returns a string giving further details.

=head2 violates

=over

=item Arguments: I<$element>, I<$schema>

=item Return value: nothing if the policy passes, or a
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object if it doesn't.

=back

=cut

requires qw(description explanation violates);

=attr element

Read-only accessor for the current schema element being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>,
as an instance of L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.

=cut

has element => ( ro,
    init_arg => undef,
    isa      => DBICType,
    writer   => '_set_element',
);

=attr schema

Read-only accessor for the current schema object being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=cut

has schema => ( ro, isa => Schema );

=method violation

=over

=item Arguments: none

=item Return value: A new
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object based on the state of the current policy.

=back

=cut

sub violation {
    my $self = shift;
    return DBIx::Class::Schema::Critic::Violation->new(
        map { $ARG => $self->$ARG } qw(description explanation element),
    );
}

1;
