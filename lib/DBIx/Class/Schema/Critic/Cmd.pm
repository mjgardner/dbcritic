package DBIx::Class::Schema::Critic::Cmd;

# ABSTRACT: Command line parser for DBIx::Class::Schema::Critic

use English '-no_match_vars';
use Try::Tiny;
use Moose;
use MooseX::Types::Moose 'ClassName';
use MooseX::NonMoose;
use DBIx::Class::Schema::Critic;
use namespace::autoclean;
extends 'App::Cmd::Simple';

override opt_spec => sub {
    return ( [ 'schema=s' => 'schema class name' ], );
};

override validate_args => sub {
    my ( $self, $opt_ref, $args_ref ) = @ARG;

    if ( @{$args_ref} ) { $self->usage_error('No args allowed') }

    ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
    try { require $opt_ref->{schema} }
    catch { $self->usage_error("Couldn't load $opt_ref->{schema}") };

    return;
};

override execute => sub {
    my ( $self, $opt_ref, $args_ref ) = @ARG;

    ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
    my $critic = DBIx::Class::Schema::Critic->new(
        { schema => $opt_ref->{schema} } );
    $critic->critique();

    return;
};

__PACKAGE__->meta->make_immutable();
1;
