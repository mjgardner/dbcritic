package DBIx::Class::Schema::Critic::Types;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use MooseX::Types -declare => [qw(DBICType Policy LoadingSchema)];
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class qw(ResultSet ResultSource Row Schema);
use namespace::autoclean;
## no critic (ProhibitCallsToUnexportedSubs,ProhibitCallsToUndeclaredSubs)
## no critic (ProhibitBitwiseOperators)

role_type Policy, { role => 'DBIx::Class::Schema::Critic::Policy' };

subtype LoadingSchema, as Schema;
coerce LoadingSchema, from ArrayRef, via {
    my $loader = Moose::Meta::Class->create_anon_class(
        superclasses => ['DBIx::Class::Schema::Loader'] )->new_object();
    $loader->loader_options( naming => 'v4', generate_pod => 0 );
    local $SIG{__WARN__} = \&_loader_warn;
    $loader->connect( @{$_} );
};

sub _loader_warn {
    my $warning = shift;
    if ( $warning !~ / has no primary key at /ms ) {
        print {*STDERR} "$warning";
    }
    return;
}

subtype DBICType, as ResultSet | ResultSource | Row | Schema;

__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Type library for DBIx::Class::Schema::Critic

=head1 SYNOPSIS

    use Moose;
    use DBIx::Class::Schema::Critic::Types qw(Policy LoadingSchema);

    has policy => (isa => Policy);
    has schema => (isa => LoadingSchema);

=head1 DESCRIPTION

This is a L<"Moose type library"|MooseX::Types> for
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=type Policy

An instance of a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=type LoadingSchema

A subtype of
L<MooseX::Types::DBIx::Class::Schema|MooseX::Types::DBIx::Class>
that can create new schemas from an array reference containing a DSN, user name,
password, and hash references to attributes recognized by L<DBI|DBI> and
L<DBIx::Class|DBIx::Class>.

=type DBICType

An instance of any of the following:

=over

=item L<DBIx::Class::ResultSet|DBIx::Class::ResultSet>

=item L<DBIx::Class::ResultSource|DBIx::Class::ResultSource>

=item L<DBIx::Class::Row|DBIx::Class::Row>

=item L<DBIx::Class::Schema|DBIx::Class::Schema>

=back
