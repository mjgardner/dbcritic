package DBIx::Class::Schema::Critic::Violation;

use strict;
use utf8;
use Modern::Perl;

our $VERSION = '0.010';    # VERSION
use Const::Fast;
use Moo;
use overload q{""} => sub { shift->as_string };

const my @TEXT_FIELDS => qw(description explanation details);
for (@TEXT_FIELDS) {
    has $_ => ( is => 'ro', default => sub {q{}} );
}

has element => ( is => 'ro' );
has as_string => ( is => 'ro', lazy => 1, default => \&_build_as_string );

sub _build_as_string {
    my $self    = shift;
    my $element = $self->element;
    my $type    = ref $element;

    $type =~ s/\A .* :://xms;
    const my %TYPE_MAP => (
        Table     => $element->from,
        ResultSet => $element->result_class,
        Schema    => 'schema',
    );
    return "[$type $TYPE_MAP{$type}] " . join "\n",
        map { $self->$_ } @TEXT_FIELDS;
}

1;

# ABSTRACT: A violation of a DBIx::Class::Schema::Critic::Policy

__END__

=pod

=for :stopwords Mark Gardner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

DBIx::Class::Schema::Critic::Violation - A violation of a DBIx::Class::Schema::Critic::Policy

=head1 VERSION

version 0.010

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic::Violation;

    my $violation = DBIx::Class::Schema::Critic::Violation->new(
        description => 'Violated policy',
        explanation => 'Consult the rulebook',
        description => 'The frob table is improperly swizzled.',
    );
    print "$violation\n";

=head1 DESCRIPTION

This class represents
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>
violations flagged by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=head1 ATTRIBUTES

=head2 description

A short string briefly describing what's wrong.
Only settable at construction.

=head2 explanation

A string giving a longer general description of the problem.
Only settable at construction.

=head2 details

A string describing the issue as it specifically applies to the L</element>
being critiqued.

=head2 element

The schema element that violated a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.
Only settable at construction.

=head2 as_string

Returns a string representation of the object.  The same method is called if
the object appears in double quotes.

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
