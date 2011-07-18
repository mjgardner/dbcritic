package DBIx::Class::Schema::Critic::Types;

# ABSTRACT: Type library for DBIx::Class::Schema::Critic

use utf8;
use Modern::Perl;
use English '-no_match_vars';
use MooseX::Types -declare => [qw(DBICType Policy)];
use MooseX::Types::DBIx::Class qw(ResultSet ResultSource Row Schema);
use namespace::autoclean;

role_type Policy,    ## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
    { role => 'DBIx::Class::Schema::Critic::Policy' };

{
    ## no critic (ProhibitCallsToUndeclaredSubs, ProhibitBitwiseOperators)
    subtype DBICType, as ResultSet | ResultSource | Row | Schema;
}

__PACKAGE__->meta->make_immutable();
1;
