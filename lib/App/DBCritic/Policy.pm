package App::DBCritic::Policy;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use English '-no_match_vars';
use Moo::Role;
use App::DBCritic::Violation;
use namespace::autoclean -also => qr{\A _}xms;

requires qw(description explanation violates);

around violates => sub {
    my ( $orig, $self ) = splice @ARG, 0, 2;
    $self->_set_element(shift);
    $self->_set_schema(shift);

    my $details = $self->$orig(@ARG);
    return $self->violation($details) if $details;

    return;
};

has element => ( is => 'ro', init_arg => undef, writer => '_set_element' );

sub violation {
    my $self = shift;
    return App::DBCritic::Violation->new(
        details => shift,
        map { $ARG => $self->$ARG } qw(description explanation element),
    );
}

has schema => ( is => 'ro', writer => '_set_schema' );

1;

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
L<App::DBCritic::Violation|App::DBCritic::Violation>
object if it doesn't.

=back

=attr element

Read-only accessor for the current schema element being examined by
L<App::DBCritic|App::DBCritic>.

=attr schema

Read-only accessor for the current schema object being examined by
L<App::DBCritic|App::DBCritic>.

=method violation

Given a string description of a violation that has been encountered, creates a
new L<App::DBCritic::Violation|App::DBCritic::Violation>
object from the current policy.
