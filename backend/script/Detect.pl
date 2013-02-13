#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Detect.pl
#
#        USAGE:  ./Detect.pl  
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
#      CREATED:  12/04/2012 14:23:31
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use Net::Pcap;
use Data::Dumper;
use Net::Frame::Layer::ARP qw(:consts);
use Net::Frame::Layer::ETH qw(:consts);
use Net::Frame::Layer::IPv4 qw(:consts);
use Net::Frame::Layer::TCP qw(:consts);
use Net::Frame::Layer::UDP qw(:consts);

use Net::Frame::Simple;
my $hardware = {};
my $ip = {};
my $tcp = {};
my $udp = {};

if(!$ARGV[0]){
    die "Usage: Detect.pl <network-device>"; 
}

my $err = '';
my $dev = $ARGV[0];

my $pcap = pcap_open_live($dev, 1024,1,10,\$err) 
    or die "can't open $dev: $err";

pcap_loop($pcap, 1000, \&process_packet, 0);



pcap_close($pcap);

print "hardware addresses found:\n";

print Dumper($hardware);

print "network addresses found:\n";
print Dumper($ip);

print "tcp connections found:\n";
print Dumper($tcp);

print "udp datagrams found:\n";
print Dumper($udp);

sub process_packet {
    my ($user_data, $header, $packet) = @_;
    my $eth = Net::Frame::Simple->new(
        raw => $packet,
        firstLayer => 'ETH' 
    );
    my $dip;
    my $sip;
    foreach my $layer($eth->layers){
        if($layer->layer eq 'ETH'){
            $hardware->{$layer->dst} = 1;
            $hardware->{$layer->src} = 1;
        } elsif ($layer->layer eq 'ARP'){
            $hardware->{$layer->dst} = 1;
            $hardware->{$layer->src} = 1;
            $ip->{$layer->dstIp} = 1;
            $ip->{$layer->srcIp} = 1;
        } elsif ($layer->layer eq 'IPv4'){
            $ip->{$layer->src} = 1;
            $ip->{$layer->dst} = 1;
            $dip = $layer->dst;
            $sip = $layer->src;

        } elsif($layer->layer eq 'IPv6'){
            $ip->{$layer->src} = 1;
            $ip->{$layer->dst} = 1;
            $dip = $layer->dst;
            $sip = $layer->src;
        } elsif($layer->layer eq 'IP'){
            $ip->{$layer->src} = 1;
            $ip->{$layer->dst} = 1;
            $dip = $layer->dst;
            $sip = $layer->src;
        }
        elsif($layer->layer eq 'TCP'){
            my $ps = $sip . ":" . $layer->src;
            my $pd = $dip . ":" . $layer->dst;
            $tcp->{"Dst: " . $ps} = 1;
            $tcp->{"Src: " . $pd} = 1;
        } elsif($layer->layer eq 'UDP'){
            my $ps = $sip . ":" . $layer->src;
            my $pd = $dip . ":" . $layer->dst;
            $udp->{"Dst: " . $ps} = 1;
            $udp->{"Src: " . $pd} = 1;
        }


    }
}
