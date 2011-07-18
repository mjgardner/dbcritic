use utf8;
use strict;
use Modern::Perl;

package DBIx::Class::Schema::Critic;

BEGIN {
    $DBIx::Class::Schema::Critic::VERSION = '0.001';
}

BEGIN {
    $DBIx::Class::Schema::Critic::DIST = 'DBIx-Class-Schema-Critic';
}

# ABSTRACT: Critique a database schema for best practices

use Modern::Perl;
use English '-no_match_vars';

use Module::Pluggable
    search_path => [ __PACKAGE__ . '::Policy' ],
    sub_name    => 'policies',
    instantiate => 'new';

use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'ArrayRef';
use MooseX::Types::DBIx::Class 'Schema';
use DBIx::Class::Schema::Critic::Types 'Policy';

#use namespace::autoclean;
with 'MooseX::Getopt';

has schema => ( ro, required,
    isa         => Schema,
    traits      => ['Getopt'],
    cmd_aliases => 's',
    writer      => '_set_schema',
);

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
    my $self = shift;
    return grep { $ARG->can_critique(@ARG) } $self->policies;
}

__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=for :stopwords Mark Gardner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

DBIx::Class::Schema::Critic - Critique a database schema for best practices

=head1 VERSION

version 0.001

=head1 ATTRIBUTES

=head2 schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=head1 METHODS

=head2 policies

Returns an array of loaded policy names that will be applied during
L</critique>.  By default all modules under the
C<DBIx::Class::Schema::Critic::Policy> namespace are loaded.

=head2 critique

=over

=item Arguments: none

=item Return value: none

=back

Runs the L</schema> through the DBIx::Class::Schema::Critic engine using all
the policies that have been loaded.

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
