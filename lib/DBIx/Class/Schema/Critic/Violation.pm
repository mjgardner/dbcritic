package DBIx::Class::Schema::Critic::Violation;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Moose;
use DBIx::Class::Schema::Critic::Types 'DBICType';
use overload q{""} => \&stringify;

has [qw(description explanation)] => ( is => 'ro', isa => 'Str' );

has element => ( is => 'ro', isa => DBICType );

sub stringify {
    my $self    = shift;
    my $element = $self->element;
    my $type    = ref $element;

    $type =~ s/\A .* :://xms;
    my %TYPE_MAP = (
        Table     => sub { $element->from },
        ResultSet => sub { $element->result_class },
        Schema    => sub {'schema'},
    );
    return "[$type " . $TYPE_MAP{$type}->() . '] ' . join "\n",
        map { $self->$_ } qw(description explanation);
}

__PACKAGE__->meta->make_immutable();
1;

# ABSTRACT: A violation of a DBIx::Class::Schema::Critic::Policy

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic::Violation;

    my $violation = DBIx::Class::Schema::Critic::Violation->new(
        description => 'Violated policy',
        explanation => 'Consult the rulebook',
    );
    print "$violation\n";

=head1 DESCRIPTION

This class represents
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>
violations flagged by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic>.

=attr description

A short string describing what's wrong.  Only settable at construction.

=attr explanation

A string giving further details.  Only settable at construction.

=attr element

The schema element that violated a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>,
as an instance of L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.
Only settable at construction.

=method stringify

Returns a string representation of the object.  The same method is called if
the object appears in double quotes.
