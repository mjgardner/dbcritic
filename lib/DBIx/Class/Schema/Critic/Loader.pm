package DBIx::Class::Schema::Critic::Loader;
use Moo;
extends 'DBIx::Class::Schema::Loader';
__PACKAGE__->loader_options( naming => 'v4', generate_pod => 0 );
1;

# ABSTRACT: Loader class for schemas generated from a database connection
