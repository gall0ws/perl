#!/usr/bin/env perl

use strict;
use warnings;
use experimental "switch";
use vars qw($CMD $DID @MODES);

$CMD = "/opt/homebrew/bin/displayplacer";
$DID = "37D8832A-2D66-02CA-B9F7-8F30A301B230";
@MODES = (12, 24, 42, 54, 66);

sub getcurmode {
    for $_ (`$CMD list`) {
        if (/current mode$/) {
            return /mode (\d\d):/;
        }
    }
}

my ($curmode) = getcurmode;
my %incr = (12, 24, 24, 42, 42, 54, 54, 66);
my %decr = (24, 12, 42, 24, 54, 42, 66, 54);
my $newmode;

given ($ARGV[0]) {
    when ('+') {
        $newmode = $incr{$curmode};
    }
    when('-') {
        $newmode = $decr{$curmode};
    }
    when(@MODES) {
        $newmode = $_;
    }
    default {
        $ARGV[0] = "" if ! $ARGV[0];
        (my $err = qq{$0: invalid mode specified ($ARGV[0])
mode must be one of: @MODES
alternatively + (-) to increase (decrease) the current mode
});
        print STDERR "$err";
        exit 1;
    }
}

exit 0 if ! $newmode || $newmode == $curmode;

exec $CMD, "id:$DID mode:$newmode origin:(0,0) degree:0 quiet:true";
