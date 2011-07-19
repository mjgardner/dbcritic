use utf8;
use strict;
use Modern::Perl;

package MySchema;
use base 'DBIx::Class::Schema';
__PACKAGE__->load_namespaces();
1;
