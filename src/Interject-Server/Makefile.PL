use 5.020002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Interject::Server',
    VERSION_FROM      => 'lib/Interject/Server.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Interject/Server.pm', # retrieve abstract from module
    AUTHOR            => 'Tim Brown <mailto:timb@nth-dimension.org.uk>',
    LICENSE           => 'gpl'
);
