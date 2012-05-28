#!/usr/bin/perl

my @inventory = `find .`;

foreach my $file (grep(/\.[mh]$/,  @inventory)) {
  chomp $file;
  $file =~ s/^.+BusBrain\///;
  
  if(-e "../TrainBrain/$file"){
    my @diff = `diff BusBrain/$file ../TrainBrain/$file`;
    if(scalar(@diff) > 0){
      system("BusBrain/$file ../TrainBrain/$file");
      system("uncrustify -c uncrustify.cfg --replace --no-backup BusBrain/$file");
    }
  }
  
}