package DBIx::Class::Schema::Critic;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Carp;
use List::MoreUtils 'any';
use Module::Pluggable
    search_path => [ __PACKAGE__ . '::Policy' ],
    sub_name    => 'policies',
    instantiate => 'new';
use Moo;
use Scalar::Util 'blessed';
use DBIx::Class::Schema::Critic::Loader;

for (qw(username password class_name)) { has $_ => ( is => 'ro' ) }

has dsn => ( is => 'ro', lazy => 1, default => \&_build_dsn );

sub _build_dsn {
    my $self = shift;

    ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
    my $dbh = $self->schema->storage->dbh;
    return join q{:} => 'dbi', $dbh->{Driver}{Name}, $dbh->{Name};
}

has schema => (
    is      => 'ro',
    coerce  => 1,
    lazy    => 1,
    default => \&_build_schema,
    coerce  => \&_coerce_schema,
);

sub _build_schema {
    my $self = shift;

    my @connect_info = map { $self->$_ } qw(dsn username password);

    if ( my $class_name = $self->class_name ) {
        return $class_name->connect(@connect_info)
            if eval "require $class_name";
    }

    return _coerce_schema( \@connect_info );
}

sub _coerce_schema {
    my $schema = shift;

    return $schema if blessed $schema and $schema->isa('DBIx::Class::Schema');

    local $SIG{__WARN__} = sub {
        if ( $_[0] !~ / has no primary key at /ms ) { print {*STDERR} $_[0] }
    };
    return DBIx::Class::Schema::Critic::Loader->connect( @{$schema} )
        if ref $schema eq 'ARRAY';
    ## no critic (ErrorHandling::RequireUseOfExceptions)
    croak q{don't know how to make a schema from a } . ref $schema;
}

has _elements => ( is => 'ro', lazy => 1, default => \&_build__elements );

sub _build__elements {
    my $self   = shift;
    my $schema = $self->schema;
    return {
        Schema       => [$schema],
        ResultSource => [ map { $schema->source($_) } $schema->sources ],
        ResultSet    => [ map { $schema->resultset($_) } $schema->sources ],
    };
}

sub critique {
    for ( @{ shift->violations } ) {say}
    return;
}

has violations => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        [   map { $_[0]->_policy_loop( $_, $_[0]->_elements->{$_} ) }
                keys %{ $_[0]->_elements },
        ];
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
    return any { $_ eq $type } @{ $policy->applies_to };
}

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

Runs the L</schema> through the
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> engine using all
the policies that have been loaded and dumps a string representation of
L</violations> to C<STDOUT>.

=method violations

Returns an array reference of all
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>s
picked up by the various policies.

=head1 SEE ALSO

=over

=item L<Perl::Critic|Perl::Critic>

=item L<DBIx::Class|DBIx::Class>

=item L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader>

=back
