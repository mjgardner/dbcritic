package DBIx::Class::Schema::Critic::Violation;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Const::Fast;
use Moo;
use Sub::Quote;
use overload q{""} => sub { shift->as_string };

const my @TEXT_FIELDS => qw(description explanation details);
for (@TEXT_FIELDS) {
    has $_ => ( is => 'ro', default => quote_sub q{q{}} );
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

=attr description

A short string briefly describing what's wrong.
Only settable at construction.

=attr explanation

A string giving a longer general description of the problem.
Only settable at construction.

=attr details

A string describing the issue as it specifically applies to the L</element>
being critiqued.

=attr element

The schema element that violated a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>.
Only settable at construction.

=attr as_string

Returns a string representation of the object.  The same method is called if
the object appears in double quotes.
