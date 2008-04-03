# based on..
# http://www.binzume.net/library/irssi.html
# http://www.irssi.org/scripts/html/charsetwars.pl.html

use Encode;
use Irssi;

our $VERSION = '0.03';
our %IRSSI   = (
	authors     => 'nabeken',
	contact     => 'nabeken@tknetworks.org',
	name        => 'encoding.pl',
	description => 'convert encodings from various charsets to utf-8',
	license     => 'public domain',
	changed     => '2008-04-02',
);

my $local_charset = 'UTF-8';

my %channelsettings = (
	'#gentoo-ja' => 'UTF-8',
	'#testfornabeken' => 'ISO-2022-JP',
);

sub send_text {
	my ( $text, $server, $witem ) = @_;

	if ($server && $witem) {
		my $target_charset = $channelsettings{$witem->{name}};
		Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
	}

	Irssi::signal_continue( $text, $server, $witem );
}

Irssi::signal_add( 'send text', 'send_text' );

sub send_command {
	my ($command,$server,$item) = @_;
	my $target_charset = $channelsettings{$item->{name}};
	Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
	Irssi::signal_continue( $command, $server, $item );

	if (moge) {
	    moge
	}
}

Irssi::signal_add( 'send command', 'send_command' );

sub message_public {
	my ($server, $msg, $nick, $addr, $target) = @_;
	my $target_charset = $channelsettings{$target};
	Encode::from_to($msg, $target_charset, $local_charset);
	Irssi::signal_continue($server, $msg, $nick, $addr, $target);
}

Irssi::signal_add('message public', 'message_public');

sub message_own_public {
	my ($server, $msg, $target) = @_;
	my $target_charset = $channelsettings{$target};
	Encode::from_to($msg, $target_charset, $local_charset);
	Irssi::signal_continue($server, $msg, $target);
}

Irssi::signal_add('message own_public', 'message_own_public');
