package App::DBCritic::PolicyType;

# ABSTRACT: Role for types of database criticism policies

=head1 SYNOPSIS

    package App::DBCritic::PolicyType::ResultClass;
    use Moo;
    with 'App::DBCritic::PolicyType';
    1;

=head1 DESCRIPTION

This is a L<role|Moo::Role> consumed by all L<App::DBCritic|App::DBCritic>
policy types.

=cut

use strict;
use utf8;
use Modern::Perl '2011';

# VERSION
require Devel::Symdump;
use List::MoreUtils;
use Moo::Role;
use Sub::Quote;
use namespace::autoclean -also => qr{\A _}xms;
with 'App::DBCritic::Policy';

has applies_to => (
    is   => 'ro',
    lazy => 1,
    default => quote_sub( <<'END_SUB' => { '$package' => \__PACKAGE__ } ),
        [   List::MoreUtils::apply {s/\A .+ :://xms}
            grep { shift->does($_) } Devel::Symdump->packages($package),
        ];
END_SUB
);

=attr applies_to

Returns an array reference containing the last component of all the
C<App::DBCritic::PolicyType> roles composed into the consuming class.

=cut

1;
