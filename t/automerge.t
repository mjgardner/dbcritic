#!perl
use utf8;
use strict;
use Modern::Perl;

use Modern::Perl;
use English '-no_match_vars';
use Test::Most;
use GSI::Automerge::Connection;

use DBIx::Class::Schema::Critic;

my $connection = GSI::Automerge::Connection->new();
my $critic
    = DBIx::Class::Schema::Critic->new( schema => $connection->schema );
$critic->critique();
