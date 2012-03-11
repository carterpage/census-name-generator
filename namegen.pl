#!/opt/local/bin/perl -s

use warnings;
use LWP::Simple;

$LAST_NAME_URL = "http://www.census.gov/genealogy/names/dist.all.last";
$FIRST_NAME_FEMALE_URL = "http://www.census.gov/genealogy/names/dist.female.first";
$FIRST_NAME_MALE_URL = "http://www.census.gov/genealogy/names/dist.male.first";

$LAST_NAME_FILE = "lname.dat";
$FEMALE_FIRST_NAME_FILE = "fnamef.dat";
$MALE_FIRST_NAME_FILE = "fnamem.dat";

$FEMALE_PCT = 0.5; # 50%

if ($#ARGV != 0 ) {
    print "Usage: namegen.pl [-d] <# of names>\n";
    exit 1;
}
$num_names = $ARGV[0];

if (!(-f $LAST_NAME_FILE && -f $MALE_FIRST_NAME_FILE && -f $FEMALE_FIRST_NAME_FILE) && !$d) {
    print "First time you run this, use the -d option to download name files from the census.\n";
    exit 1;
}

if ($d) {
    download($LAST_NAME_URL, $LAST_NAME_FILE, "last name census data");
    download($FIRST_NAME_FEMALE_URL, $FEMALE_FIRST_NAME_FILE, "female first name census data");
    download($FIRST_NAME_MALE_URL, $MALE_FIRST_NAME_FILE, "male first name census data");
}

my @lnames = makeNameArray($LAST_NAME_FILE);
my @fnamefs = makeNameArray($FEMALE_FIRST_NAME_FILE);
my @fnamems = makeNameArray($MALE_FIRST_NAME_FILE);

for($i = 0 ; $i < $num_names; ++$i) {
    # Last name
    $lname = $lnames[int(rand($#lnames + 1))];

    # Male or female?
    $fname = (rand(1) > $FEMALE_PCT) ? $fnamems[int(rand($#fnamems + 1))] : $fnamefs[int(rand($#fnamefs + 1))];

    print "$fname $lname\n";
}

sub download{
    $url = $_[0];
    $file = $_[1];
    $desc = $_[2];
    ++$|;
    print "Downloading " . $desc . "... ";
    getstore($url, $file) or die "Unable to download " . $desc . " (" . $url . ")\n";
    print "Done.\n";
}

sub makeNameArray {
    $file = $_[0];
    my @names;
    open(FILE, $file);
    while(<FILE>) {
        chomp;

        # First column (1-15) is the name.  Format it.
        $name = substr $_, 0, 15;
        $name =~ s/\s//g;
        $name = ucfirst(lc($name));

        # Second column (16-20) is the % distribution of this name in the population.
        $count = substr $_, 16, 5;
        $count = int($count * 1000 + 0.5);

        # Add name to the array in a quantity relative to the % distribution.
        for(my $i = 0 ; $i < $count ; ++$i) {
             push(@names, $name);
        }
    }
    return @names;
}

