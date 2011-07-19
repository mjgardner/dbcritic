package DBIx::Class::Schema::Critic::Types;

# ABSTRACT: Type library for DBIx::Class::Schema::Critic

use MooseX::Types -declare => [qw(DBICType Policy Schema)];
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class qw(ResultSet ResultSource Row);
use namespace::autoclean;

=type Policy

An instance of a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=cut

role_type Policy,    ## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
    { role => 'DBIx::Class::Schema::Critic::Policy' };

=type Schema

A subtype of
L<MooseX::Types::DBIx::Class::Schema|MooseX::Types::DBIx::Class>
that can create new schemas from an array reference containing a DSN, user name,
password, and hash references to attributes recognized by L<DBI|DBI> and
L<DBIx::Class|DBIx::Class>.

=cut

{
    ## no critic (ProhibitCallsToUnexportedSubs,ProhibitCallsToUndeclaredSubs)
    subtype Schema, as MooseX::Types::DBIx::Class::Schema;
    coerce Schema, from ArrayRef, via {
        my $loader = Moose::Meta::Class->create_anon_class(
            superclasses => ['DBIx::Class::Schema::Loader'] )->new_object();
        $loader->loader_options( naming => 'current' );
        $loader->connect( @{$_} );
    };
}

=type DBICType

An instance of any of the following:

=over

=item L<DBIx::Class::ResultSet|DBIx::Class::ResultSet>

=item L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>

=item L<DBIx::Class::Row|DBIx::Class::Row>

=item L<DBIx::Class::Schema|DBIx::Class::Schema>

=back

=cut

{
    ## no critic (ProhibitCallsToUndeclaredSubs,ProhibitCallsToUnexportedSubs)
    ## no critic (Bangs::ProhibitBitwiseOperators)
    subtype DBICType, as ResultSet | ResultSource | Row
        | MooseX::Types::DBIx::Class::Schema;
}

__PACKAGE__->meta->make_immutable();
1;

=head1 SYNOPSIS

    use Moose;
    use DBIx::Class::Schema::Critic::Types qw(Policy Schema);

    has policy => (isa => Policy);
    has schema => (isa => Schema);

=head1 DESCRIPTION

This is a L<"Moose type library"|MooseX::Types> for
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.
