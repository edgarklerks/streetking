#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  AnalyzeTrack.pl
#
#        USAGE:  ./AnalyzeTrack.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  07/09/2012 18:23:29
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use File::Basename;
use File::Copy;
use Term::ANSIColor;
use subs qw|consoleInfo consoleWarn consoleOk consoleError help|;
use DBI;
use Config::Tiny;

my $ini = Config::Tiny->new;



my $config = "dump/";
my $info =  $ARGV[0] || "";

if($info eq "help"){
    help "help file outputted";

}


my $user = "deosx";
my $host = "db.graffity.me";
my $password = "#*rl&";
my $db = "streetking_dev";

my $dbh = DBI->connect("dbi:Pg:dbname=$db password=$password host=$host user=$user", $user, $password, {AutoCommit => 0});


# Init checks 


unless(-r $info){
    help "cannot open info file";

    consoleError "Not given an info file";
}


$ini = $ini->read($info);
my $dir = $ini->{setup}->{dir};
my $pos = $ini->{setup}->{pos};
my $img = $ini->{setup}->{img}; 
my $dist = $ini->{distance}->{pixeldist};
my $tid = $ini->{track}->{track_id};
my $passes = $ini->{optimizer}->{passes} || 2;
my $minlen = $ini->{optimizer}->{minlen} || 2;

consoleInfo "Check prequisities";
unless(-d $config){
    consoleError "need data dir: $config";
}

if (!($pos =~ /\(\d+,\d+\)/)){
    consoleError "pos not in correct format: (123,321)";
}

if(! -r $img){
    consoleError "cannot open image file";
}

unless($dir =~ /^(U|D|L|R|UL|UR|DL|DR)?$/){
    consoleError "not a valid direction";
}
unless(-x "./ImageGrouping" && -x "./Segmenting" && -x "./Celling" && -x "./Optimize" && -x "./DatabasePump"){
    consoleError "Missing programs: ImageGrouping, Segmenting, Celling. Optimize. DatabasePump. Did you compile them?";
}

unless($dist =~  /^[0-9]+$/){
    consoleError "pixeldist should be an integer";
}
unless($minlen =~ /^[0-9]+$/){
    consoleError "minlen should be initeger";
}
unless ($passes =~ /^[0-9]+$/){
    consoleError "passes should be an integer";
}

my ($filename, $directory, $suffix) = fileparse($img);

my ($tdir) = split /\./, $filename;

consoleInfo "Adding info to ini";
$ini->{optimizer}->{minlen} = $minlen;

$ini->{optimizer}->{passes} = $passes;

my $datadir = $config . $tdir;
consoleInfo "Saving ini to $datadir";

$ini->write("$datadir/track.info");

consoleOk "Everything looks ok";


if(-d $datadir){
    consoleWarn "Directory already exists: $datadir";
}

consoleInfo "Creating datadir $datadir for track";
mkdir($datadir);


consoleInfo "Opening log file";

open my $fh, ">$datadir/racetrack.log";

ImageGrouping();
Segmenting();
Celling();
for(my $i = 0; $i < $passes; $i++){
    Optimize();
}
Database();


consoleOk "Done with track analysis";
consoleInfo "Closing log file";
close $fh;

exit;

sub Optimize {
    print $fh "\n\n=============Database==================\n\n";
    consoleInfo "Running Optimizer"; 
    my $out = `Optimize cells.bin $minlen`;
    print $fh $out;
    consoleOk "Optimizer runned";
}

sub Database {
    print $fh "\n\n=============Database==================\n\n";
    consoleInfo "Running DatabasePump"; 
    my $out = `DatabasePump $dist dump.bin segments.bin cells.bin $tid`;
    print $fh $out;
    consoleOk "Saved to database";


}

sub ImageGrouping {
    print $fh "\n\n=============ImageGrouping==================\n\n";
    consoleInfo "Running ImageGrouping";

    my $out = `ImageGrouping $dir \"$pos\" $img`;
    print $fh $out;

    unless(-e "dump.bin"){
        consoleError "dump is not created. Check log file";
    }

    consoleOk "Saving results to $datadir";

    copy "dump.bin", "$datadir/dump.bin";
    copy "spray.bmp", "$datadir/spray.bmp";
    copy "path.bmp", "$datadir/path.bmp";
    copy "last.bmp", "$datadir/last.bmp";
    copy "gif/animation.gif", "$datadir/animation.gif";
}

sub Segmenting {
    consoleInfo "Running Segmenting";

    my $out = `Segmenting $img +RTS -K128M`;
    print $fh "\n\n=============SEGMENTING==================\n\n";
    print $fh $out;

    unless(-e "segments.bin"){
        consoleError "Segmenting failed. Check log file";
    }

    consoleOk "Saving results to $datadir";



    copy "segments.bin", "$datadir/segments.bin";
    copy "partitions.bmp", "$datadir/partition.bmp";
    copy "raw.bmp", "$datadir/raw.bmp";
    copy "segments.bmp", "$datadir/segments.bmp";

}

sub Celling {
    consoleInfo "Running Celling";


    print $fh "\n\n=============CELLING==================\n\n";

    my $out = `Celling`;

    print $fh $out;

    unless(-e "cells.bin"){
        consoleError "Celling failed. Check log file";
    }

    consoleOk "Save results to $datadir";

    copy "cells.bin", "$datadir/cells.bin";
} 

sub consoleWarn {
    my $text = shift;
    print color "bold yellow";
    print "[w] " . $text . "\n";
    print color "reset";
}

sub consoleInfo {
    my $text = shift;
    print color "bold blue";
    print "[i] " . $text . "\n";
    print color "reset";
}

sub consoleOk {
    my $text = shift;
    print color "bold green";
    print "[+] " . $text . "\n";
    print color "reset";
}

sub consoleError {
    my $text = shift;
    print color "bold red";
    print "[-] " . $text . "\n";
    print color "reset";
    exit;

}


sub help {
    my $error = shift;
    consoleWarn "Usage:";
    consoleWarn "";
    consoleWarn "<program> file.info\n";
    consoleWarn "info should contain:\n";
    consoleWarn "[setup]";
    consoleWarn "dir=(UL|DL|UR|DR|U|L|R|D)";
    consoleWarn "pos=([0-9]+,[0-9]+)";
    consoleWarn "img=[a-z]+.(jpg|jpeg|bmp|png)";
    consoleWarn "[distance]";
    consoleWarn "pixeldist=[0-9]+";
    consoleWarn "[track]";
    consoleWarn "track_id=[0-9]+";
    consoleError $error; 

}
