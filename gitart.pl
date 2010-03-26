#!/usr/bin/perl

$hash = <STDIN>;

print hex2bin($hash)."\n";









sub hex2bin
{
        my ($hex_string) = @_;
        my @hex_characters = split(//, $hex_string);
        my $bin_string ="";
        foreach $char ( @hex_characters )
        {
                my $int = oct("0x".$char);
                my $str = unpack("B32", pack("N", $int));
                $str =~ /(....)$/;   # otherwise you'll get leading zeros
                $bin_string.=($1." ");
        }
        return $bin_string;
}

