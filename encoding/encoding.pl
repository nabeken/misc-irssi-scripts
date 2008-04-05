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
    description => 'converting from various charsets to utf-8',
    license     => 'public domain',
    changed     => '2008-04-02',
);

my $local_charset = 'UTF-8';

my %channelsettings = (
    '#gentoo-ja' => 'UTF-8',
    '#testfornabeken' => 'ISO-2022-JP',
    '#なべけんてすと' => 'ISO-2022-JP',
);

my %channelsettings_reverse;

foreach $key (keys(%channelsettings)) {
    $target_charset = $channelsettings{$key};
    Encode::from_to($key, $local_charset, $target_charset);
    $channelsettings_reverse{$key} = $target_charset;
}

sub send_text {
    my ($text, $server, $witem) = @_;

    if ($server && $witem) {
        my $target_charset = $channelsettings{$witem->{name}};
        Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
    }

    Irssi::signal_continue($text, $server, $witem);
}
Irssi::signal_add('send text', 'send_text');

sub send_command {
    my ($command, $server, $item) = @_;
    my $target_charset;

    if ($command =~ /^\/join (.*)/) {
	my $chan = $1;
	$target_charset = $channelsettings{$chan};
    } else {
	my $char = $item->{name};
	$target_charset = $channelsettings_reverse{$item->{name}};
    }

    Encode::from_to($command, $local_charset, $target_charset) if defined $target_charset;
    Irssi::signal_continue($command, $server, $item);
}
Irssi::signal_add('send command', 'send_command');

sub message_public {
    my ($server, $msg, $nick, $addr, $target) = @_;
    my $target_charset = $channelsettings_reverse{$target};
    Encode::from_to($msg, $target_charset, $local_charset) if defined $target_charset;
    Irssi::signal_continue($server, $msg, $nick, $addr, $target);
}
Irssi::signal_add('message public', 'message_public');

sub message_own_public {
    my ($server, $msg, $target) = @_;
    my $target_charset = $channelsettings_reverse{$target};
    Encode::from_to($msg, $target_charset, $local_charset) if defined $target_charset;
    Irssi::signal_continue($server, $msg, $target);
}
Irssi::signal_add('message own_public', 'message_own_public');

sub message_irc_action {
    my ($server, $msg, $nick, $addr, $target) = @_;
    my $target_charset = $channelsettings_reverse{$target};
    Encode::from_to($msg, $target_charset, $local_charset) if defined $target_charset;
    Irssi::signal_continue($server, $msg, $nick, $addr, $target);
}
Irssi::signal_add('message irc action', 'message_irc_action');

sub message_topic {
    my ($server, $chan, $topic, $nick, $addr) = @_;
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($topic, $target_charset, $local_charset) if defined $target_charset;
    Encode::from_to($chan, $target_charset, $local_charset) if defined $target_charset;
    Irssi::signal_continue($server, $chan, $topic, $nick, $addr);
}
Irssi::signal_add('message topic', 'message_topic');

sub message_join {
    my ($server, $chan, $nick, $addr) = @_;
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($chan, $target_charset, $local_charset) if defined $target_charset;
    Irssi::signal_continue($server, $chan, $nick, $addr);
}
Irssi::signal_add('message join', 'message_join');
Irssi::signal_add('message part', 'message_join'); #TODO including reasons

sub event_topic {
    my ($server, $data, $nick, $addr) = @_;
    my ($chan, $topic) = split(/ :/, $data, 2);
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($chan, $target_charset, $local_charset) if defined $target_charset;
    Encode::from_to($topic, $target_charset, $local_charset) if defined $target_charset;
    $data = "$chan :$topic";
    Irssi::signal_continue($server, $data, $nick, $addr);
}

sub event_332 {
    my ($server, $data, $nick, $addr) = @_;
    $data =~ /^(.*) (.*) :(.*)/;
    my ($nick, $chan, $topic) = ($1, $2, $3);
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($chan, $target_charset, $local_charset) if defined $target_charset;
    Encode::from_to($topic, $target_charset, $local_charset) if defined $target_charset;
    $data = "$chan :$topic";
    Irssi::signal_continue($server, $data, $nick, $addr);
}

sub event_333 {
    Irssi::print "event: 333";
    my ($server, $data, $nick, $addr) = @_;
    Irssi::print "event: 333 / $data";
    my ($chan, $topic) = split(/ :/, $data, 2);
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($chan, $target_charset, $local_charset) if defined $target_charset;
    Encode::from_to($topic, $target_charset, $local_charset) if defined $target_charset;
    $data = "$chan :$topic";
    Irssi::signal_continue($server, $data, $nick, $addr);
}
Irssi::signal_add_first('event topic', 'event_topic');
Irssi::signal_add_first('event 332', 'event_332'); # 332 = event_topic_get / cf. src/irc/core/channel-events.c
#Irssi::signal_add_first('event 333', 'event_333');
# 333 = event_topic_info (Topic set by foobar) / see also above code.

sub event_353 {
    my ($server, $data) = @_;
    $data =~ /^(?:.*) = (.*) :.*/;
    my $chan = $1;
    my $target_charset = $channelsettings_reverse{$chan};
    Encode::from_to($data, $target_charset, $local_charset);
    Irssi::signal_continue($server, $data);
}
Irssi::signal_add_first('event 353', 'event_353'); #FIXME: printing twice..

# vim: set ts=8 sw=4:
