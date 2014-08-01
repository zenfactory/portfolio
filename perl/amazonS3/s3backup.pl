#!/usr/bin/perl

#############################################################################
#############################################################################
# This application is intended to either be run manually or as a cron job, 
# given a list of full local filesystem paths and an amazon s3 bucket the 
# perl application will upload all of the enumerated directories in a rsync like 
# mannor so that only the differences will be uploaded instead of uploading your 
# entire dataset at every run. 
#
# This software is licenced under the MIT licence please see the 
# licence agreement included in the repository root for full details
#############################################################################
#############################################################################

# Force strict parsing
#use strict;

# Force warnings
use warnings;

# Import necessary libraries
use S3;
use S3::AWSAuthConnection;
use S3::QueryStringAuthGenerator;
use Archive::Tar;

# Instantiate tar archive handle
my $tar = Archive::Tar->new;

# Define Amazon S3 keys for authentication
my $AWS_ACCESS_KEY_ID = '';
my $AWS_SECRET_ACCESS_KEY = '';

# Instantiate the connection handler
my $conn = S3::AWSAuthConnection->new($AWS_ACCESS_KEY_ID, $AWS_SECRET_ACCESS_KEY);

# Instantiate the URI / Query generator
my $generator = S3::QueryStringAuthGenerator->new($AWS_ACCESS_KEY_ID, $AWS_SECRET_ACCESS_KEY);

# Instantiate working / runtime variables
my $archiveName = "/home/hshirani/repo/portfolio/perl/s3upload.tgz";
my $bucketName = "zenfactory.org";
my $response;
my $content;
my $fileList = "";

# Iterate through the files in each of the enumerated directories
foreach my $file (@ARGV)
{
	$fileList = $fileList . " " . $file;
}

# Create tar gunziped archive of files
system("tar -czvf $archiveName $fileList");

# Add file
$response = $conn->put($bucketName, $archiveName);

# Check response status
if ($response == 200)
{
	print "Archive created and uploaded successfully!";
	exit 0;
}
else
{
	print "Archive upload failed.";
	exit 1;
}
