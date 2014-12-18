
BEGIN {
    unless ( $ENV{AUTHOR_TESTING} ) {
        require Test::More;
        Test::More::plan(
            skip_all => 'these tests are for testing by the author' );
    }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::NoTabs 0.09

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'bin/dbcritic',
    'lib/App/DBCritic.pm',
    'lib/App/DBCritic/Loader.pm',
    'lib/App/DBCritic/Policy.pm',
    'lib/App/DBCritic/Policy/BidirectionalRelationship.pm',
    'lib/App/DBCritic/Policy/DuplicateRelationships.pm',
    'lib/App/DBCritic/Policy/NoPrimaryKey.pm',
    'lib/App/DBCritic/Policy/NullableTextColumn.pm',
    'lib/App/DBCritic/PolicyType.pm',
    'lib/App/DBCritic/PolicyType/ResultSet.pm',
    'lib/App/DBCritic/PolicyType/ResultSource.pm',
    'lib/App/DBCritic/PolicyType/Schema.pm',
    'lib/App/DBCritic/Violation.pm',
    't/00-compile.t',
    't/000-report-versions.t',
    't/author-critic.t',
    't/author-eol.t',
    't/author-no-tabs.t',
    't/loader.t',
    't/policy/bidirectional_relationship.t',
    't/policy/bidirectional_relationship/lib/perl5/MySchema.pm',
    't/policy/bidirectional_relationship/lib/perl5/MySchema/Result/OneWay.pm',
    't/policy/bidirectional_relationship/lib/perl5/MySchema/Result/Reciprocates.pm',
    't/policy/duplicate_relationships.t',
    't/policy/duplicate_relationships/lib/perl5/MySchema.pm',
    't/policy/duplicate_relationships/lib/perl5/MySchema/Result/Duplicates.pm',
    't/policy/duplicate_relationships/lib/perl5/MySchema/Result/NoDuplicates.pm',
    't/policy/no_primary_key.t',
    't/policy/no_primary_key/lib/perl5/MySchema.pm',
    't/policy/no_primary_key/lib/perl5/MySchema/Result/HasPrimaryKey.pm',
    't/policy/no_primary_key/lib/perl5/MySchema/Result/NoPrimaryKey.pm',
    't/policy/nullable_text_column.t',
    't/policy/nullable_text_column/lib/perl5/MySchema.pm',
    't/policy/nullable_text_column/lib/perl5/MySchema/Result/NullableTextColumn.pm',
    't/release-cpan-changes.t',
    't/release-dist-manifest.t',
    't/release-distmeta.t',
    't/release-kwalitee.t',
    't/release-localbrew-perl-5.12.5-TEST.t',
    't/release-localbrew-perl-latest-TEST.t',
    't/release-meta-json.t',
    't/release-minimum-version.t',
    't/release-mojibake.t',
    't/release-pod-coverage.t',
    't/release-pod-linkcheck.t',
    't/release-pod-syntax.t',
    't/release-portability.t',
    't/release-synopsis.t',
    't/release-test-version.t',
    't/release-unused-vars.t',
    't/schema.t',
    't/schema/lib/perl5/MySchema.pm',
    't/schema/lib/perl5/MySchema/Result/Item.pm',
    't/script.t'
);

notabs_ok($_) foreach @files;
done_testing;
