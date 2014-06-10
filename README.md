Cisco-Phone-Report
==================

Command Line Perl Remote Control for most Cisco Phones

Usage:
phoneremote.pl <IP of Phone> username password

Requires:
- A privileged user on the phone (CallManager)
- HTTP enabled on the phone

Features:
- Dial a number
- Provision a RTP Stream (yes can eaves drop)
- Remotely touch most soft keys (great for troubleshooting)

It's a command line tool, so you don't get to see the phone. But I have a low tech solution for that.

Simply create a HTML document with the following code. It leverages the built in CGI/Screenshot function.

<meta http-equiv="refresh" content="2"><Br><img src="http://1.1.1.1/CGI/Screenshot"></img><br><br>
<a href="http://1.1.1.1/">Mgmt Interface</a>

Settings for Cisco UCM (CallManager):
Enable HTTP web management
You'll need a user account (the same account you log into CCMUSER), and you need to associate the phone you want to control via that interface.
