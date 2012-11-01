#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  test.pl
#
#        USAGE:  ./test.pl  
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
#      CREATED:  11/01/2012 14:40:00
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use WWW::Mechanize; 
use JSON::XS;
use DDS;

# Config 
my $server = "http://r3.graffity.me:9003";
my $email = "edgar.klerks\@gmail.com";
my $password = "wetwetwet";

my $s = WWW::Mechanize->new ();


my $dev = "";
my $usr = "";

setup(); 
webBench();

sub webBench {
   my $res = `webbench -c 10 --get --http11 '$server/User/me?user_token=$usr'`; 
   print $res;
}

sub splits {
    my $n = shift;
    my $code = shift;
    if(fork()){
        return; 
    }

    for(my $i = 0; $i < $n; $i++){
        if(fork()){
            last; 
        }
    }
    $code->();

}

sub webBenchBody {
    my $resp = serverGet("User/me");
    if($resp->{error}){
        die "Server died" . $resp->{error};
    }
}

sub setup {
    my $resp = serverPut("Application/identify", 
                { token => "demodemodemo" },
                "token=demodemodemo"
                );
     
    testErr($resp);
    
     $dev = $resp->{result};
     $resp = serverPut("User/login",
            {email => $email, password => $password}
        );
     
    testErr($resp);

     $usr = $resp->{result};
     
    }
sub testErr {
    my $resp = shift;
    if($resp->{error}){
        print "Fatal error\n";
        die $resp->{error};
    }
}
sub serverGet {
    my $res = shift;
    my $arg= shift;

    $res .= "?" . ($arg ? $arg : "");

    if($usr){
        if($arg){
            $res .= "&";
        }
        $res .="user_token=$usr";
        if($dev){
            $res .= "&";
        }
    }

    if($dev){
        $res .= "application_token=$dev";
    }

    my @pars = ("$server/$res");
    my $rsp = $s->get(@pars);
    return (decode_json ($rsp->decoded_content));
}


sub serverPut {
    my $res = shift;
    my $obj = shift;
    my $arg= shift;

    $res .= "?" . ($arg ? $arg : "");

    if($usr){
        if($arg){
            $res .= "&";
        }
        $res .="user_token=$usr";
        if($dev){
            $res .= "&";
        }
    }

    if($dev){
        $res .= "application_token=$dev";
    }

    my @pars = ("$server/$res",
                content => encode_json $obj
            );
    my $rsp = $s->put(@pars);
    return (decode_json ($rsp->decoded_content));
}

sub serverPost {
    my $res = shift;
    my $obj = shift;
    my $arg= shift;

    $res .= "?" . $arg;

    if($usr){
        if($arg){
            $res .= "&";
        }
        $res .="user_token=$usr";
        if($dev){
            $res .= "&";
        }
    }

    if($dev){
        $res .= "application_token=$dev";
    }

    my @pars = ("$server/$res",
                content => encode_json $obj
            );
    my $rsp = $s->post(@pars);
    return $rsp->decoded_content;
}






