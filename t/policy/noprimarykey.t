#!perl
use utf8;
use strict;
use Modern::Perl;

use Test::Most tests => 1;
use English '-no_match_vars';
use Modern::Perl;
use FindBin;
use local::lib "$FindBin::Bin/noprimarykey";
use DBICx::TestDatabase;
use DBIx::Class::Schema::Critic;

my $schema = DBICx::TestDatabase->new('MySchema');
my $critic = DBIx::Class::Schema::Critic->new( schema => $schema );
cmp_bag( [ map { $ARG->element->name } $critic->violations ],
    ['no_primary_key'] );
