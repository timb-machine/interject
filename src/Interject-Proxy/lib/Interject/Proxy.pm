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

package Interject::Proxy;

use 5.020002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Interject::Proxy ':all';
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
 	$self->{'proxyfilters'} = shift;
	return $self;
}

sub accept {
	my $self;
	my $clone;
	$self = shift;
	$clone = bless({%{$self}}, ref($self));
	return $clone;
}
 
sub addfilter {
	my $self;
	my $proxyfilter;
	$self = shift;
	$proxyfilter = shift;
	push(@{$self->{'proxyfilters'}}, $proxyfilter);
}

1;
__END__

=head1 NAME

Interject::Proxy - Perl extension for Interject to start and manage the proxy

=head1 SYNOPSIS

  use Interject::Proxy;

TODO

=head1 DESCRIPTION

C<Interject::Proxy> is a Perl extension for Interject to start and manage the proxy. This class just defines the interface, the following methods will need overriding:

=over 4

=item Interject::Proxy->new(<proxyfilters>)

Constructs a new C<Interject::Proxy> object describing the proxy.

=item Interject::Proxy->accept()

Constructs a new C<Interject::Proxy> object accepting the client.

=item Interject::Proxy->addfilter(<proxyfilter>)

Adds a new C<Intercept::Filter>.

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
