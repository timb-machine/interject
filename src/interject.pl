#!/usr/bin/perl
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
# <http://www.nth-dimension.org.uk/> / <http://www.machine.org.uk/

use Interject::Server;
use Interject::Proxy::Forward;
use Interject::Filter::Replace;
use Interject::Filter::Log;

Interject::Server->new("127.0.0.1", 2222, Interject::Proxy::Forward->new([Interject::Filter::Log->new(Interject::Filter::BOTH, "."), Interject::Filter::Replace->new(Interject::Filter::REMOTE, "SSH", "FOOBAR")], "127.0.0.1", 22));
Interject::Server->new("127.0.0.1", 8080, Interject::Proxy::Forward->new([], "127.0.0.1", 80));

POE::Kernel->run();
