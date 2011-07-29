package DBIx::Class::Schema::Critic::Policy;

use strict;
use utf8;
use Modern::Perl;

our $VERSION = '0.011';    # VERSION
use Moo::Role;
use DBIx::Class::Schema::Critic::Violation;
use namespace::autoclean -also => qr{\A _}xms;

requires qw(description explanation applies_to violates);

around violates => sub {
    my ( $orig, $self ) = splice @_, 0, 2;
    $self->_set_element(shift);
    $self->_set_schema(shift);

    my $details = $self->$orig(@_);
    return $self->violation($details) if $details;

    return;
};

has element => ( is => 'ro', init_arg => undef, writer => '_set_element' );

sub violation {
    my $self = shift;
    return DBIx::Class::Schema::Critic::Violation->new(
        details => shift,
        map { $_ => $self->$_ } qw(description explanation element),
    );
}

has schema => ( is => 'ro', writer => '_set_schema' );

1;

# ABSTRACT: Role for criticizing database schemas

__END__

=pod

=for :stopwords Mark Gardner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=encoding utf8

=head1 NAME

DBIx::Class::Schema::Critic::Policy - Role for criticizing database schemas

=head1 VERSION

version 0.011

=head1 SYNOPSIS

    package DBIx::Class::Schema::Critic::Policy::MyPolicy;
    use Moo;

    has description => ( default => sub{'Follow my policy'} );
    has explanation => ( default => {'My way or the highway'} );
    has applies_to  => ( default => sub { ['ResultSource'] } );
    with 'DBIx::Class::Schema::Critic::Policy';

    sub violates { $_[0]->element ne '' }

=head1 DESCRIPTION

This is a L<role|Moo::Role> consumed by all
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> policy plugins.

=head1 ATTRIBUTES

=head2 element

Read-only accessor for the current schema element being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=head2 schema

Read-only accessor for the current schema object being examined by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=head1 METHODS

=head2 violation

Given a string description of a violation that has been encountered, creates a
new
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object from the current policy.

=head1 REQUIRED METHODS

=head2 description

Returns a short string describing what's wrong.

=head2 explanation

Returns a string giving further details.

=head2 applies_to

Returns an array reference of types of L<DBIx::Class|DBIx::Class> objects
indicating what part(s) of the schema the policy is interested in.

=head2 violates

Role consumers must implement a C<violates> method that returns true if the
policy is violated and false otherwise, based on attributes provided by the
role.  Callers should call the C<violates> method as the following:

    $policy->violates($element, $schema);

=over

=item Arguments: I<$element>, I<$schema>

=item Return value: nothing if the policy passes, or a
L<DBIx::Class::Schema::Critic::Violation|DBIx::Class::Schema::Critic::Violation>
object if it doesn't.

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
