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
use MooseX::Types::Moose qw(ArrayRef HashRef Str);
use DBIx::Class::Schema::Critic::Types qw(Policy Schema);
with 'MooseX::Getopt';

=attr dsn

=attr username

=attr password

Instead of providing a schema object, you can provide a L<DBI|DBI> data source
name and optional username and password.
L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> will then construct
schema classes dynamically to be critiqued.

=cut

my %attr = ( dsn => 'd', username => [qw(u user)], password => [qw(p pass)] );
while ( my ( $attr, $cmd ) = each %attr ) {
    has $attr =>
        ( ro, isa => Str, traits => ['Getopt'], cmd_aliases => $cmd );
}

=attr schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=cut

has schema => ( ro, required, coerce, lazy,
    isa     => Schema,
    traits  => ['NoGetopt'],
    default => sub {
        Schema->coerce( [ map { $ARG[0]->$ARG } qw(dsn username password) ] );
    },
);

has _elements => ( ro,
    lazy_build,
    isa     => HashRef,
    traits  => ['Hash'],
    handles => { _element_names => 'keys', _element => 'get' },
);

sub _build__elements {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $schema = shift->schema;
    return {
        Schema       => [$schema],
        ResultSource => [ map { $schema->source($ARG) } $schema->sources ],
        ResultSet    => [ map { $schema->resultset($ARG) } $schema->sources ],
    };
}

=method critique

Runs the L</schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded and dumps a string representation of
L</violations> to C<STDOUT>.

=cut

sub critique {
    for ( shift->violations ) { say "$ARG" }
    return;
}

=method violations

Returns a list of all
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>s
picked up by the various policies.

=cut

has _violations => ( ro, lazy,
    isa     => ArrayRef,
    traits  => ['Array'],
    handles => { violations => 'elements' },
    default => sub {
        [ map { $ARG[0]->_policy_loop( $ARG, $ARG[0]->_element($ARG) ) }
                $ARG[0]->_element_names ];
    },
);

sub _policy_loop {
    my ( $self, $policy_type, $elements_ref ) = @ARG;
    my @violations;
    for my $policy ( grep { _policy_applies_to( $ARG, $policy_type ) }
        $self->policies )
    {
        for my $element ( @{$elements_ref} ) {
            if ( $policy->violates( $element, $self->schema ) ) {
                push @violations, $policy->violation;
            }
        }
    }
    return @violations;
}

sub _policy_applies_to {
    my ( $policy, $type ) = @ARG;
    return any { $ARG->name eq "MooseX::Types::DBIx::Class::$type" }
    @{ $policy->applies_to };
}

__PACKAGE__->meta->make_immutable();
1;
