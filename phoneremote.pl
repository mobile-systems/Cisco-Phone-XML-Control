#!/usr/bin/perl -w
#Author: Robert Thurber
#Updated: 2011-01-24
#
use LWP::UserAgent;
use HTTP::Request::Common;

$ip = $ARGV[0];
$user = $ARGV[1];
$password = $ARGV[2];

#
# Main XML Delivery Routine
#
sub xmlSend {
		
		my $userAgentPre = LWP::UserAgent->new(agent => 'THURBER-1.0');
		$userAgentPre->get_basic_credentials('test', 'http://' . $_[0] . '/CGI/Execute', '1');
		my $responsePre = $userAgentPre->request(GET 'http://' . $_[0] . '/CGI/Execute');
		
		my $varSplit = $responsePre->as_string;
		my @varSplitTwo = split("\n",$varSplit);

		foreach (@varSplitTwo) {
			if ($_ =~ /WWW-Authenticate/) {
				my @realmGET = split("=",$_);
				$ii = "1";
				foreach (@realmGET) {
					if ($ii eq "2") {
						$realm = $_;
						$realm =~ s/^\"//;
						$realm =~ s/\"$//;
					}
					$ii++;
				}
			}
		}

		my $userAgent = LWP::UserAgent->new(agent => 'THURBER-1.0');
		my $message = 'XML=<CiscoIPPhoneExecute><ExecuteItem URL="' . $_[3] . '"/></CiscoIPPhoneExecute>';

		$userAgent->credentials($_[0] . ":80", $realm, $_[1] => $_[2]);

		push @{ $userAgent->requests_redirectable }, 'POST';
		
		my $response = $userAgent->request(POST 'http://' . $_[0] . '/CGI/Execute',
		Content_Type => 'text/xml',
		Content => $message);
		print $response->error_as_HTML unless $response->is_success;
		print $response->as_string;
}



sub xmlSendBack {
	# Not used - can set the background but you need a web server
		
		my $userAgentPre = LWP::UserAgent->new(agent => 'THURBER-1.0');
		$userAgentPre->get_basic_credentials('test', 'http://' . $_[0] . '/CGI/Execute', '1');
		my $responsePre = $userAgentPre->request(GET 'http://' . $_[0] . '/CGI/Execute');
		
		my $varSplit = $responsePre->as_string;
		my @varSplitTwo = split("\n",$varSplit);

		foreach (@varSplitTwo) {
			if ($_ =~ /WWW-Authenticate/) {
				my @realmGET = split("=",$_);
				$ii = "1";
				foreach (@realmGET) {
					if ($ii eq "2") {
						$realm = $_;
						$realm =~ s/^\"//;
						$realm =~ s/\"$//;
					}
					$ii++;
				}
			}
		}

		my $userAgent = LWP::UserAgent->new(agent => 'THURBER-1.0');
		#my $message = 'XML=<setBackground><background><image>http://10.0.130.254/cgi-bin/9971.cgi</image><icon>http://10.0.16.35/xml/rosethumb.png</icon></background></setBackground>';
		my $message = 'XML=<setBackground><background><image>http://10.0.130.254/cgi-bin/gdbackground.cgi</image><icon>http://blog.pbmit.com/xml/rosethumb.png</icon></background></setBackground>';


		$userAgent->credentials($_[0] . ":80", $realm, $_[1] => $_[2]);

		push @{ $userAgent->requests_redirectable }, 'POST';
		
		my $response = $userAgent->request(POST 'http://' . $_[0] . '/CGI/Execute',
		Content_Type => 'text/xml',
		Content => $message);
		print $response->error_as_HTML unless $response->is_success;
		print $response->as_string;
}


#
# Testing New RTP XML Schema
#
sub Spy {

		my $userAgent = LWP::UserAgent->new(agent => 'perl post');

		$xmlNEW = 'XML=<startMedia><mediaStream receiveVolume="50"><type>audio</type><codec>G.711</codec><mode>sendReceive</mode><address>239.1.1.1</address><port>20480</port></mediaStream></startMedia>';
		my $message = $xmlNEW;


		$userAgent->credentials($_[0] . ":80", "user", $_[1] => $_[2]);

		my $response = $userAgent->request(POST 'http://' . $_[0] . '/CGI/Execute',
		Content_Type => 'text/xml',
		Content => $message);
		print $response->error_as_HTML unless $response->is_success;
		print $response->as_string;
}


# Testing Video
sub Video {

		my $userAgent = LWP::UserAgent->new(agent => 'perl post');

		$xmlNEW = 'XML=<startMedia><mediaStream receiveVolume="50"><type>video</type><codec>H264</codec><mode>sendReceive</mode><address>239.1.1.1</address><port>20480</port></mediaStream></startMedia>';
		my $message = $xmlNEW;


		$userAgent->credentials($_[0] . ":80", "user", $_[1] => $_[2]);

		my $response = $userAgent->request(POST 'http://' . $_[0] . '/CGI/Execute',
		Content_Type => 'text/xml',
		Content => $message);
		print $response->error_as_HTML unless $response->is_success;
		print $response->as_string;
}



sub noSpy {

		my $userAgent = LWP::UserAgent->new(agent => 'perl post');
		$xmlNEW = 'XML=<stopMedia><mediaStream receiveVolume="50"><type>audio</type><codec>G.711</codec><mode>sendReceive</mode><address>239.1.1.1</address><port>20480</port></mediaStream></stopMedia>';
		my $message = $xmlNEW;


		$userAgent->credentials($_[0] . ":80", "user", $_[1] => $_[2]);

		my $response = $userAgent->request(POST 'http://' . $_[0] . '/CGI/Execute',
		Content_Type => 'text/xml',
		Content => $message);
		print $response->error_as_HTML unless $response->is_success;
		print $response->as_string;
}

if (!$ip | !$user | !$password) {
	print "IP Address:";
	chomp($ip = <STDIN>);  
	print "Username:";
	chomp($user = <STDIN>);  
	print "Password: ";
	chomp($password = <STDIN>);  
}

print "Cisco IP Phone XML URI Control\nEnter ? for help\n";

$i = 1;

while ($i > 0) {

	print '>';
	chomp($input = <STDIN>); 

	if ($input eq 'exit' | $input eq 'quit' | $input eq 'bye') {
		$i = 0;
	} 
	

	elsif ($input eq 'video' | $input eq 'Video') {
			&Video($ip,$user,$password);
	} 
	
	elsif ($input eq '?' | $input eq 'help') {
		print "Help for Commands. Your Current Phone IP is " . $ip . "\n\n";
		print "test \t\t\t - to test your IP and authentication. play chime on phone\n";
		print "chime \t\t\t - play chime on phone\n";
		print "dial	\t\t - dial a number\n";
		print "speaker \t\t - speaker toggle on/off\n";
		print "key \t\t\t - enter a key\n";
		print "url \t\t\t - XML URL\n";
		print "send \t\t\t - Send Text Message to this phone\n\n";
		
		print "txm \t\t\t - Send Multicast RTP 239.1.1.1 (\"no txm\" to turn off)\n";
		print "rxm \t\t\t - Recieve Multicast RTP 239.1.1.1 (\"no rxm\" to turn off)\n";
		print "rtpto \t\t\t - Send a Unicast RTP stream (\"no rtpto\" to turn off)\n";
		print "rtpfrom \t\t - Recieve a Unicast RTP stream (\"no rtpfrom\" to turn off)\n\n";


		print "Navigation:\n";
		print "up/down/left/right \t - You have to enter the work up/down/left/right. You can't use the arrow keys\n";
		print "select \t\t\t - duh!\n";
		print "[0-9] \t\t\t - number pad\n";
		print "[s1-4] \t\t\t - soft keys\n";

		print "\n\nNOTE: RTP uses 239.1.1.1 for mutlticast and UDP Port 20480 for multi/unicast.\n";
	} 




	elsif ($input eq 'chime' | $input eq 'test') {
			&xmlSend($ip,$user,$password,"Play:Chime.raw");
	} 


	elsif ($input eq 'back') {
			&xmlSendBack($ip,$user,$password);
	} 

	elsif ($input eq 'hello' | $input eq 'Hello') {
			&xmlSend($ip,$user,$password,"Play:AreYouThere.raw");
	} 

	
	elsif ($input eq 'dial') {
			print "Number:";
			chomp($number = <STDIN>);  
			$dial = "Dial:" . $number;
			&xmlSend($ip,$user,$password,$dial);
	} 
	
	elsif ($input eq 'key') {
			print "key:";
			chomp($key = <STDIN>);  
			$keyfull = "Key:" . $key;
			&xmlSend($ip,$user,$password,$keyfull);
	} 
	
	elsif ($input eq 'speaker') {
			$keyfull = "Key:Speaker";
			&xmlSend($ip,$user,$password,$keyfull);
	} 
	
	elsif ($input eq 'digits') {
			print "digits:";
			chomp($digits = <STDIN>);  
			$digitsfull = "SendDigits:" . $digits;
			&xmlSend($ip,$user,$password,$digitsfull);
	}
	
	elsif ($input eq 'url') {
			print "url:";
			chomp($url = <STDIN>);  
			&xmlSend($ip,$user,$password,$url);
	}

	

	elsif ($input eq 'up' | $input eq 'Up' | $input eq 'UP') {
			&xmlSend($ip,$user,$password,"Key:NavUp");
	}

	elsif ($input eq 'down') {
			&xmlSend($ip,$user,$password,"Key:NavDwn");
	}

	elsif ($input eq 'left') {
			&xmlSend($ip,$user,$password,"Key:NavLeft");
	}

	elsif ($input eq 'right') {
			&xmlSend($ip,$user,$password,"Key:NavRight");
	}

	elsif ($input eq 'select' | $input eq 'Select') {
			&xmlSend($ip,$user,$password,"Key:NavSelect");
	}

	elsif ($input eq 'back' | $input eq 'Back') {
			print "not always supported\n";
			#&xmlSend($ip,$user,$password,"Key:NavBack");
	}

	elsif ($input eq 'Services' | $input eq 'services') {
			&xmlSend($ip,$user,$password,"Key:Services");
	}

	elsif ($input eq 'Headset' | $input eq 'headset') {
			&xmlSend($ip,$user,$password,"Key:Headset");
	}

	elsif ($input eq 'answer' | $input eq 'Answer') {
			&xmlSend($ip,$user,$password,"Init:Services");
			#&xmlSend($ip,$user,$password,"Init:Headset");
			&xmlSend($ip,$user,$password,"Key:Soft1");
	}

	elsif ($input eq 'Messages' | $input eq 'messages') {
			&xmlSend($ip,$user,$password,"Key:Messages");
	}

	elsif ($input eq 'conf' | $input eq 'Conf') {
			&xmlSend($ip,$user,$password,"Key:Soft4");
			&xmlSend($ip,$user,$password,"Key:Soft2");
			print "number:";
			chomp($transfernum = <STDIN>); 
			@transfernumarray = split(//,$transfernum);
			foreach (@transfernumarray) {
				my $dig = "Key:KeyPad" . $_;

				&xmlSend($ip,$user,$password,$dig);

			}
			&xmlSend($ip,$user,$password,"Key:Soft3");

	}	

	elsif ($input eq 'send' | $input eq 'Send') {
			print "message:";
			chomp($sendtext = <STDIN>); 
			$sendtext =~ s/\s/_/g;
			$sendtexturl = "http://67.126.254.35/text.php?txt=" . $sendtext;
			&xmlSend($ip,$user,$password,"$sendtexturl");
			#&xmlSend($ip,$user,$password,"Play:Chime.raw");
	}

	elsif ($input =~ /^[0-9]{1}$/) {
			$keypad = "Key:KeyPad" . $input;
			&xmlSend($ip,$user,$password,$keypad);
	}


	elsif ($input =~ /^[0-9]{2,}$/) {
			@keyseq = split(//,$input);
			foreach (@keyseq) {
				my $key = "Key:KeyPad" . $_;
				&xmlSend($ip,$user,$password,$key);
			}
	}

	elsif ($input =~ /^s[0-5]{1}$/) {
			my @softsplit = split(//,$input);
			$softkeypad = "Key:Soft" . $softsplit[1];
			&xmlSend($ip,$user,$password,$softkeypad);
	}

	elsif ($input =~ /\*/) {
			&xmlSend($ip,$user,$password,"Key:KeyPadStar");
	}

	elsif ($input =~ /\#/) {
			&xmlSend($ip,$user,$password,"Key:KeyPadPound");
	}

	elsif ($input eq 'txm' | $input eq 'sendmcast') {
			&xmlSend($ip,$user,$password,'RTPMTx:239.1.1.1:20480');
	}

	elsif ($input eq 'no txm' | $input eq 'no sendmcast') {
			&xmlSend($ip,$user,$password,'RTPMTx:Stop');
	}

	elsif ($input eq 'rxm' | $input eq 'rxmcast') {
			&xmlSend($ip,$user,$password,'RTPMRx:239.1.1.1:20480');
	}

	elsif ($input eq 'spy') {
			&Spy($ip,$user,$password);
	}
	#newRTP

	elsif ($input eq 'nospy') {
			&noSpy($ip,$user,$password);
	}
	#newRTP

	elsif ($input eq 'video') {
			&Video($ip,$user,$password);
	}


	elsif ($input eq 'no rxm' | $input eq 'no rxmcast') {
			&xmlSend($ip,$user,$password,'RTPMRx:Stop');
	}

	elsif ($input eq 'blank') {
		&xmlSend($ip,$user,$password,'Display:Off:0');
	}

	elsif ($input eq 'rtpto') {
			print "IP:";
			chomp($rtppre = <STDIN>); 
			$rtptx = "RTPTx:" . $rtppre . ":20480";
			&xmlSend($ip,$user,$password,$rtptx);
	}

	elsif ($input eq 'no rtpto') {
			&xmlSend($ip,$user,$password,'RTPTx:Stop');
	}

	elsif ($input eq 'rtpfrom') {
			print "IP:";
			chomp($rtpfrompre = <STDIN>); 
			$rtprx = "RTPRx:" . $rtpfrompre . ":20480:100";
			&xmlSend($ip,$user,$password,$rtprx);
	}

	elsif ($input eq 'no rtpfrom') {
			&xmlSend($ip,$user,$password,'RTPRx:Stop');
	}

	###############################################################
	# NEW FEATURES ADDED ABOVE HERE using elsif ($input eq 'asdf') { }
	###############################################################

	else {
		print "Error: Invalid or no command\n";
	}
}

