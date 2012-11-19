#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  backup-templates.pl
#
#        USAGE:  ./backup-templates.pl  
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
#      CREATED:  08/07/2012 15:38:21
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Net::SSH::Perl;
use Data::Dumper;

my $host = 'r4.graffity.me';
my $pass = 'Opm8r$';
my $user = 'admin';
my $cmd = "cd /usr/home/admin/streetking/templates; tar -cvzf /usr/home/admin/templates.tar.gz *";

my $ssh = Net::SSH::Perl->new($host, port => 27010);
$ssh->login($user, $pass);
my ($out, $err, $exit) = $ssh->cmd($cmd);
my $cd = ("cd /usr/home/admin/streetking/templates;");
$ssh->cmd("$cd hg add *.tpl;");
$ssh->cmd("$cd hg add */*.tpl;");
$ssh->cmd("$cd hg add */*/*.tpl;");
$ssh->cmd("$cd hg add */*/*/*.tpl;");
my @t = $ssh->cmd("$cd hg commit -m 'templates autocommit'");
print Dumper(\@t);

