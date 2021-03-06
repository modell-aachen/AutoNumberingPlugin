# See bottom of file for default license and copyright information

package Foswiki::Plugins::AutoNumberingPlugin;

# Always use strict to enforce variable scoping
use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = "1.0";
#use version; our $VERSION = version->declare("v1.1.7");

our $RELEASE = "1.0";

our $SHORTDESCRIPTION = 'Easy numbering in topics.';;

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 2.0 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    return 1;
}

sub beforeCommonTagsHandler {
    return unless Foswiki::Func::getContext()->{'view'};

    my $numbers = [ ];

    $_[0] =~ s/(\n|^)---(\++)(\s*)###/addNumber($1, $2, $3, $numbers)/ge
}

sub addNumber {
    my ( $header, $level, $spaces, $numbers ) = @_;

    my $length = length( $level ) - 1;
    my $string = "$header---$level$spaces";

    # print higher levels
    for ( my $i = 0; $i < $length; $i++ ) {
        @$numbers[$i] = 1 unless @$numbers[$i]; # skipped a level
        $string .= "@$numbers[$i].";
    }

    # increment current level
    @$numbers[$length]++;
    $string .= "@$numbers[$length].";

    # forget the rest
    if(scalar @$numbers > $length) {
        @$numbers = splice(@$numbers, 0, $length + 1);
    }

    return $string;
}


1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: StephanOsthold

Copyright (C) 2008-2013 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.