#!perl

use Modern::Perl;
use Test::Most tests => 1;
use Path::Class;
use FindBin;
use local::lib dir( $FindBin::Bin, 'schema' )->stringify();
use DBIx::Class::Schema::Critic;

my $critic
    = new_ok( 'DBIx::Class::Schema::Critic' => [ class_name => 'MySchema' ] );
