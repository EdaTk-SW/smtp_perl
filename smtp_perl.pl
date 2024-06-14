#################################################################################################################
#
# ©2024 SIEMENS EDA. All Rights Reserved.
#
# This software or file (the "Material") contains trade secrets or otherwise confidential information owned by
# Siemens Industry Software Inc. or its affiliates (collectively, "SISW"), or SISW's licensors. Access to and use
# of this information is strictly limited as set forth in one or more applicable agreement(s) with SISW. This
# Material may not be copied, distributed, or otherwise disclosed without the express written permission of SISW,
# and may not be used in any way not expressly authorized by SISW.
#
# Unless otherwise agreed in writing, SISW has no obligation to support or otherwise maintain this Material.
# No representation or other affirmation of fact herein shall be deemed to be a warranty or give rise to any
# liability of SISW whatsoever.
#
# SISW reserves the right to make changes in specifications and other information contained herein without prior
# notice, and the reader should, in all cases, consult SISW to determine whether any changes have been made.
#
# SISW MAKES NO WARRANTY OF ANY KIND WITH REGARD TO THIS MATERIAL INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT OF INTELLECTUAL PROPERTY.
# SISW SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, CONSEQUENTIAL OR PUNITIVE DAMAGES, LOST DATA OR
# PROFITS, EVEN IF SUCH DAMAGES WERE FORESEEABLE, ARISING OUT OF OR RELATED TO THIS PUBLICATION OR THE
# INFORMATION CONTAINED IN IT, EVEN IF SISW HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
#
# TRADEMARKS: The trademarks, logos, and service marks (collectively, "Marks") used herein are the property of
# Siemens AG, SISW, or their affiliates (collectively, "Siemens") or other parties. No one is permitted to use
# these Marks without the prior written consent of Siemens or the owner of the Marks, as applicable. The use
# herein of third party Marks is not an attempt to indicate Siemens as a source of a product, but is intended to
# indicate a product from, or associated with, a particular third party. A list of Siemens' Marks may be viewed
# at: www.plm.automation.siemens.com/global/en/legal/trademarks.html
#
#################################################################################################################
#
# File: smtp_perl.pl
#
# Original Author: Don Waldoch
#
# Revision History:
#
#   1.00  06/04/24  DTW  Initial Release.
#
#################################################################################################################
use strict;
use warnings;

use Config::IniFiles;
use FindBin qw($RealBin $Script);
use Net::SMTP;
use Readonly;

use Data::Dumper;
$Data::Dumper::Indent    = 1; # 1 => output a readable form with newlines but no fancy indentation.
$Data::Dumper::Purity    = 1; # Correctly recreate nested references.
$Data::Dumper::Quotekeys = 0; # Skip key quotes on simple strings.
$Data::Dumper::Sortkeys  = 1; # Dump in Perl's default sort order.

#########################################################################
# File scoped Constants & Variables
#

use vars qw(%Base %Process);

Readonly::Hash %Base => {
   True  => 1,
   False => 0,
   Ok    => 0,
   Error => 1,
   Log   => "$RealBin/$Script" =~ s/\.pl/\.log/r,
};

tie %Process, 'Config::IniFiles', (-file=>"$RealBin/.env", -fallback=>'env');

#########################################################################
# Pre-declared Functions (as well as imported functions) do not
# require parentheses to pass parameters
#

sub tee {
   my $fh;
   open($fh, '>>', $Base{Log}) || die "can't open $Base{Log}: $!";
      print "@_";
      print $fh "@_";
   close($fh) || die "can't close $Base{Log}: $!";
   return $Base{True};
}

#########################################################################

unlink($Base{Log}) if (-f $Base{Log});
send_mail() || exit $Base{Error};
exit $Base{Ok};

#########################################################################

sub send_mail {
   
   tee "Sending Mail...\n";
   
   my $dump = sprintf("%s", Data::Dumper->Dump([\%Process], [('Process')]));
   tee "\n$dump\n";
   
   my $header  = "To: $Process{env}{receiver}\n";
      $header .= "From: $Process{env}{sender}\n";
      $header .= "Content-Type: text/html\n";
      $header .= "Subject: Testing Net::SMTP with TLS\n";
      
   my $body = "\nThe <i>body</i> of the <b>email</b> Net-SMTP TLS example\n";
   
   my $smtp = Net::SMTP->new(
      $Process{env}{server},
      Port => $Process{env}{port},
   );
   
   $smtp->starttls();
   
   my $status = $Base{False};
   if ($smtp->auth($Process{env}{username}, $Process{env}{password})) {
      $smtp->mail($Process{env}{sender});
      if ($smtp->to($Process{env}{receiver})) {
         tee 'Success: ', $smtp->message();
         $smtp->data();
         $smtp->datasend($header);
         $smtp->datasend($body);
         $smtp->dataend();
         $status = $Base{True};
      } else {
         tee 'Error: ', $smtp->message();
      }
   } else {
      tee "Error: SMTP Authorization failed\n";
   }
   
   $smtp->quit();
   
   return $status;
}

#########################################################################
