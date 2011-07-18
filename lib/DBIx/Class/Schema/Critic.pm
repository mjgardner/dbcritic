package DBIx::Class::Schema::Critic;

# ABSTRACT: Critique a database schema for best practices

use Modern::Perl;
use English '-no_match_vars';

=method policies

Returns an array of loaded policy names that will be applied during
L</critique>.  By default all modules under the
C<DBIx::Class::Schema::Critic::Policy> namespace are loaded.

=cut

use Module::Pluggable
    search_path => [ __PACKAGE__ . '::Policy' ],
    sub_name    => 'policies',
    instantiate => 'new';
use List::MoreUtils 'any';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class 'Schema';
use DBIx::Class::Schema::Critic::Types 'Policy';

#use namespace::autoclean;
with 'MooseX::Getopt';

=attr schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=cut

has schema => ( ro, required,
    isa         => Schema,
    traits      => ['Getopt'],
    cmd_aliases => 's',
    writer      => '_set_schema',
);

=method critique

=over

=item Arguments: none

=item Return value: none

=back

Runs the L</schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded.

=cut

sub critique {
    my $self   = shift;
    my $schema = $self->schema;

    for my $policy ( $self->_policies_can('Schema') ) {
        if ( $policy->violates( ($schema) x 2 ) ) {
            say $policy->violation->stringify();
        }
    }

    for my $policy ( $self->_policies_can('ResultSource') ) {
        for my $source ( $schema->sources ) {
            if ( $policy->violates( $schema->source($source), $schema ) ) {
                say $policy->violation->stringify();
            }
        }
    }

    for my $source ( $schema->sources ) {
        for my $policy ( $self->_policies_can('ResultSet') ) {
            if ( $policy->violates( $schema->resultset($source), $schema ) ) {
                say $policy->violation->stringify();
            }
        }
    }
    return;
}

sub _policies_can {
    my ( $self, $type ) = @ARG;
    return grep { _policy_applies_to( $ARG, $type ) } $self->policies;
}

sub _policy_applies_to {
    my ( $policy, $type ) = @ARG;
    return any { $ARG->name eq "MooseX::Types::DBIx::Class::$type" }
    @{ $policy->applies_to };
}

__PACKAGE__->meta->make_immutable();
1;
