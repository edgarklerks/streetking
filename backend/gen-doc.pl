#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  gen-doc.pl
#
#        USAGE:  ./gen-doc.pl  
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
#      CREATED:  07/05/2013 09:07:37 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use Cwd qw|chdir getcwd|;

my $tool = '/usr/bin/haddock'; 
my $options = ' --html --pretty-html --optghc="-hide-package=MonadCatchIO-mtl"';
my @output = qw|game-new proxy-new images admin|;
my $entry = 'Site.hs';
my $cwd = getcwd();

for my $out(@output){
    print "Documenting $out\n";
    chdir($out . '/src');
    system("$tool $options --odir=../doc $entry");
    chdir($cwd);

}


