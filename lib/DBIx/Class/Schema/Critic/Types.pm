package DBIx::Class::Schema::Critic::Types;

# ABSTRACT: Type library for DBIx::Class::Schema::Critic

use English '-no_match_vars';
use MooseX::Types -declare => [qw(DBICType Policy)];
use MooseX::Types::DBIx::Class qw(ResultSet ResultSource Row Schema);
use namespace::autoclean;

=type Policy

An instance of a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.

=cut

role_type Policy,    ## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
    { role => 'DBIx::Class::Schema::Critic::Policy' };

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
    ## no critic (ProhibitCallsToUndeclaredSubs, ProhibitBitwiseOperators)
    subtype DBICType, as ResultSet | ResultSource | Row | Schema;
}

__PACKAGE__->meta->make_immutable();
1;
