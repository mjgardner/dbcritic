package DBIx::Class::Schema::Critic::PolicyType::ResultSource;

use strict;
use utf8;
use Modern::Perl;

# VERSION
use Moo::Role;
use namespace::autoclean -also => qr{\A _}xms;
with 'DBIx::Class::Schema::Critic::PolicyType';
1;

# ABSTRACT: Role for ResultSource critic policies

=head1 SYNOPSIS

    package DBIx::Class::Schema::Critic::Policy::MyResultSourcePolicy;
    use Moo;

    has description => ( default => sub{'Follow my policy'} );
    has explanation => ( default => {'My way or the highway'} );
    sub violates { $_[0]->element ne '' }

    with 'DBIx::Class::Schema::Critic::PolicyType::ResultSource';

=head1 DESCRIPTION

This is a role composed into
L<DBIx::Class::Schema::Critic|DBIx::Class::Schema::Critic> policy classes
that are interested in L<ResultSource|DBIx::Class::ResultSource>s.  It takes
care of composing the
L<DBIx::Class::Schema::Critic::Policy|DBIx::Class::Schema::Critic::Policy>
for you.
