#!/usr/bin/perl
use strict;
use warnings;


use LWP::UserAgent;



sub expand {
    my $typing = shift;
    my @ret;
    my $ua = new LWP::UserAgent;
    $ua->agent("AlleleCodeClient/0.1");
    my $url = "http://emmes-dev.nmdp.org:8080/ac/api/decode?imgtHlaRelease=3.15.0&expand=true&typing=$typing";
    my $response = $ua->request(new HTTP::Request("GET", $url));
    my $code = $response->code;
    my $content = $response->content;
    my $headers = $response->headers_as_string;
    if ($code == 200) {  # OK
#print STDERR "Request url:  $url\nStatus $code Content: \n$content\n"; 
        my @allele_list_list = split ("/", $content);
        push @ret, @allele_list_list;

    } elsif ($code == 400) { # Bad Request
# Request syntax was bad, or the typing was bad
# print error and keep original typing.
        print STDERR "Bad request: $content\n\turl:  $url\n";
        push @ret, ("$1");

    } else {
        die "System error: code=$code $content\n";
    }
    return @ret;
}

for my $arg (@ARGV) {
    print "$arg\n";
    my @alleles = expand($arg);
    my $str = join "/", @alleles;
    print "$str\n";
}