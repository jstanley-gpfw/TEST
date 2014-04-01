#!/usr/bin/perl

##############################################################################################
#                                                                                            #
# Promote the selected build.  This script will copy the indicated zip file to SharePoint.   #
#                                                                                            #
#                                                                                            #
# Jack Stanley                                                                               #
#                                                                                            #
##############################################################################################

use File::Basename;

print "Content-Type: text/html\n\n";

print "<HTML>";

#...Get the date and remove the leading zero from the month
$mytime =`date "+%m/%d/%y"`;
$mytime =~ s/^0//;
chomp($mytime);

#...Determine the input method.
if ( $ENV{'REQUEST_METHOD'} eq "GET" && $ENV{'QUERY_STRING'} ne '' ) {
     $form = $ENV{'QUERY_STRING'};
     }
elsif ( $ENV{'REQUEST_METHOD'} eq "POST" ) {
         read(STDIN, $form, $ENV{'CONTENT_LENGTH'});
} else {
         print "\n The input string is empty, exiting...\n";
         exit 0;
}

#...The $form variable contains the input data.
#...Create the associative array of the input data

#print "\n\nThe raw form is: $form\n\n";

foreach $pair (split('&', $form)) {
   if ($pair =~ /(.*)=(.*)/) {      # If we find key=value
     ($key, $value) = ($1, $2);     # Get key, value
     $value =~ s/\+/ /g;            # Substitute spaces for + signs
     $value =~ s/%(..)/pack('c',hex($1))/eg;
     $inputs{$key} = $value;        # Create hash

#    push (@values, $value);        # Create an array of values.
     }
}

#...Copy each file to SharePoint
#foreach (@values) {
# print "values: $_\n";

#Comment #1
#Comment #2
#Comment #3
#Comment #4
#Comment #5

foreach $item (keys(%inputs)) {
#  print "$item is $inputs{$item}<p>";
  my $filename = basename( $inputs{$item} );
##  my $filename = basename( $_ );

  #...If the filename has brackets, they need to be escaped.
  $inputs{$item} =~ s/\[/\\[/;
  $inputs{$item} =~ s/\]/\\]/;
##  $_ =~ s/\[/\\[/;
##  $_ =~ s/\]/\\]/;

# print "curl --user EXCH029/svc-jenkins:PWD --ntlm --upload-file $inputs{$item} 'https://gopro.hostpilot.com/engineering/quality/SQA/FW%20Builds/$item/$filename'";
  print "<p>Upload file $filename to https://gopro.hostpilot.com/engineering/quality/SQA/FW%20Builds/$item<p>";

# print "/bin/sed -i '\\#$_# s#td\>.*/td\># td\>center\>$mytime</td>#' /var/www/builds/i.html<p>";
  system ("/bin/sed -i '\\#$inputs{$item}# s#<td>.*</td># <td><center>'$mytime'</td>#' /var/www/builds/i.html");

#/bin/sed -i '\#/var/www/builds/Bawa/HD3.11.00.10-WF4.0.5.0\[3\].zip# s#<td>.*</td>#<td><center>6/25/13#' /var/www/builds/i.html
#the above line works on the command line.

}

