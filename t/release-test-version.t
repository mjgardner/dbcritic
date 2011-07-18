#!/usr/bin/perl
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

use 5.006;
use strict;
use warnings;
use Test::More;

eval "use Test::Version 0.04";
plan skip_all => "Test::Version 0.04 required for testing versions"
    if $@;

version_all_ok();
done_testing;
