# $Revision$
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# (c) Tim Brown, 2015
# <mailto:timb@nth-dimension.org.uk>
# <http://www.nth-dimension.org.uk/> / <http://www.machine.org.uk/>

package Interject::Proxy::Forward;

use 5.020002;
use strict;
use warnings;

require Exporter;

use Interject::Proxy;
use POE;
use POE::Wheel::ReadWrite;
use POE::Wheel::SocketFactory;
use POE::Filter::Stream;
use Socket;
use Interject::Filter;
use Data::Dumper;

our @ISA = qw(Exporter Interject::Proxy);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Interject::Proxy::Forward ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = ('$Revision$' =~ m/.Revision: .* ([\d.]+) .*/)[0];

sub new {
	my $class;
	my $self;
	my $proxyfilters;
	$class = shift;
	$proxyfilters = shift;
	$self = $class->SUPER::new($proxyfilters);
	bless($self, $class);
	$self->{'remotehostname'} = shift;
	$self->{'remoteportnumber'} = shift;
	return $self;
}

sub accept {
	my $self;
	my $clone;
	my $clienthostname;
	$self = shift;
	$clone = $self->SUPER::accept();
	$clone->{'sockethandle'} = shift;
	$clienthostname = shift;
	$clone->{'clienthostname'} = inet_ntoa($clienthostname);
	$clone->{'clientportnumber'} = shift;
	POE::Session->create(object_states => [$clone => ["_start", "_stop", "_remote_connect", "_remote_input", "_remote_error", "_client_input", "_client_error"]]);
	return $clone;
}

sub addfilter {
	my $self;
	my $proxyfilter;
	$self = shift;
	$proxyfilter = shift;
	$self->SUPER::addfilter($proxyfilter);
}

sub _start {
	my $kernel;
	my $self;
	my $session;
	($kernel, $self, $session) = @_[KERNEL, OBJECT, SESSION];
	$self->{'remotequeue'} = [];
	$self->{'remotewheelhandle'} = POE::Wheel::SocketFactory->new(RemoteAddress => $self->{'remotehostname'}, RemotePort => $self->{'remoteportnumber'}, SuccessEvent  => "_remote_connect", FailureEvent => "_remote_error");
	$self->{'clientwheelhandle'} = POE::Wheel::ReadWrite->new(Handle => $self->{'sockethandle'}, Driver => POE::Driver::SysRW->new, Filter => POE::Filter::Stream->new, InputEvent => "_client_input", ErrorEvent => "_client_error");
}

sub _stop {
	my $kernel;
	my $self;
	my $session;
	($kernel, $self, $session) = @_[KERNEL, OBJECT, SESSION];
	if ($self->{'remotewheelhandle'}) {
		delete($self->{'remotewheelhandle'});
	}
	if ($self->{'clientwheelhandle'}) {
		delete($self->{'clientwheelhandle'});
	}
	if ($self->{'sockethandle'}) {
		delete($self->{'sockethandle'});
	}
}

sub _remote_connect {
	my $kernel;
	my $self;
	my $session;
	my $sockethandle;
	my $inputstring;
	my $proxyfilter;
	($kernel, $self, $session, $sockethandle) = @_[KERNEL, OBJECT, SESSION, ARG0];
	$self->{'remotewheelhandle'} = POE::Wheel::ReadWrite->new(Handle => $sockethandle, Driver => POE::Driver::SysRW->new, Filter => POE::Filter::Stream->new, InputEvent => "_remote_input", ErrorEvent => "_remote_error");
	foreach $inputstring (@{$self->{'remotequeue'}}) {
		foreach $proxyfilter (@{$self->{'proxyfilters'}}) {
			$inputstring = $proxyfilter->apply(Interject::Filter::REMOTE, $self->{'remotehostname'}, $self->{'remoteportnumber'}, $self->{'clienthostname'}, $self->{'clientportnumber'}, $inputstring);
		}
		$self->{'remotewheelhandle'}->put($inputstring);
	}
	$self->{'remotequeue'} = [];
}

sub _remote_input {
	my $kernel;
	my $self;
	my $inputstring;
	my $proxyfilter;
	($kernel, $self, $inputstring) = @_[KERNEL, OBJECT, ARG0];
	if (exists($self->{'clientwheelhandle'})) {
		foreach $proxyfilter (@{$self->{'proxyfilters'}}) {
			$inputstring = $proxyfilter->apply(Interject::Filter::REMOTE, $self->{'remotehostname'}, $self->{'remoteportnumber'}, $self->{'clienthostname'}, $self->{'clientportnumber'}, $inputstring);
		}
		$self->{'clientwheelhandle'}->put($inputstring);
	}
}

sub _remote_error {
	my $kernel;
	my $self;
	my $session;
	my $socketoperation;
	my $errornumber;
	my $errorstring;
	($kernel, $self, $session, $socketoperation, $errornumber, $errorstring) = @_[KERNEL, OBJECT, SESSION, ARG0, ARG1, ARG2];
	$kernel->yield("_stop");
}


sub _client_input {
	my $kernel;
	my $self;
	my $inputstring;
	my $proxyfilter;
	($kernel, $self, $inputstring) = @_[KERNEL, OBJECT, ARG0];
	if (exists($self->{'remotewheelhandle'})) {
		foreach $proxyfilter (@{$self->{'proxyfilters'}}) {
			$inputstring = $proxyfilter->apply(Interject::Filter::CLIENT, $self->{'remotehostname'}, $self->{'remoteportnumber'}, $self->{'clienthostname'}, $self->{'clientportnumber'}, $inputstring);
		}
		$self->{'remotewheelhandle'}->put($inputstring);
	} else {
		push(@{$self->{'remotequeue'}}, $inputstring);
	}
}

sub _client_error {
	my $kernel;
	my $self;
	my $session;
	my $socketoperation;
	my $errornumber;
	my $errorstring;
	($kernel, $self, $session, $socketoperation, $errornumber, $errorstring) = @_[KERNEL, OBJECT, SESSION, ARG0, ARG1, ARG2];
	$kernel->yield("_stop");
}

1;
__END__

=head1 NAME

Interject::Proxy::Forward - Perl extension for Interject to start and manage the forward proxy

=head1 SYNOPSIS

  use Interject::Proxy::Forward;

TODO

=head1 DESCRIPTION

C<Interject::Proxy::Forward> is a Perl extension for Interject to start and manage the forward proxy. The following methods are available:

=over 4

=item Interject::Proxy::Forward->new(<proxyfilters>, <remotehostname>, <remoteportnumber>)

Constructs a new C<Interject::Proxy::Forward> object describing the forward proxy.

=item Interject::Proxy::Forward->accept(<sockethandle>, <clienthostname>, <clientportnumber>)

Constructs a new C<Interject::Proxy::Forward> object accepting the client.

=item Interject::Proxy::Forward->addfilter(<proxyfilter>)

Adds a new C<Intercept::Filter>.

=head1 SEE ALSO

C<Interject::Proxy::Forward>

=head1 AUTHOR

(c) Tim Brown, 2015
<mailto:timb@nth-dimension.org.uk>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Tim Brown

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

=cut
