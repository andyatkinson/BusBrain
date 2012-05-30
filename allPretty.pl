#!/usr/bin/perl

my @files;

push(@files, glob("*/*.m */*.h"));
push(@files, glob("*/*/*.m */*/*.h"));
push(@files, glob("*/*/*/*.m */*/*/*.h"));
push(@files, glob("*/*/*/*/*.m */*/*/*/*.h"));
push(@files, glob("*/*/*/*/*/*.m */*/*/*/*/*.h"));

foreach my $file (@files){
  system ("uncrustify -c uncrustify.cfg --replace --no-backup $file");
}