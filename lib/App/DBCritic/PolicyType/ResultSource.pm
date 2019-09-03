package App::DBCritic::PolicyType::ResultSource;

# ABSTRACT: Role for ResultSource critic policies

=head1 SYNOPSIS

    package App::DBCritic::Policy::MyResultSourcePolicy;
    use Moo;

    has description => ( default => sub{'Follow my policy'} );
    has explanation => ( default => {'My way or the highway'} );
    sub violates { $_[0]->element ne '' }

    with 'App::DBCritic::PolicyType::ResultSource';

=head1 DESCRIPTION

This is a role composed into L<App::DBCritic|App::DBCritic> policy classes
that are interested in L<ResultSource|DBIx::Class::ResultSource>s.  It takes
care of composing the L<App::DBCritic::Policy|App::DBCritic::Policy>
for you.

=cut

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use Moo::Role;
use namespace::autoclean -also => qr{\A _}xms;
with 'App::DBCritic::PolicyType';
1;
