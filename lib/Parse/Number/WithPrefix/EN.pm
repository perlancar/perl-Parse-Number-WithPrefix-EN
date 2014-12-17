package Parse::Number::WithPrefix::EN;

# DATE
# VERSION

# - can recognize metric prefix (base-10) vs binary prefix (base-2). KiB etc or
#   KB can be made to mean metric prefix.

# - option to be case-insensitive. reject when ambiguous (e.g. m=milli vs
#   M=mega).

# - option to not use lower than 1 scales, e.g. for file sizes, it's okay to use
#   1m as well as 1M, because it won't be ambiguous, both means mega.

# - option to detect short (k, m) and full (kilo, mega)

# - option to parse other prefix? w (week), h (hour)...? are there already
# datetime format module to do this?

use 5.010;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT_OK = qw($Pat parse_number_en);

our %SPEC;

our $Pat = qr/(?:
                  [+-]?
                  (?:
                      (?:\d{1,3}(?:[,]\d{3})+ | \d+) (?:[.]\d*)? | # english
                      [.]\d+
                  )
                  (?:[Ee][+-]?\d+)?
              )/x;

$SPEC{parse_number_en} = {
    v => 1.1,
    summary => 'Parse number from English text',
    args    => {
        text => {
            summary => 'The input text that contains number',
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    result_naked => 1,
};
sub parse_number_en {
    my %args = @_;
    my $text = $args{text};

    return undef unless $text =~ s/^\s*($Pat)//s;
    my $n = $1;
    $n =~ s/,//g;
    $n+0;
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use Parse::Number::EN qw(parse_number_en $Pat);

 my @a = map {parse_number_id(text=>$_)}
     ("12,345.67", "-1.2e3", "x123", "1.23", "1,23");
 # @a = (12345.67, -1200, undef, 1.23, 1)

 my @b = map {/^$Pat$/ ? 1:0}
     ("12,345.67", "-1.2e3", "x123", "1,23");
 # @b = (1, 1, 0, 0)


=head1 DESCRIPTION

This module provides $Pat and parse_number_en().


=head1 VARIABLES

None are exported by default, but they are exportable.

=head2 $Pat (REGEX)

A regex for quickly matching/extracting number from text. It's not 100% perfect
(the extracted number might not be valid), but it's simple and fast.


=head1 FAQ

=head2 How does this module differ from other number-parsing modules?

This module uses a single regex and provides the regex for you to use. Other
modules might be more accurate and/or faster. But this module is pretty fast.


=head1 SEE ALSO

L<Lingua::EN::Words2Nums>

Other Parse::Number::* modules.

=cut
