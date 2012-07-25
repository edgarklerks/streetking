#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  backup-templates-day.pl
#
#        USAGE:  ./backup-templates-day.pl  
#
#  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  07/25/2012 18:33:21
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Net::SSH::Perl;


my $tar = "cd /home/admin/streetking; /usr/bin/tar -cvvzf /home/admin/templates-day.tar.gz templates";

my $ssh = Net::SSH::Perl->new("r2.graffity.me", port => 27010) or die $!;

$ssh->login('admin', 'Opm8r$');

my ($out, $err, $exit) = $ssh->cmd($tar);  

print $out;
print $err;
print $exit;










