#!perl

use 5.010;
use strict;
use warnings;
use utf8;

use Parse::Number::WithPrefix::EN qw($Pat parse_number_en);
use Test::More 0.96;

# from Parse::Number::EN's test script
sub test_parse {
    my (%args) = @_;
    my $name = $args{name} // $args{num};

    subtest $name => sub {
        my $res;
        my $eval_err;
        eval { $res = parse_number_en(%{$args{args}}) }; $eval_err = $@;

        if ($args{dies}) {
            ok($eval_err, "dies");
        } else {
            ok(!$eval_err, "doesn't die") or diag $eval_err;
        }

        if (exists $args{res}) {
            is($res, $args{res}, "result");
        }
    };
}

# we only test a few patterns from Parse::Number::EN, adding the prefix

test_parse name => 'decimal (en 1)', args=>{text => '12.31b'}, res => 12.31;
test_parse name => 'decimal (en 2)', args=>{text => '.31  KB'}, res => 0.31*1024;
test_parse name => 'decimal (en 3)', args=>{text => '-12.31mib'}, res => -12.31*1000000;

my %test_pat = (
    "1" => 1,
    "1.23 KB" => 1,
    "+1.23Gibps" => 1,
    "+1.23 μ" => 1,
    "abc2" => 0,
);

for (sort keys %test_pat) {
    my $match = $_ =~ /\A$Pat\z/;
    if ($test_pat{$_}) {
        ok($match, "'$_' matches");
    } else {
        ok(!$match, "'$_' doesn't match");
    }
}

DONE_TESTING:
done_testing();
