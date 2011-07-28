package DBIx::Class::Schema::Critic;

use strict;
use utf8;
use Modern::Perl;

our $VERSION = '0.004';    # VERSION
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
has dsn => (
    %string_options,
    cmd_aliases   => 'd',
    documentation => 'Data source name in Perl DBI format',
);
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

__END__

=pod

=for :stopwords Mark Gardner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

DBIx::Class::Schema::Critic - Critique a database schema for best practices

=head1 VERSION

version 0.004

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

=head1 ATTRIBUTES

=head2 class_name

The name of a L<DBIx::Class::Schema|DBIx::Class::Schema> class you wish to
L</critique>.
Only settable at construction time.

=head2 schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=head2 dsn

=head2 username

=head2 password

The L<DBI|DBI> data source name and optional username and password used to
connect to the database.  If no L</class_name> or L</schema> is provided,
L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> will then construct
schema classes dynamically to be critiqued.

=head1 METHODS

=head2 policies

Returns an array of loaded policy names that will be applied during
L</critique>.  By default all modules under the
C<DBIx::Class::Schema::Critic::Policy> namespace are loaded.

=head2 critique

Runs the L</schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded and dumps a string representation of
L</violations> to C<STDOUT>.

=head2 violations

Returns a list of all
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>s
picked up by the various policies.

=head1 SEE ALSO

=over

=item L<Perl::Critic|Perl::Critic>

=item L<DBIx::Class|DBIx::Class>

=item L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader>

=back

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc DBIx::Class::Schema::Critic

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/DBIx-Class-Schema-Critic>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annonations of Perl module documentation.

L<http://annocpan.org/dist/DBIx-Class-Schema-Critic>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/DBIx-Class-Schema-Critic>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.perl.org/dist/overview/DBIx-Class-Schema-Critic>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/D/DBIx-Class-Schema-Critic>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual way to determine what Perls/platforms PASSed for a distribution.

L<http://matrix.cpantesters.org/?dist=DBIx-Class-Schema-Critic>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=DBIx::Class::Schema::Critic>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at L<https://github.com/mjgardner/DBIx-Class-Schema-Critic/issues>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/DBIx-Class-Schema-Critic>

  git clone git://github.com/mjgardner/DBIx-Class-Schema-Critic.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Mark Gardner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
