#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

my $tests;

BEGIN
   {
   $tests = 1;
   plan tests => $tests;
   chdir 't' if -d 't';
   use lib '../lib';
   };

SKIP:
  {
  skip( 'Test::Pod not installed on this system', $tests )
    unless do
      {
      eval "use Test::Pod;";
      $@ ? 0 : 1;
      };
  pod_file_ok( '../lib/Math/BigInt/Lite.pm' );
  }
