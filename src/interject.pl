#!/usr/bin/perl

use Interject::Server;
use Interject::Proxy::Forward;
use Interject::Filter::Replace;
use Interject::Filter::Log;

Interject::Server->new("127.0.0.1", 2222, Interject::Proxy::Forward->new([Interject::Filter::Log->new(Interject::Filter::BOTH, "."), Interject::Filter::Replace->new(Interject::Filter::REMOTE, "SSH", "FOOBAR")], "127.0.0.1", 22));
Interject::Server->new("127.0.0.1", 8080, Interject::Proxy::Forward->new([], "127.0.0.1", 80));

POE::Kernel->run();
