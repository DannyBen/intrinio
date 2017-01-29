Testing
==================================================

Run tests with:

    $ run spec

To run a single spec file only, run something like:

    $ run spec api

To ensure tests are running smoothly, you should set your intrinio 
credentials in an environment variable before running:

    $ export INTRINIO_AUTH=username:password
    $ run spec


Testing on CI
--------------------------------------------------

When testing on Travis or Circle, be sure to also set the INTRINIO_AUTH
environment variable.
