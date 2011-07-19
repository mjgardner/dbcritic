use utf8;
use strict;
use Modern::Perl;

package MySchema::Result::NoPrimaryKey;
use base 'DBIx::Class::Core';
__PACKAGE__->table('no_primary_key');
__PACKAGE__->add_columns(qw(foo bar));
1;
