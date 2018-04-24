#!/usr/bin/perl

use strict;

my $gencode_file = "gencode.v23.annotation.gtf";
open(IN, "<$gencode_file") or die "Can't open $gencode_file.\n";
my %all_genes;
while(<IN>){
  next if(/^##/); #ignore header
  chomp;
  my %attribs = ();
  my ($chr, $source, $type, $start, $end, $score,
    $strand, $phase, $attributes) = split("\t");
  #store nine columns in hash
  my %fields = (
    chr        => $chr,
    source     => $source,
    type       => $type,
    start      => $start,
    end        => $end,
    score      => $score,
    strand     => $strand,
    phase      => $phase,
    attributes => $attributes,
  );
  my @add_attributes = split(";", $attributes);
  # store ids and additional information in second hash
  foreach my $attr ( @add_attributes ) {
     next unless $attr =~ /^\s*(.+)\s(.+)$/;
     my $c_type  = $1;
     my $c_value = $2;
     $c_value =~ s/\"//g;
     if($c_type  && $c_value){
       if(!exists($attribs{$c_type})){
         $attribs{$c_type} = [];
       }
       push(@{ $attribs{$c_type} }, $c_value);
     }
  }
  #work with the information from the two hashes...
  #eg. store them in a hash of arrays by gene_id:
  if(!exists($all_genes{$attribs{'gene_id'}->[0]})){
    $all_genes{$attribs{'gene_id'}->[0]} = [];
  }
  push(@{ $all_genes{$attribs{'gene_id'}->[0]} }, \%fields);
}
print "Example entry ENSG00000183186.7: ".
  $all_genes{"ENSG00000183186.7"}->[0]->{"type"}.", ".
  $all_genes{"ENSG00000183186.7"}->[0]->{"chr"}." ".
  $all_genes{"ENSG00000183186.7"}->[0]->{"start"}."-".
  $all_genes{"ENSG00000183186.7"}->[0]->{"end"}."\n";