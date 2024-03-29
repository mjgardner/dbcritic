# NAME

dbcritic - Critique a database schema for best practices

# VERSION

version 0.024

# USAGE

    dbcritic --help
    dbcritic --dsn dbi:Oracle:HR --username scott --password tiger
    dbcritic --class_name My::Schema --dsn dbi:mysql:database=db --username perl --password pass

# DESCRIPTION

This is the command line interface to [App::DBCritic](https://metacpan.org/pod/App%3A%3ADBCritic),
a utility for scanning a database schema for violations of best practices.

# CONFIGURATION

All configuration is done via the command line options described by
`dbcritic --help`.

# SUPPORT

## Perldoc

You can find documentation for this module with the perldoc command.

    perldoc dbcritic

## Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

- MetaCPAN

    A modern, open-source CPAN search engine, useful to view POD in HTML format.

    [https://metacpan.org/release/App-DBCritic](https://metacpan.org/release/App-DBCritic)

- CPANTS

    The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

    [http://cpants.cpanauthors.org/dist/App-DBCritic](http://cpants.cpanauthors.org/dist/App-DBCritic)

- CPAN Testers

    The CPAN Testers is a network of smoke testers who run automated tests on uploaded CPAN distributions.

    [http://www.cpantesters.org/distro/A/App-DBCritic](http://www.cpantesters.org/distro/A/App-DBCritic)

- CPAN Testers Matrix

    The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

    [http://matrix.cpantesters.org/?dist=App-DBCritic](http://matrix.cpantesters.org/?dist=App-DBCritic)

- CPAN Testers Dependencies

    The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

    [http://deps.cpantesters.org/?module=bin::dbcritic](http://deps.cpantesters.org/?module=bin::dbcritic)

## Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at [https://github.com/mjgardner/dbcritic/issues](https://github.com/mjgardner/dbcritic/issues). You will be automatically notified of any
progress on the request by the system.

## Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

[https://github.com/mjgardner/dbcritic](https://github.com/mjgardner/dbcritic)

    git clone git://github.com/mjgardner/dbcritic.git

# AUTHOR

Mark Gardner <mjgardner@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Mark Gardner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
