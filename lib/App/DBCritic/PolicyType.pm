package App::DBCritic::PolicyType;

use strict;
use utf8;
use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

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
    ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
    default => quote_sub( <<'END_SUB' => { '$package' => \__PACKAGE__ } ),
        [   List::MoreUtils::apply {s/\A .+ :://xms}
            grep { shift->does($_) } Devel::Symdump->packages($package),
        ];
END_SUB
);

1;

# ABSTRACT: Role for types of database criticism policies

__END__

=head1 SYNOPSIS

    package App::DBCritic::PolicyType::ResultClass;
    use Moo;
    with 'App::DBCritic::PolicyType';
    1;

=head1 DESCRIPTION

This is a L<role|Moo::Role> consumed by all L<App::DBCritic|App::DBCritic>
policy types.

=attr applies_to

Returns an array reference containing the last component of all the
C<App::DBCritic::PolicyType> roles composed into the consuming class.
