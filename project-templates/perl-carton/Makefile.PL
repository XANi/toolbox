use 5.012003;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'DPP',
    VERSION_FROM      => 'bin/script.pl', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    EXE_FILES => [ 'bin/script.pl'],
    AUTHOR         => '',
    test      => {TESTS => 't/*.t'}
);
