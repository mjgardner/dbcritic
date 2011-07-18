#!perl
use utf8;
use strict;

use Test::Most;
use GSI::Automerge::Connection;

use DBIx::Class::Schema::Critic;

my $connection = GSI::Automerge::Connection->new();
my $critic
    = DBIx::Class::Schema::Critic->new( schema => $connection->schema );
$critic->critique();
