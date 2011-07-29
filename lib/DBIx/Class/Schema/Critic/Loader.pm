package DBIx::Class::Schema::Critic::Loader;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Moo;
extends 'DBIx::Class::Schema::Loader';
__PACKAGE__->loader_options( naming => 'v4', generate_pod => 0 );
1;

# ABSTRACT: Loader class for schemas generated from a database connection

=head1 SYNOPSIS

    use DBIx::Class::Schema::Critic::Loader;
    my $schema = DBIx::Class::Schema::Critic::Loader->connect('dbi:sqlite:foo');

=head1 DESCRIPTION

This is a simple subclass of
L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> used by
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> to dynamically
generate a schema based on a database connection.
