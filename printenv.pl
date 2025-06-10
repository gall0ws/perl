#!/usr/bin/env perl

foreach $key (sort(keys(%ENV))) {
   printf("%16s : %s\n", $key, $ENV{$key});
}
