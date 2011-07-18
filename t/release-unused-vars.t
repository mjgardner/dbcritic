#!perl
use utf8;
use Modern::Perl;
use English '-no_match_vars';

BEGIN {
    unless ( $ENV{RELEASE_TESTING} ) {
        require Test::More;
        Test::More::plan(
            skip_all => 'these tests are for release candidate testing' );
    }
}

use Test::More;

eval "use Test::Vars";
plan skip_all => "Test::Vars required for testing unused vars"
    if $@;
all_vars_ok();
