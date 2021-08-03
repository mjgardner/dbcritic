use v5.12;
use Object::Pad 0.47;

package App::DBCritic;
class App::DBCritic;

# ABSTRACT: Critique a database schema for best practices

=head1 SYNOPSIS

    use App::DBCritic;

    my $critic = App::DBCritic->new(
        dsn => 'dbi:Oracle:HR', username => 'scott', password => 'tiger');
    $critic->critique();

=head1 DESCRIPTION

This package is used to scan a database schema and catalog any violations
of best practices as defined by a set of policy plugins.  It takes conceptual
and API inspiration from L<Perl::Critic|Perl::Critic>.

B<dbcritic> is the command line interface.

This is a work in progress - please see the L</SUPPORT> section below for
information on how to contribute.  It especially needs ideas (and
implementations!) of new policies!

=cut

# VERSION
use utf8;
use Carp;
use List::Util 1.33 'any';
use Module::Pluggable
    search_path => [ __PACKAGE__ . '::Policy' ],
    sub_name    => 'policies',
    instantiate => 'new';

=for Pod::Coverage DOES META new

=method policies

Returns an array of loaded policy names that will be applied during
L</critique>.  By default all modules under the
C<App::DBCritic::Policy> namespace are loaded.

=cut

use Scalar::Util 'blessed';
use App::DBCritic::Loader;

has $username :reader :param = undef;

=attr username

The optional username used to connect to the database.

=cut

has $password :reader :param = undef;

=attr password

The optional password used to connect to the database.

=cut

has $class_name :reader :param = undef;

=attr class_name

The name of a L<DBIx::Class::Schema|DBIx::Class::Schema> class you wish to
L</critique>.
Only settable at construction time.

=cut

has $dsn    :reader :param = 'dbi:SQLite::memory:';
has $schema :reader :param = undef;

ADJUST {
    my @connect_info = ( $dsn, $username, $password );

    if ($class_name and eval "require $class_name") {
        $schema = $class_name->connect(@connect_info);
    }
    elsif ( not ( blessed($schema) and $schema->isa('DBIx::Class::Schema') ) ) {
        local $SIG{__WARN__} = sub {
            if ( $_[0] !~ / has no primary key at /ms ) {
                print {*STDERR} $_[0];
            }
        };
        $schema = App::DBCritic::Loader->connect(@connect_info);
    }

    croak 'No schema defined' if not $schema;
}

=attr dsn

The L<DBI|DBI> data source name (required) used to connect to the database.
If no L</class_name> or L</schema> is provided, L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader> will then
construct schema classes dynamically to be critiqued.

=attr schema

A L<DBIx::Class::Schema|DBIx::Class::Schema> object you wish to L</critique>.
Only settable at construction time.

=cut

has %elements;

ADJUST {
    %elements = (
        Schema       => [$schema],
        ResultSource => [ map { $schema->source($_) } $schema->sources ],
        ResultSet    => [ map { $schema->resultset($_) } $schema->sources ],
    );
}

has @violations;

ADJUST {
    @violations = map { $self->_policy_loop( $_, $elements{$_} ) }
        keys %elements;
}

method violations { wantarray ? @violations : \@violations }

=method violations

Returns an array of all
L<App::DBCritic::Violation|App::DBCritic::Violation>s
picked up by the various policies.

=cut

method critique {
    say for @violations;
    return;
}

=method critique

Runs the L</schema> through the C<App::DBCritic> engine using all
the policies that have been loaded and dumps a string representation of
L</violations> to C<STDOUT>.

=cut

sub _policy_applies_to ( $policy, $type ) {
    return any { $_ eq $type } @{ $policy->applies_to };
}

method _policy_loop ($policy_type, $elements_ref) {
    my @_violations;
    for my $policy ( grep { _policy_applies_to( $_, $policy_type ) }
        $self->policies )
    {
        push @_violations, grep {$_}
            map { $policy->violates( $_, $schema ) } @{$elements_ref};
    }
    return @_violations;
}

1;

__END__

=head1 SEE ALSO

=over

=item L<Perl::Critic|Perl::Critic>

=item L<DBIx::Class|DBIx::Class>

=item L<DBIx::Class::Schema::Loader|DBIx::Class::Schema::Loader>

=back
