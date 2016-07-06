#!/usr/bin/env perl
#
use Mojolicious::Lite;
use Data::Printer;
use JSON;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
  my $c = shift;

} => 'coming_soon';

get '/cal' => sub {
  my $c = shift;

} => 'cal';

get '/reserv' => sub {
  my $c = shift;

};

get '/reserv_info' => sub {
  my $c = shift;

};

get '/reserv_write' => sub {
  my $c = shift;

};

post '/reserv_write' => sub {
  my $c = shift;

  my $info = $c->req->body_params->to_hash;

  p $info;
  $c->redirect_to('/reserv');
};


app->start;
