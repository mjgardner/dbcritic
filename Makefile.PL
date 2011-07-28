
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Critique a database schema for best practices',
  'AUTHOR' => 'Mark Gardner <mjgardner@cpan.org>',
  'BUILD_REQUIRES' => {
    'Carp' => '0',
    'DBICx::TestDatabase' => '0',
    'DBIx::Class::Core' => '0',
    'DBIx::Class::Schema' => '0',
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'FindBin' => '0',
    'Path::Class' => '0',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'Test::Most' => '0',
    'local::lib' => '0',
    'perl' => '5.006'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'DBIx-Class-Schema-Critic',
  'EXE_FILES' => [
    'bin/dbic_critic'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'DBIx::Class::Schema::Critic',
  'PREREQ_PM' => {
    'Const::Fast' => '0',
    'DBI' => '0',
    'DBIx::Class::Schema::Loader' => '0',
    'List::MoreUtils' => '0',
    'Modern::Perl' => '0',
    'Module::Pluggable' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'MooseX::Getopt' => '0',
    'MooseX::Has::Sugar' => '0',
    'MooseX::SimpleConfig' => '0',
    'MooseX::Types' => '0',
    'MooseX::Types::DBIx::Class' => '0',
    'MooseX::Types::Moose' => '0',
    'namespace::autoclean' => '0',
    'overload' => '0',
    'utf8' => '0'
  },
  'VERSION' => '0.004',
  'test' => {
    'TESTS' => 't/*.t t/policy/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



