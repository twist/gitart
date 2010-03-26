#!/usr/bin/perl

$hash = <STDIN>;

$bin_string =  hex2bin_with_spaces($hash);

@steps = create_steps($bin_string) ;
my $x = 17;
my $y = 9;
my $offset_up = $x;
my $offset_down = ($x * -1);
my $offset_left = -1;
my $offset_right = 1;

@field = create_array_of_lenght($x*$y);



my $position = (int($x/2) + ($x*int($y/2))) ;
foreach $step (@steps)
{
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
        $field[$position] += 1;
        print_field($x, $y, @field);
        print "\n\n\n\n";
        
}

print_field($x, $y, @field);







sub print_field
{
        my ($width, $length, @field) = @_;
        

        for($j = 0; $j < $length; $j++) #j=y
        {
                for($i = 0; $i < $width; $i++) # i=x
                {
                        print $field[$i + ($width *($j)  )];
                }
                print "\n"
        }
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

