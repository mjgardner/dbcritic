package App::DBCritic::Policy;

# ABSTRACT: Role for criticizing database schemas

=head1 SYNOPSIS

    package App::DBCritic::Policy::MyPolicy;
    use Moo;

    has description => ( default => sub{'Follow my policy'} );
    has explanation => ( default => {'My way or the highway'} );
    has applies_to  => ( default => sub { ['ResultSource'] } );
    with 'App::DBCritic::Policy';

    sub violates { $_[0]->element ne '' }

=head1 DESCRIPTION

This is a L<role|Moo::Role> consumed by all L<App::DBCritic|App::DBCritic>
policy plugins.

=cut

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use English '-no_match_vars';
use Moo::Role;
use App::DBCritic::Violation;
use namespace::autoclean -also => qr{\A _}xms;

requires qw(description explanation violates applies_to);

=method description

Required method. Returns a short string describing what's wrong.

=method explanation

Required method. Returns a string giving further details.

=method applies_to

Required method. Returns an array reference of types of
L<DBIx::Class|DBIx::Class> objects
indicating what part(s) of the schema the policy is interested in.

=cut

around violates => sub {
    my ( $orig, $self ) = splice @_, 0, 2;
    $self->_set_element(shift);
    $self->_set_schema(shift);

    my $details = $self->$orig(@_);
    return $self->violation($details) if $details;

    return;
};

=method violates

Required method. Role consumers must implement a C<violates> method that
returns true if the
policy is violated and false otherwise, based on attributes provided by the
role.  Callers should call the C<violates> method as the following:

    $policy->violates($element, $schema);

=over

=item Arguments: I<$element>, I<$schema>

=item Return value: nothing if the policy passes, or a
L<App::DBCritic::Violation|App::DBCritic::Violation>
object if it doesn't.

=back

=cut

has element => ( is => 'ro', init_arg => undef, writer => '_set_element' );

=attr element

Read-only accessor for the current schema element being examined by
L<App::DBCritic|App::DBCritic>.

=cut

sub violation {
    my $self = shift;
    return App::DBCritic::Violation->new(
        details => shift,
        map { $_ => $self->$_ } qw(description explanation element),
    );
}

=method violation

Given a string description of a violation that has been encountered, creates a
new L<App::DBCritic::Violation|App::DBCritic::Violation>
object from the current policy.

=cut

has schema => ( is => 'ro', writer => '_set_schema' );

=attr schema

Read-only accessor for the current schema object being examined by
L<App::DBCritic|App::DBCritic>.

=cut

1;
