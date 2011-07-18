package DBIx::Class::Schema::Critic::Violation;

# ABSTRACT: A violation of a DBIx::Class::Schema::Critic::Policy

use Modern::Perl;
use English '-no_match_vars';
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose 'Str';
use DBIx::Class::Schema::Critic::Types 'DBICType';
use overload q{""} => \&stringify;

=attr description

A short string describing what's wrong.  Only settable at construction.

=attr explanation

A string giving further details.  Only settable at construction.

=cut

has [qw(description explanation)] => ( ro, isa => Str );

=attr element

The schema element that violated a
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>,
as an instance of L<DBICType|DBIx::Class::Schema::Critic::Types/DBICType>.
Only settable at construction.

=cut

has element => ( ro, isa => DBICType );

=method stringify

Returns a string representation of the object.  The same method is called if
the object appears in double quotes.

=cut

sub stringify {
    my $self    = shift;
    my $element = $self->element;
    my $type    = ref $element;
    $type =~ s/\A .* :://xms;

    given ($type) {
        when ('Table') {
            $type .= q{ } . $element->from;
        }
    }
    return "[$type] " . $self->description . "\n" . $self->explanation;
}

__PACKAGE__->meta->make_immutable();
1;
