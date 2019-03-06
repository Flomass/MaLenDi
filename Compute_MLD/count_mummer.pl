#! /usr/bin/perl
#

use strict;
use Getopt::Long;

my $ortho=0;
my $out="MLD/mld_simulated_sequences.txt";
my $ortho_para=1;

GetOptions("ortho_para=i" => \$ortho_para,
			"out=s" => \$out);

#### Set diag to "1" in case you want to compute self alignment

my @count;
my @count_ortho;
my @count_para;
for (my $i=0;$i<20000;$i++) {
	$count[$i]=0;
	$count_ortho[$i]=0;
	$count_para[$i]=0;
}



while (<STDIN>) {
	chomp $_;
	if ($_!~/^>/) {
		$_ =~ s/^\s+//;
		$_ =~ s/\s+/\t/g;
		my @res=split(/\t/,$_);
		if ($res[1] == $res[0]) {
			$count_ortho[$res[2]]++;
		}
		else {
			$count_para[$res[2]]++;
		}
		$count[$res[2]]++;
	}
}


my $max=20000;
while($count[$max]==0) {
	$max--;
	if ($max<0) {
		die "infinite loop\n";
	}
}

$max++;

open(OUT,">$out") or die "can't open $out\n\n";
for (my $i=1; $i<$max; $i++) {
	print OUT "$i\t$count[$i]\n";
}

if ($ortho_para){
	open(OUT2,">$out\_orthologs") or die "can't open $out\_orthologs\n\n";
	open(OUT3,">$out\_paralogs") or die "can't open $out\_paralogs\n\n";
	for (my $i=1; $i<$max; $i++) {
		print OUT2 "$i\t$count_ortho[$i]\n";
		print OUT3 "$i\t$count_para[$i]\n";
	}
}

