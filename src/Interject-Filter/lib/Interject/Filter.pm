package Interject::Filter;

use 5.020002;
use strict;
use warnings;

require Exporter;

use constant {
	REMOTE => 1,
	CLIENT => 2,
	BOTH => 3
};

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Interject::Filter ':all';
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
	$self->{'filterdirection'} = shift;
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
	$self = shift;
	$filterdirection = shift;
	$remotehostname = shift;
	$remoteportnumber = shift;
	$clienthostname = shift;
	$clientportnumber = shift;
	$inputstring = shift;
	return $inputstring;
}

1;
__END__

=head1 NAME

Interject::Filter - Perl extension for Interject to filter the input

=head1 SYNOPSIS

  use Interject::Filter;

TODO

=head1 DESCRIPTION

C<Interject::Filter> is a Perl extension for Interject to filter the input. This class just defines the interface, the following methods will need overriding:

=over 4

=item Interject::Filter->new(<filtertdirection>)

Constructs a new C<Interject::Filter> object describing the filter.

=item Interject::Filter->apply(<remotehostname>, <remoteportnumber>, <clienthostname>, <clientportnumber>, <inputstring>)

Apply the filter.

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
