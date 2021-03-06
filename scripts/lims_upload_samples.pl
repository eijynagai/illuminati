#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Bin;
use lib $FindBin::Bin . "/modules";

use JSON;
use Zan::RPC;
use Data::Dumper;

# Read configuration data from this file
require("api_config.pl");

if ($ARGV[0] eq "") {
	print "Usage:\n";
	print "\tupload_samples.pl [upload_file.json]\n";
	print "\n";
	exit(1);
}

my $json_filename = $ARGV[0];

# This should be the base install directory of LIMS
my $modulesURL = $ZAN_API_URL;

# This is generated by logging in to the dashboard, going to Tools -> Edit Your User Settings, Remote API Tokens
my $authToken = $ZAN_API_AUTH_TOKEN;

open(FILE, $json_filename) or die "can't read file\n";
my $document = <FILE>;
close (FILE);

my $samples = decode_json($document);

for (my $i = 0; $i < scalar(@$samples); $i++)
{

  $sample = @$samples[$i];
  print Dumper([$sample]);

  $rpc = new Zan::RPC($modulesURL, $authToken);

  print "Setting sample data...\n";
  #print $sample;
# This calls the remote method MolBio.ngs_remoteAPI.setSummaryData
  eval {$rpc->call("MolBio.ngs_remoteAPI.setDataForSamples", [$sample])};
  if($@)
  {
    print("!!!ERROR IN UPLOAD!!!\n");
    print($@);
  }
}


