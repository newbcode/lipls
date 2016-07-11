#!/usr/bin/env perl

use Mojolicious::Lite;
use Data::Printer;
use JSON;
use Moose;
use Encode;
use lib "/home/newbcode/server/lipls/lib";

use ReservDB;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
	my $c = shift;

} => 'coming_soon';

get '/reserv' => sub {
	my $c = shift;

	my @r = ReservDB->new( table_name => 'reserv_board' )->t_list();
	$c->stash( list => \@r );

} => '/reserv/reserv';

get '/reserv_info' => sub {
	my $c = shift;

} => '/reserv/reserv_info';

get '/reserv_write' => sub {
	my $c = shift;

} => '/reserv/reserv_write';

get '/reserv_read_check' => sub {
	my $c = shift;

	my $id = $c->param('id');
	$c->stash( id => $id );

} => '/reserv/reserv_read_check';

post '/reserv_read_check' => sub {
	my $c = shift;

	my $info = $c->param('POSTDATA');
	my $r_info = from_json($info);

	my $resp = { result  => 'N' };
	my @r = ReservDB->new( list_id => $r_info->{id}, table_name => 'reserv_board' )->t_read();

	foreach my $k ( @r ) {
		if ( $r_info->{pw} eq $k->{pw} ) {
			#$c->redirect_to("/reserv_read_check?id=$r_info->{id}&pw=$r_info->{pw}");
			$resp = { result  => 'Y' };
		}
	}
	$c->render(json => $resp);
};

get '/reserv_del' => sub {
	my $c = shift;

	my $id = $c->param('id');
	my $r = ReservDB->new( list_id => $id, table_name => 'reserv_board' )->t_del();
	$c->redirect_to("/reserv");
};

get '/reserv_read' => sub {
	my $c = shift;

	my $id  = $c->param('id');
	my @r = ReservDB->new( list_id => $id, table_name => 'reserv_board' )->t_read();

	$c->stash( read  => \@r );

} => '/reserv/reserv_read_table';

post '/reserv_write' => sub {
	my $c = shift;

	my $info = $c->param('POSTDATA');
	my $r_info = from_json($info);

	my $resp = { result  => 'Y' };
	foreach my $k ( keys %{$r_info} ) {
		unless ( $r_info->{$k} ) {
			$resp = { result => 'N' };
			$c->render(json => $resp);
		}
	}
	my $r = ReservDB->new( table_name => 'reserv_board' )->t_write( $r_info );
	$c->render(json => $resp);
};

app->start;
