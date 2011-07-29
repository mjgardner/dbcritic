package DBIx::Class::Schema::Critic;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use List::MoreUtils 'any';
use Module::Pluggable
    search_path => [ __PACKAGE__ . '::Policy' ],
    sub_name    => 'policies',
    instantiate => 'new';
use Moose;
use MooseX::Has::Sugar;
use DBIx::Class::Schema::Critic::Types qw(Policy LoadingSchema);
with qw(MooseX::Getopt MooseX::SimpleConfig);

my %string_options = ( ro, isa => 'Str', traits => ['Getopt'] );
has dsn => ( required, lazy_build,
    %string_options,
    cmd_aliases   => 'd',
    documentation => 'Data source name in Perl DBI format',
);

sub _build_dsn {    ## no critic (ProhibitUnusedPrivateSubroutines)
    ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
    my $dbh = shift->schema->storage->dbh;
    return join q{:} => 'dbi', $dbh->{Driver}{Name}, $dbh->{Name};
}

has username => (
    %string_options,
    cmd_aliases   => [qw(u user)],
    documentation => 'User name for connecting to the database',
);
has password => (
    %string_options,
    cmd_aliases   => [qw(p pass)],
    documentation => 'Password for connecting to the database',
);
has class_name => (
    %string_options,
    cmd_aliases   => [qw(c class)],
    documentation => 'Name of DBIx::Class::Schema subclass to critique',
);

has schema => ( ro, required, coerce, lazy_build,
    isa    => LoadingSchema,
    traits => ['NoGetopt'],
);

sub _build_schema {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    my @connect_info = map { $self->$_ } qw(dsn username password);

    if ( my $class_name = $self->class_name ) {
        return $class_name->connect(@connect_info)
            if eval "require $class_name";
    }

    return LoadingSchema->coerce( \@connect_info );
}

has _elements => ( ro, lazy_build,
    isa     => 'HashRef',
    traits  => ['Hash'],
    handles => { _element_names => 'keys', _element => 'get' },
);

sub _build__elements {    ## no critic (ProhibitUnusedPrivateSubroutines)
    my $schema = shift->schema;
    return {
        Schema       => [$schema],
        ResultSource => [ map { $schema->source($_) } $schema->sources ],
        ResultSet    => [ map { $schema->resultset($_) } $schema->sources ],
    };
}

sub critique {
    for ( shift->violations ) {say}
    return;
}

has _violations => ( ro, lazy,
    isa     => 'ArrayRef',
    traits  => ['Array'],
    handles => { violations => 'elements' },
    default => sub {
        [ map { $_[0]->_policy_loop( $_, $_[0]->_element($_) ) }
                $_[0]->_element_names ];
    },
);

sub _policy_loop {
    my ( $self, $policy_type, $elements_ref ) = @_;
    my @violations;
    for my $policy ( grep { _policy_applies_to( $_, $policy_type ) }
        $self->policies )
    {
        push @violations, grep {$_}
            map { $policy->violates( $_, $self->schema ) } @{$elements_ref};
    }
    return @violations;
}

sub _policy_applies_to {
    my ( $policy, $type ) = @_;
    return any { $_->name eq "MooseX::Types::DBIx::Class::$type" }
    @{ $policy->applies_to };
}

__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: Critique a database schema for best practices

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic;
    my $critic = DBIx::Class::Schema::Critic->new();
    $critic->critique();

=head1 DESCRIPTION

This package is used to scan a database schema and catalog any violations
of best practices as defined by a set of policy plugins.  It takes conceptual
and API inspiration from L<Perl::Critic|Perl::Critic>.

B<dbic_critic> is the command line interface.

This is a work in progress - please see the L</SUPPORT> section below for
information on how to contribute.  It especially needs ideas (and
implementations!) of new policies!

=method policies

Returns an array of loaded policy names that will be applied during
L</critique>.  By default all modules under the
C<DBIx::Class::Schema::Critic::Policy> namespace are loaded.

=attr class_name

The name of a L<DBIx::Class::Schema|DBIx::Class::Schema> class you wish to
L</critique>.
Only settable at construction time.

=attr schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=attr dsn

=attr username

=attr password

The L<DBI|DBI> data source name (required) and optional username and password
used to connect to the database.  If no L</class_name> or L</schema> is
provided, L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> will then
construct schema classes dynamically to be critiqued.

=method critique

Runs the L</schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded and dumps a string representation of
L</violations> to C<STDOUT>.

=method violations

Returns a list of all
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>s
picked up by the various policies.

=head1 SEE ALSO

=over

=item L<Perl::Critic|Perl::Critic>

=item L<DBIx::Class|DBIx::Class>

=item L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader>

=back
