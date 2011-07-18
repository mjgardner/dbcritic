package DBIx::Class::Schema::Critic;

# ABSTRACT: Critique a database schema for best practices

use utf8;
use Modern::Perl;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class 'Schema';
use DBIx::Class::Schema::Critic::Types 'Policy';
use namespace::autoclean;

=attr schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=cut

has schema => ( ro, isa => Schema, writer => '_set_schema' );

=attr policies

A reference to an array of
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>
consumers that will be applied during L</critique>.  Can be set at construction
or via the C<policies> accessor method.

=method add_policy

Adds a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>
consumer to L</policies>.

=cut

has policies => ( rw,
    isa => ArrayRef [Policy],
    traits  => ['Array'],
    handles => { add_policy => 'push' },
);

=method critique

=over

=item Arguments: I<$schema?>

=item Return value: none

=back

Runs the I<$schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded.  If no I<$schema> is provided then the
L</schema> attribute is used.

=cut

sub critique {
    my $self = shift;
    if ( defined $ARG[0] ) { $self->_set_schema(shift) }
    return;
}

__PACKAGE__->meta->make_immutable();
1;
