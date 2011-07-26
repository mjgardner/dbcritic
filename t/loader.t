#!perl

use Modern::Perl;
use Test::Most tests => 1;
use Path::Class;
use FindBin;
use local::lib dir( $FindBin::Bin, 'schema' )->stringify();
use DBICx::TestDatabase;
use DBIx::Class::Schema::Critic;

my $schema = DBICx::TestDatabase->new('MySchema');
my $critic = new_ok( 'DBIx::Class::Schema::Critic' => [ schema => $schema ] );
