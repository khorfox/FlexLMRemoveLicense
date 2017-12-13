#!/usr/bin/perl -w
sub normalizza {
  my ($mese,$giorno,$ora,$minuti ) = @_;
  $dataFormattata=sprintf('%02d',$mese);
  $dataFormattata = $dataFormattata . sprintf('%02d',$giorno);
  $dataFormattata = $dataFormattata . sprintf('%02d',$ora);
  $dataFormattata = $dataFormattata . sprintf('%02d',$minuti);
  return $dataFormattata;
}
sub incrementa {
  use integer;
  my ($datadaincrementare,$incremento) = @_;
  $aa=substr($datadaincrementare,0,4);
  $mm=substr($datadaincrementare,4,2);
  $dd=substr($datadaincrementare,6,2);
  $hh=substr($datadaincrementare,8,2);
  $mn=substr($datadaincrementare,10,2);
  $hh = $hh + $incremento;
  $dd = $dd + $hh/24;
  $dataincrementata = $aa . $mm . $dd . sprintf('%02d',$hh%24) . $mn;
  return $dataincrementata; 
}
$matchporta="License server status: ";
$matchriga="JavaUser*start";
$nomeFile  = $ARGV[0];
$intervallo  = $ARGV[1];
$minuti = (localtime)[1]; 
$ora = (localtime)[2]; 
$giorno = (localtime)[3]; 
$mese = (localtime)[4] + 1; 
$anno = 1900 + (localtime)[5]; 
$dataodierna= $anno . normalizza($mese,$giorno,$ora,$minuti);
printf "dataodierna $dataodierna \n";
# comando da scrivere lmutil lmremove -h XAP-01-004 unicas2 27000@unicas2 203
if (open STAT, '<', $nomeFile) {
open COMANDI, ">comandi.sh"  ;
 while (<STAT>) {
	if( $_  =~ /^License server status:/) {
		$porta = substr($_,length($matchporta)) ;
		@s = split /@/, $porta;
		$server = $s[1];
		$server =~ s/^\s+|\s+$//gm;
		$porta =~ s/^\s+|\s+$//gm;
	}
	if( $_  =~ /^Users of /) {
		$licenza = substr($_,length("Users of "),length("XAP-01-004")) ;
	}
	if( $_  =~ /JavaUser/) {
		$riga = $';
		@el = split /\s/, $riga;
		$display = $el[4];
		chop($display);
		chop($display);
		if($riga =~ /start/) {
			$data = $';
			$data =~ s/^\s+|\s+$//gm;
			@d =	split /\s/, $data;
			@mmdd = split /\//, $d[1];
			$mesec = $mmdd[0];
			$giornoc = $mmdd[1];
			@hhmm = split /:/, $d[2];
			$orac=$hhmm[0];
			$minc=$hhmm[1];
			$datacorrente= $anno . normalizza($mesec,$giornoc,$orac,$minc);
		}
			if(incrementa($datacorrente,$intervallo) < $dataodierna) {
				$a = sprintf "lmremove -h %s %s %s %s \n", $licenza, $server, $porta ,$display;
				print COMANDI $a;
			}
	}
 }
 close STAT;
 close COMANDI;
} else {
 die "Impossibile aprire il file: errore $!";
} 
exit(0);
