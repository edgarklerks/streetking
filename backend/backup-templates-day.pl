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
#      CREATED:  08/07/2012 16:21:57
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Net::SSH::Perl;

my $host = 'r4.graffity.me';
my $pass = 'Opm8r$';
my $user = 'admin';
my $cmd = "cd /usr/home/admin/streetking/templates; tar -cvzf /usr/home/admin/templates-day.tar.gz *";

my $ssh = Net::SSH::Perl->new($host, port => 27010);
$ssh->login($user, $pass);
my ($out, $err, $exit) = $ssh->cmd($cmd);
