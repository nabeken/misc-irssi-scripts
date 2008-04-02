#!/usr/bin/perl

# based on conv.pl
# http://www.binzume.net/library/irssi.html

use Irssi;
use Encode;

our $VERSION = '0.03';
our %IRSSI   = (
    authors     => 'nabeken',
    contact     => 'nabeken@tknetworks.org',
    name        => 'encoding.pl',
    description => 'convert encodings from various charsets to utf-8',
    license     => 'NYSL',
    changed     => '2008-04-02',
);

my $local_charset = 'UTF-8';

my $channelsettings = (
  '#gentoo-ja' => 'UTF-8',
  '#testfornabeken' => 'ISO-2022-JP';
);

sub send_text {
    my ( $text, $server, $witem ) = @_;

    if ($server && $witem) {
        my $target_charset = $channelsettings{$witem->Channnel->{name}}
	Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
    }

    Irssi::signal_continue( $text, $server, $witem );
}

Irssi::signal_add( 'send text', 'send_text' );

sub send_command {
    my ($command,$server,$item) = @_;
    my $target_charset = $channelsettings{$witem->Channnel->{name}}
    Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
    Irssi::signal_continue( $command, $server, $item );
}

Irssi::signal_add( 'send command', 'send_command' );

sub print_text {
    my ( $dest, $text, $stripped ) = @_;
      if ($text!~/Topic for .+:/) {
        my $target_charset = $channelsettings{$witem->Channnel->{name}}
	Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
      }
    Irssi::signal_continue( $dest, $text, $stripped );
}

Irssi::signal_add( 'print text', 'print_text' );

sub message_topic {
    my ( $server, $chan, $topic, $nick, $addr ) = @_;
    my $target_charset = $channelsettings{$witem->Channnel->{name}}
    Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
    Irssi::signal_continue( $server, $chan, $topic, $nick, $addr );
}

Irssi::signal_add_first( 'message topic', 'message_topic' );

sub event_topic {
    my ($server, $data, $nick, $address) = @_;
    my ($channel, $topic) = split(/ :/, $data, 2);
    my $target_charset = $channelsettings{$witem->Channnel->{name}}
    Encode::from_to($text, $local_charset, $target_charset) if defined $target_charset;
    $data = "$channel :$topic";

    Irssi::signal_continue( $server, $data, $nick, $address );
}

Irssi::signal_add_first("event topic", "event_topic");
Irssi::signal_add_first("event 332", "event_topic");
Irssi::signal_add_first("event 333", "event_topic");
