#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Monitor.pl
#
#        USAGE:  ./Monitor.pl  
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
#      CREATED:  01/31/2013 10:15:39 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


use ZMQ::LibZMQ3;
use ZMQ::Constants qw(ZMQ_SUB ZMQ_SUBSCRIBE);
use Tk;
use Tk::Table;
use Tk::Text;
use IO::Pipe;
use threads;
use threads::shared;
use Data::Dumper;

my $list;
my $window;
my $text;

my %data : shared = ();
my $connect = "tcp://192.168.4.9:9875";
my @components = (
        'heartbeat',
        'proxy_resources',
        'node_snaplet',
        "role_snaplet",
        "p2p",
        "memstate"
);

sub row {
    my ($c1,$c2,$c3) = @_;

    return sprintf("%20s\t%20s\t%20s\n", $c1, $c2, $c3); 
}
sub header {
    my ($c1,$c2,$c3) = @_;
     
    return sprintf("%20s\t%20s\t%20s\n", $c1, $c2, $c3); 
}


sub createWidgets {
    $window = new MainWindow;
    $text = $window->Text(
        -width => 100, 
        -height => 50)->pack();
    # Callback which updates from shit 
    Tk::After->new($window, 500, 'repeat', sub {
            lock(%data);
            my $content = header(qw|Component Name Cycles| );
            for my $cm(sort (keys %data)){
                    my ($component,$name) = split /,/, $cm;
                    my $cycles = $data{$cm};

                    $content .= row($component, $name, $cycles);
            }
            $text->Contents($content);

        });
    my $button = $window->Button(
            -text => "Quit",
            -command => sub { exit(); })->pack();
}

my $thr = async {
    createWidgets();
    MainLoop;
};
my $thrZMQ = async {
    # create zmq binding 
    my $ctx = zmq_ctx_new(1);
    my $sock = zmq_socket($ctx, ZMQ_SUB); 
    zmq_connect($sock, $connect);
    for my $comp(@components){
        zmq_setsockopt($sock, ZMQ_SUBSCRIBE, $comp);
    }
    while(1){
     {
        my $string = zmq_recvmsg($sock);
        my ($component, $name) = split / /, zmq_msg_data($string);
        lock %data;
        if(!$data{"$component,$name"}){
            $data{"$component,$name"} = 0;
        }
        $data{"$component,$name"} += 1;
    }
        sleep 1;
    }
};

$thr->join();
$thrZMQ->join();




