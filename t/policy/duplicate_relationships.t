#!/usr/bin/env perl

use Modern::Perl '2011';
use Test::Most tests => 1;
use English '-no_match_vars';
use Path::Class;
use FindBin;
use local::lib dir( $FindBin::Bin, 'duplicate_relationships' )->stringify();
use DBICx::TestDatabase;
use App::DBCritic;

my $schema = DBICx::TestDatabase->new('MySchema');
my $critic = App::DBCritic->new( schema => $schema );
cmp_bag( [ map { $_->element->name } @{ $critic->violations } ],
    ['duplicates'] );
