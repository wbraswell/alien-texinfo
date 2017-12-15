use strict;
use warnings;
our $VERSION = 0.002_000;

use Test2::V0;
use Test::Alien;
use Alien::Texinfo;
use English qw(-no_match_vars);  # for $OSNAME
use Data::Dumper;  # DEBUG

plan(6);

# load alien
alien_ok('Alien::Texinfo', 'Alien::Texinfo loads successfully and conforms to Alien::Base specifications');

# test version flag
my $run_object = run_ok([ 'makeinfo', '--version' ], 'Command `makeinfo --version` runs');
#print {*STDERR} "\n", q{<<< DEBUG >>> in t/04_binary_version_test2.t, have $run_object->out() = }, Dumper($run_object->out()), "\n";
#print {*STDERR} "\n", q{<<< DEBUG >>> in t/04_binary_version_test2.t, have $run_object->err() = }, Dumper($run_object->err()), "\n";
$run_object->success('Command `makeinfo --version` runs successfully');

# EXAMPLE: texi2any (GNU texinfo) 6.1
# EXAMPLE: makeinfo (GNU texinfo) 5.2
# DEV NOTE: can't use out_like() on the next line because it does not properly capture to $1, as used in the following split
ok($run_object->out() =~ m/^\w+\ \(GNU\ texinfo\)\ ([0-9\.]+)$/xms, 'Command `makeinfo --version` runs with valid output');

# test actual version numbers
my $version_split = [split /[.]/, $1];
#print {*STDERR} "\n", q{<<< DEBUG >>> in t/04_binary_version_test2.t, have $version_split = }, Dumper($version_split), "\n";
my $version_split_0 = $version_split->[0] + 0;
#print {*STDERR} "\n", q{<<< DEBUG >>> in t/04_binary_version_test2.t, have $version_split_0 = '}, $version_split_0, q{'}, "\n";
cmp_ok($version_split_0, '>=', 6, 'Command `makeinfo --version` returns major version 6 or newer');
if ($version_split_0 == 6) {
    my $version_split_1 = $version_split->[1] + 0;
    cmp_ok($version_split_1, '>=', 1, 'Command `makeinfo --version` returns minor version 1 or newer');
}

done_testing;
