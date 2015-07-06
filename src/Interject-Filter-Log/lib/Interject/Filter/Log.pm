package Interject::Filter::Log;

use 5.020002;
use strict;
use warnings;

require Exporter;

use Interject::Filter;

our @ISA = qw(Exporter Interject::Filter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Interject::Filter::Log ':all';
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
	my $filterdirection;
	my $self;
	$class = shift;
	$filterdirection = shift;
	$self = $class->SUPER::new($filterdirection);
	bless($self, $class);
	$self->{'directoryname'} = shift;
	return $self;
}
 
sub apply {
	my $self;
	my $filterdirection;
	my $remotehostname;
	my $remoteportnumber;
	my $clienthostname;
	my $clientportnumber;
	my $inputstring;
	my $filehandle;
	$self = shift;
	$filterdirection = shift;
	$remotehostname = shift;
	$remoteportnumber = shift;
	$clienthostname = shift;
	$clientportnumber = shift;
	$inputstring = shift;
	$self->SUPER::apply($filterdirection, $remotehostname, $remoteportnumber, $clienthostname, $clientportnumber, $inputstring);
	if (($self->{'filterdirection'} eq $self->SUPER::BOTH) || ($self->{'filterdirection'} eq $filterdirection)) {
		open($filehandle, ">>" . $self->{'directoryname'} . "/" . $remotehostname . ":" . $remoteportnumber . "-" . $clienthostname . ":" . $clientportnumber . ".log");
		print $filehandle (($filterdirection eq $self->SUPER::REMOTE) ? "R> " : "C> ") . $inputstring . "\n";
		close($filehandle);
	}
	return $inputstring;
}

1;
__END__

=head1 NAME

Interject::Filter::Log - Perl extension for Interject to replace the input

=head1 SYNOPSIS

  use Interject::Filter::Log;

TODO

=head1 DESCRIPTION

C<Interject::Filter> is a Perl extension for Interject to replace the input. The following methods are available:

=over 4

=item Interject::Filter::Log->new(<filtertdirection>, <directorypath>)

Constructs a new C<Interject::Filter::Log> object describing the replacement.

=item Interject::Filter::Log->apply(<filterdirection>, <remotehostname>, <remoteportnumber>, <clienthostname>, <clientportnumber>, <inputstring>)

Apply the replacement.

=head1 SEE ALSO

C<Interject::Filter>

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
