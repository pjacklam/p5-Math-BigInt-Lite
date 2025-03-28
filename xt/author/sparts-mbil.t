# -*- mode: perl; -*-

use strict;
use warnings;

use Test::More tests => 792;

use Math::BigInt::Lite;

while (<DATA>) {
    s/#.*$//;                   # remove comments
    s/\s+$//;                   # remove trailing whitespace
    next unless length;         # skip empty lines

    my ($x_str, $mant_str, $expo_str) = split /:/;

    note(qq|\n\$x = Math::BigInt::Lite -> new("$x_str");|,
         qq| (\$m, \$e) = \$x -> sparts();\n\n|);

    {
        my $x = Math::BigInt::Lite -> new($x_str);
        my ($mant_got, $expo_got) = $x -> sparts();

        like(ref($mant_got), qr/^Math::BigInt(::Lite)?$/,
            "class of mantissa (got a " . ref($mant_got) . ")");
        like(ref($expo_got), qr/^Math::BigInt(::Lite)?$/,
            "class of exponent (got a " . ref($expo_got) . ")");

        is($mant_got, $mant_str, "value of mantissa");
        is($expo_got, $expo_str, "value of exponent");
        is($x,        $x_str,    "input is unmodified");
    }

    note(qq|\n\$x = Math::BigInt::Lite -> new("$x_str");|,
         qq| \$m = \$x -> sparts();\n\n|);

    {
        my $x = Math::BigInt::Lite -> new($x_str);
        my $mant_got = $x -> sparts();

        like(ref($mant_got), qr/^Math::BigInt(::Lite)?$/,
            "class of mantissa (got a " . ref($mant_got) . ")");

        is($mant_got, $mant_str, "value of mantissa");
        is($x,        $x_str,    "input is unmodified");
    }

}

SKIP: {
    skip "not sure how accuracy and precision works with Math::BigInt::Lite", 8;

    # Verify that the accuracy of the significand and the exponent depend on the
    # accuracy of the invocand, if set, not the class.

    note(qq|\nVerify that accuracy depends on invocand, not class.\n\n|);

    {
        Math::BigInt::Lite -> accuracy(20);
        my $x = Math::BigInt::Lite -> new("3");     # accuracy is 20
        $x -> accuracy(10);                         # reduce accuracy to 10

        my ($mant, $expo) = $x -> sparts();
        cmp_ok($mant, '==', 3, "value of significand");
        cmp_ok($expo, '==', 0, "value of exponent");
        cmp_ok($mant -> accuracy(), '==', 10, "accuracy of significand");
        cmp_ok($expo -> accuracy(), '==', 20, "accuracy of exponent");
    }

    # Verify that the precision of the significand and the exponent depend on the
    # accuracy of the invocand, if set, not the class.

    note(qq|\nVerify that precision depends on invocand, not class.\n\n|);

    {
        Math::BigInt::Lite -> precision(20);
        my $x = Math::BigInt::Lite -> new("3");     # precision is 20
        $x -> precision(10);                        # reduce precision to 10

        my ($mant, $expo) = $x -> sparts();
        cmp_ok($mant, '==', 3, "value of significand");
        cmp_ok($expo, '==', 0, "value of exponent");
        cmp_ok($mant -> precision(), '==', 10, "precision of significand");
        cmp_ok($expo -> precision(), '==', 20, "precision of exponent");
    }
}

__DATA__

NaN:NaN:NaN

inf:inf:inf
-inf:-inf:inf

0:0:0

# positive numbers

1:1:0
10:1:1
100:1:2
1000:1:3
10000:1:4
100000:1:5
1000000:1:6
10000000:1:7
100000000:1:8
1000000000:1:9
10000000000:1:10
100000000000:1:11
1000000000000:1:12

12:12:0
120:12:1
1200:12:2
12000:12:3
120000:12:4
1200000:12:5
12000000:12:6
120000000:12:7
1200000000:12:8
12000000000:12:9
120000000000:12:10
1200000000000:12:11

123:123:0
1230:123:1
12300:123:2
123000:123:3
1230000:123:4
12300000:123:5
123000000:123:6
1230000000:123:7
12300000000:123:8
123000000000:123:9
1230000000000:123:10

1234:1234:0
12340:1234:1
123400:1234:2
1234000:1234:3
12340000:1234:4
123400000:1234:5
1234000000:1234:6
12340000000:1234:7
123400000000:1234:8
1234000000000:1234:9

3141592:3141592:0

# negativ: numbers

-1:-1:0
-10:-1:1
-100:-1:2
-1000:-1:3
-10000:-1:4
-100000:-1:5
-1000000:-1:6
-10000000:-1:7
-100000000:-1:8
-1000000000:-1:9
-10000000000:-1:10
-100000000000:-1:11
-1000000000000:-1:12

-12:-12:0
-120:-12:1
-1200:-12:2
-12000:-12:3
-120000:-12:4
-1200000:-12:5
-12000000:-12:6
-120000000:-12:7
-1200000000:-12:8
-12000000000:-12:9
-120000000000:-12:10
-1200000000000:-12:11

-123:-123:0
-1230:-123:1
-12300:-123:2
-123000:-123:3
-1230000:-123:4
-12300000:-123:5
-123000000:-123:6
-1230000000:-123:7
-12300000000:-123:8
-123000000000:-123:9
-1230000000000:-123:10

-1234:-1234:0
-12340:-1234:1
-123400:-1234:2
-1234000:-1234:3
-12340000:-1234:4
-123400000:-1234:5
-1234000000:-1234:6
-12340000000:-1234:7
-123400000000:-1234:8
-1234000000000:-1234:9

-3141592:-3141592:0
