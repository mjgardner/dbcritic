package App::DBCritic::Loader;

# ABSTRACT: Loader class for schemas generated from a database connection

=head1 SYNOPSIS

    use App::DBCritic::Loader;
    my $schema = App::DBCritic::Loader->connect('dbi:sqlite:foo');

=head1 DESCRIPTION

This is a simple subclass of
L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> used by
L<App::DBCritic|App::DBCritic> to dynamically
generate a schema based on a database connection.

=cut

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use Moo;
extends 'DBIx::Class::Schema::Loader';
__PACKAGE__->loader_options( naming => 'v4', generate_pod => 0 );
1;
