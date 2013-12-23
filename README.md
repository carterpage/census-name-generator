census-name-generator
---------------------

A statistically realistic artificial name generator.  Syntax looks like this:

    namegen.pl [-d] <# of names>
        -d            Download name data from census (only need to do once)
        # of names    How many names to you need?

The script uses 1990 Census data to ensure a realistic distribution.  ("John Smith" is more likely than 
"Marcellus Wallace", but both are possible.)  Distribution is 50/50 male to female, but can be configured
in the script.

Sample run:

    % ./namegen.pl -d 10
    Downloading last name census data... Done.
    Downloading female first name census data... Done.
    Downloading male first name census data... Done.
    Samuel Bowman
    Sheila Gervais
    Edith Brown
    Jenny Lee
    Harold Mendoza
    Gloria Phipps
    Dawn Andrews
    Freida Goldberg
    Lorraine Hicks
    Elizabeth King

Once the data has been downloaded, it takes about 2-3 seconds to generate a million fake names.

Newer version
-------------

This project has been extended in functionality in another project: [https://github.com/greenify/cli-name-generator]
