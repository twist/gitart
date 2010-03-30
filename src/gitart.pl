#!/usr/bin/perl

#	gitart.pl
#
#	creates an ascii art image from a supplied hexadecimal hash.
#
#
#
#
#
#	Copyright (C) 2010 Benjamin Bellee 
#
#	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License 
#	as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
#
#	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
#	without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#	See the GNU General Public License for more details.




main();


sub main()
{

	my $arglen = @ARGV; 
	if ($arglen == 1)
	{
		$hash = $ARGV[0];
	}
	else
	{
		$hash = <STDIN>;
	}

	$bin_string =  hex2bin_with_spaces($hash);
	@steps = create_steps($bin_string) ;
	

	my $x = 17;
	my $y = 9;
	#i map the two dimensions onto an one-dimensional array, this is the basic math form moving on it
	my $offset_up = $x;
	my $offset_down = ($x * -1);
	my $offset_left = -1;
	my $offset_right = 1;
	my $name = "gitart";


	@field = create_array_of_lenght($x*$y);
	my $position = (int($x/2) + ($x*int($y/2))) ;

	foreach $step (@steps)
	{
		my $oldpos = $position;
		if ($step eq "00") #up and left
		{
			$position += $offset_up;
			$position += $offset_left;
		}
		elsif ($step eq "01") #up and right
		{
			$position += $offset_up;
			$position += $offset_right;
		}
		elsif ($step eq "10") #down and left
		{
			$position += $offset_down;
			$position += $offset_left;
		}
		else #down and right
		{
			$position += $offset_down;
			$position += $offset_right;
		}
		if ($position > ( $x * $y))
		{
			$position = $position-$oldpos; #"ring buffer"
		}
		elsif ($position < 0)
		{
		    $position = ($x * $y) - ($oldpos - $position);
		}
		$field[$position] += 1;
		
	}

	print_field($name, $x, $y, @field);
}







sub print_field
{
        my ($name, $width, $length, @field) = @_;
       
	print_name($name, $width);		
        for($j = 0; $j < $length; $j++) #j=y
        {
		print "|";
                for($i = 0; $i < $width; $i++) # i=x
                {
                        print map_value($field[$i + ($width *($j)  )]);
                }
		print "|";
                print "\n"
        }
	print_name("", $width);
}


sub map_value
{
        my ($value) = @_;
        %map = ( "0", " ", "1",".","2","o","3","+","4","=","5","*","6","B","7","O","8","X","9","@","10","%","11","&","12","#","13","/","14","^","15","S", "16", "E" );
        return $map{$value};
}

sub print_name
{
	my ($name, $x) = @_;
	$needed_characters = ($x) - length($name);
	print "+";
	for ($i = 0; $i <= $needed_characters; $i++)
	{
		if($i == (int($needed_characters/2)))
		{
			print $name;
		}
		else
		{
			print "-";
		}
	}
	print "+\n";
}
		


sub hex2bin_with_spaces
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

sub create_steps
{
      my ($string) = @_; 

      # example of how we want to traverse the binary string
      # each step consists of two bits
      # 1011 1111 0010 1101 1001 1111 <- the string, divided by spaces
      #  2 1  4 3 ........            <- the  order

      my @halfbytes = split(/ /, $string);
      my  @steps;
      foreach $halfbyte (@halfbytes)
      {
              $halfbyte =~ /(..)(..)/;
              push (@steps, ($2, $1));
      }
      return @steps;
}

sub create_array_of_lenght
{
        my ($length) = @_;
        @array;
        for($i = 0; $i < $length; $i++)
        {
                my $int = 0;
                push(@array, $int);
        }
        return @array
        
}

