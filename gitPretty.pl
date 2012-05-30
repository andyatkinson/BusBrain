#!/usr/bin/perl

foreach my $line (`git status`){
  chomp($line);
  next unless($line =~ "modified:");
  next unless($line =~ m/\.[hm]$/);
  
  $line =~ s/^#.+?BusBrain/BusBrain/;
  system("uncrustify -c uncrustify.cfg --replace --no-backup $line");
}