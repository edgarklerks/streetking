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
use subs qw|consoleInfo consoleWarning consoleOk consoleError|;
use DBI;
use Config::Tiny;

my $ini = Config::Tiny->new;



my $config = "dump/";
my $info =  $ARGV[0];


my $user = "deosx";
my $host = "db.graffity.me";
my $password = "#*rl&";
my $db = "streetking_dev";

my $dbh = DBI->connect("dbi:Pg:dbname=$db password=$password host=$host user=$user", $user, $password, {AutoCommit => 0});


# Init checks 


unless(-r $info){
    consoleError "Not given an info file";
}


$ini = $ini->read($info);
my $dir = $ini->{setup}->{dir};
my $pos = $ini->{setup}->{pos};
my $img = $ini->{setup}->{img}; 
my $dist = $ini->{distance}->{pixeldist};
my $tid = $ini->{track}->{track_id};


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
unless(-x "./ImageGrouping" && -x "./Segmenting" && -x "./Celling"){
    consoleError "Missing programs: ImageGrouping, Segmenting, Celling. Did you compile them?";
}

unless($dist =~  /^[0-9]+$/){
    consoleError "pixeldist should be an integer";
}

my ($filename, $directory, $suffix) = fileparse($img);

my ($tdir) = split /\./, $filename;

consoleInfo "Adding info to ini";


consoleOk "Everything looks ok";

my $datadir = $config . $tdir;

if(-d $datadir){
    consoleWarning "Directory already exists: $datadir";
}

consoleInfo "Creating datadir $datadir for track";
mkdir($datadir);

copy $info,"$datadir/track.info";

consoleInfo "Opening log file";

open my $fh, ">$datadir/racetrack.log";

ImageGrouping();
Segmenting();
Celling();
Database();


consoleOk "Done with track analysis";
consoleInfo "Closing log file";
close $fh;

exit;


sub Database {
    print $fh "\n\n=============Database==================\n\n";
    consoleInfo "Running DatabasePump"; 
    my $out = `./DatabasePump $dist dump.bin segments.bin cells.bin $tid`;
    print $fh $out;
    consoleOk "Saved to database";


}

sub ImageGrouping {
    print $fh "\n\n=============ImageGrouping==================\n\n";
    consoleInfo "Running ImageGrouping";

    my $out = `./ImageGrouping $dir \"$pos\" $img`;
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

    my $out = `./Segmenting $img +RTS -K128M`;
    print $fh "\n\n=============SEGMENTING==================\n\n";
    print $fh $out;

    unless(-e "segments.bin"){
        consoleError "Segmenting failed. Check log file";
    }

    consoleOk "Saving results to $datadir";



    copy "segments.bin", "$datadir/segments.bin";
    copy "partitions.bmp", "$datadir/partition.bmp";
    copy "segments.bmp", "$datadir/segments.bmp";

}

sub Celling {
    consoleInfo "Running Celling";


    print $fh "\n\n=============CELLING==================\n\n";

    my $out = `./Celling`;

    print $fh $out;

    unless(-e "cells.bin"){
        consoleError "Celling failed. Check log file";
    }


    copy "cells.bin", "$datadir/cells.bin";
} 

sub consoleWarning {
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




