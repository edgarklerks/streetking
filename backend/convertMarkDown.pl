#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  convertMarkDown.pl
#
#        USAGE:  ./convertMarkDown.pl  
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
#      CREATED:  07/06/2013 12:06:05 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use Cwd qw|chdir getcwd|;
use Data::Dumper;
my $cwd = getcwd();

my @output = qw|game-new proxy-new images admin|;
for my $out(@output){
    chdir("$out/doc");
    my @files = <*.html>;
    convert(\@files);
    chdir($cwd);

}

sub convert {
    my $files = shift;
    for my $file(@$files){
        my ($name, $ext) = split(/\./, $file);
        system('pandoc -f html -t markdown_github -s ' . $file . ' -o ' . "$name.md");

    }
}
