#!perl

use Modern::Perl;
use Test::Most tests => 1;
use English '-no_match_vars';
use Path::Class;
use FindBin;
use local::lib dir( $FindBin::Bin, 'duplicate_relationships' )->stringify();
use DBICx::TestDatabase;
use DBIx::Class::Schema::Critic;

my $schema = DBICx::TestDatabase->new('MySchema');
my $critic = DBIx::Class::Schema::Critic->new( schema => $schema );
cmp_bag( [ map { $ARG->element->name } @{ $critic->violations } ],
    ['duplicates'] );
