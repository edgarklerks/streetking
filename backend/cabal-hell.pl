#!/usr/bin/perl

# solver = modular 
# constraint = mtl-2.1.2
# constraint = containers-0.5.0.0
use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;

# this program wraps cabal to keep constraints constant during build  

# Constraints we want to keep constant 

my @constraints = qw|
              mtl==2.1.2
              containers==0.4.2.1
              |;
my $safe = 0;
my $dry = 0;
my $modular = 1;

my $mode = "install";

my @sArgs = ();
# Program pipeline  
#   ARGV, constraints  
#    ||
# loadUserParameters -> check for user options 
#    ||
#    Args, safe, dry, constraints  
#    ||
#   \  / 
#  checkMode -> checks if we are in configure, build or install
#    ||
#    || Args, mode, constraint, dry, safe  
#    ||
#   \  /
# cabalWrapper -> run cabal wrapped with constraints in mode with dry and/or safe 
#

sub loadUserParameters {
    for my $arg(@ARGV){
        if($arg eq '-h'){
            help();
            exit;
        } elsif ($arg eq '-s'){
            $safe = 1;
        } elsif($arg eq '-d'){
            $dry = 1;
        } elsif($arg eq '-c'){
            $modular = 0;
        } else {
            push @sArgs, $arg;
        }
    }

}
sub help {
    print "cabal-hell tries to keep constraints constant during build.\n";
    print "USAGE: cabal-hell.pl -h -s -d -c (configure | build | install) <cabal-options> <package>\n";
    print "-h => this help, -s => safe mode, -d => dry run, -c => old dep solver\n";
}
sub cabalWrapper {
    my $cos = shift;

    my $cst =  buildConstraints($cos);
    my $pr = "cabal $mode";
    for my $arg(@sArgs){
        $pr .= " $arg";
    }
    my $cmd = "$pr $cst"; 

    if($modular){
        $cmd .= " --solver=modular";
    } 
    print "Running: $cmd\n";
    if(!$dry) {
        system($cmd);
    }
}

sub checkMode {
    my $arg = $sArgs[0];
    if( $arg ne 'install' 
        && $arg ne 'configure' 
        && $arg ne 'build'
    ){
            warn "defaulting to install mode";
            $mode = 'install';
    } else {
        $mode = $arg;
        shift @sArgs;
    }
}
sub buildConstraints {
    my $cons = shift;
    my $out = '';
    for my $con(@$cons){
        $out .= "--constraint=$con ";
    }
    if($safe){
        return $out . " --avoid-reinstalls";
    } else {
        return $out;
    }
}
loadUserParameters;
checkMode;
print cabalWrapper(\@constraints);
