#!/usr/bin/perl

# Import libs
use URI::Escape;
use MIME::Base64;

# Define encoding mechanisms
my @encTypes = ("base64", "uri");

# Define decoding functions
my %decFunctions = (base64 => \&decode_base64, uri => \&uri_unescape);

# Define the string encoding type
my $encodedAs = @ARGV[0];

# Define string to decode
my $string = @ARGV[1];

# Iteratere over known encoding mechanisms to make sure the one passed is valid / can behandled
foreach my $encKey (%decFunctions)
{
	if ($encodedAs == $encKey)
	{
		# Decode the string based on the defined hash table 
		my $output = $decFunctions{$encodedAs}->($string);

		# Print the decoded string
		print "\n\n" . $output . "\n\n";

		# Exit gracefully
		exit;
	}	
}

# If we got here then the encoding type was not able to be handled, exit with error
exit "Sorry, unknown encoding type";
