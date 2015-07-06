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

package Interject::Server;

use 5.020002;
use strict;
use warnings;

require Exporter;

use POE;
use POE::Wheel::SocketFactory;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Interject::Server ':all';
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
	$class = shift;
	$self = {};
	bless($self, $class);
	$self->{'localhostname'} = shift;
	$self->{'localportnumber'} = shift;
	$self->{'proxyconnections'} = shift;
	POE::Session->create(object_states => [$self => ["_start", "_stop", "_acceptsuccess", "_acceptfailure"]]);
	return $self;
}

sub _start {
	my $kernel;
	my $self;
	($kernel, $self) = @_[KERNEL, OBJECT];
	$self->{'serverwheelhandle'} = POE::Wheel::SocketFactory->new(BindAddress  => $self->{'localhostname'}, BindPort => $self->{'localportnumber'}, Reuse => "yes", SuccessEvent => "_acceptsuccess", FailureEvent => "_acceptfailure");
	# TODO handle listener failed
}

sub _stop {
	my $kernel;
	my $self;
	($kernel, $self) = @_[KERNEL, OBJECT];
}

sub _acceptsuccess {
	my $kernel;
	my $self;
	my $sockethandle;
	my $clienthostname;
	my $clientportnumber;
	($kernel, $self, $sockethandle, $clienthostname, $clientportnumber) = @_[KERNEL, OBJECT, ARG0, ARG1, ARG2];
	push(@{$self->{'acceptedproxyconnections'}}, $self->{'proxyconnections'}->accept($sockethandle, $clienthostname, $clientportnumber));
}

sub _acceptfailure {
	my $kernel;
	my $self;
	my $socketoperation;
	my $errornumber;
	my $errorstring;
	($kernel, $self, $socketoperation, $errornumber, $errorstring) = @_[KERNEL, OBJECT, ARG0, ARG1, ARG2];
	delete($self->{'serverwheelhandle'}); 
}

1;
__END__

=head1 NAME

Interject::Server - Perl extension for Interject to handle the listeners

=head1 SYNOPSIS

  use Interject::Server;

TODO

=head1 DESCRIPTION

C<Interject::Server> is a Perl extension for Interject to handle the listeners. The following methods are available:

=over 4

=item Interject::Server->new(<localhostname>, <localportnumber>, <remotehostname>, <proxyconnections>)

Constructs a new C<Interject::Server> object describing the server.

=head1 SEE ALSO

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
