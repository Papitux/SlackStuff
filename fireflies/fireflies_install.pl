#!/usr/bin/env perl
use strict;

if (`ps x | grep ' xscreensaver ' | grep -v grep`) {
	print "XScreenSaver seems to be running. Exit it before running this script.\n";
	exit;
}

my $screensavers = { };

$screensavers->{'fireflies'} 	= '  GL:             "Fireflies 3D"  fireflies --root                          \\n\\';

open XSCREENSAVER, "$ENV{'HOME'}/.xscreensaver";
my @xscreensaver_config_file = <XSCREENSAVER>;
close XSCREENSAVER;

open XSCREENSAVER, ">$ENV{'HOME'}/.xscreensaver";

my $programs_section_flag = 0;
foreach my $line (@xscreensaver_config_file) {
	if ($line =~ /^programs:/) {
		$programs_section_flag = 1;
	} elsif ($programs_section_flag) {
		if ($line =~ /\\\s+/) {
			foreach my $screensaver (keys %{$screensavers}) {
				if ($line =~ /\s$screensaver\s/) {
					delete $screensavers->{$screensaver};
				}
			}
		} else {
			foreach my $screensaver (keys %{$screensavers}) {
				print XSCREENSAVER "$screensavers->{$screensaver}\n";
			}

			$programs_section_flag = 0;
		}
	}
	print XSCREENSAVER "$line";
}

close XSCREENSAVER;
