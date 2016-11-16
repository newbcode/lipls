#!/usr/bin/env perl

use Mojolicious::Lite;
use JSON;
use Moose;
use Mojo::Log;
use Encode;
use Data::Printer;
use utf8;

use lib "./lib";

use Reserv;
use MailSend;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';
my $selfonfig = plugin 'Config';

# Customize log file location and minimum log level
my $log = Mojo::Log->new(path => './log/mojo.log', level => 'info');

# Main
get '/' => sub {
	my $self = shift;

#} => 'coming_soon';
} => 'index';

get '/about_us' => sub {
	my $self = shift;

};

get '/services' => sub {
	my $self = shift;

};

get '/portfolio' => sub {
	my $self = shift;

} => 'portfol';

get '/studio' => sub {
	my $self = shift;

};

get '/reserv' => sub {
	my $self = shift;

	#my @r = Reserv->new( table_name => 'reserv_board' )->t_list();
	my $r = Reserv->new( table_name => 'reserv_board' )->t_list();
	$self->stash( list => $r );

} => '/reserv/reserv';

get '/contact' => sub {
	my $self = shift;

} => '/contact/contact';

get '/reserv_info' => sub {
	my $self = shift;

} => '/reserv/reserv_info';

get '/reserv_write' => sub {
	my $self = shift;

} => '/reserv/reserv_write';

get '/reserv_read_check' => sub {
	my $self = shift;

	my $id = $self->param('id');
	$self->stash( id => $id );

} => '/reserv/reserv_read_check';

post '/reserv_read_check' => sub {
	my $self = shift;

	my $info = $self->param('POSTDATA');
	my $r_info = from_json($info);

	my $resp = { result  => 'N' };
	my @r = Reserv->new( list_id => $r_info->{id}, table_name => 'reserv_board' )->t_read();

	foreach my $k ( @r ) {
		if ( $r_info->{pw} eq $k->{pw} ) {
			#$self->redirect_to("/reserv_read_check?id=$r_info->{id}&pw=$r_info->{pw}");
			my $n = decode('utf-8', $k->{name});
			$self->session( name => $n );
			$resp = { result  => 'Y' };
		}
		elsif ( $r_info->{pw} eq 'lipls0525') {
			$self->session( name => 'LIPLS');
			$resp = { result  => 'Y' };
		}
	}
	$self->render(json => $resp);
};

get '/reserv_del' => sub {
	my $self = shift;

	my $id = $self->param('id');
	my $r = Reserv->new( list_id => $id, table_name => 'reserv_board' )->t_del();
	$self->redirect_to("/reserv");
};

get '/reserv_read' => sub {
	my $self = shift;

	my $id  = $self->param('id');
	my @r = Reserv->new( list_id => $id, table_name => 'reserv_board' )->t_read();

	$self->stash( read  => \@r );

} => '/reserv/reserv_read_table';

post '/reserv_write' => sub {
	my $self = shift;

	my $info = $self->param('POSTDATA');
	my $r_info = from_json($info);

	my $resp = { result  => 'Y' };
	foreach my $k ( keys %{$r_info} ) {
		next if $k =~ /use_cnt|shot_desc/;
		unless ( $r_info->{$k} ) {
			$resp = { result => 'N' };
			$self->render(json => $resp);
		}
	}
	my $r = Reserv->new( table_name => 'reserv_board' )->t_write( $r_info );
	$self->render(json => $resp);
};

# 예약 게시판 댓글 불러오기
get '/reserv_reply' => sub {

	my $self = shift;
	my $id = $self->param('notice_id');

	#$log->info("NOTICE: $id");
	my $replys = Reserv->new( list_id => $id, table_name => 'reserv_board_reply' )->t_read();

	$self->stash( replys => $replys, notice_id => $id );
} => '/reserv/reserv_reply';

# 예약 게시판 댓글 저장
post '/reserv_reply' => sub {                                                 
	my $self = shift;

	my $content = $self->param('POSTDATA');                             
	my $resp = { result => 'N', };

	my $jdata = from_json($content);

	$log->info("notice_id=$jdata->{notice_id}, content=$jdata->{content}");

	if(exists $jdata->{notice_id} && exists $jdata->{content}) {
		my $r = Reserv->new( table_name => 'reserv_board_reply' )->t_write( $jdata, $self->session('name') );
		$resp->{result} = 'Y';
	}
	else {
		$resp->{error} = 'argument error';
	}       
	$log->info("$resp->{result}");

	$self->render(json => $resp);
};

# 댓글 삭제
del '/reserv_reply' => sub {
	my $self = shift;

	my $id = $self->param('reserv_id');

	my $resp = { result => 'N', };

	my $row = Reserv->new( table_name => 'reserv_board_reply',  list_id => $id)->t_del();
	$resp->{result} = 'Y';
	$self->render(json => $resp);
};

# 메일 보내기
post '/mail_send' => sub {                                                 
	my $self = shift;

	my $content = $self->param('POSTDATA');                             
	my $jdata = from_json($content);

	#$log->info("$jdata->{name}, $jdata->{email}, $jdata->{message}");
	
	my $body = "이름: $jdata->{name}\n"."메일주소: $jdata->{email}\n"."문의내용\n"."\n"."$jdata->{message}";
	$body = encode('utf-8', $body);
	
	my $ret = MailSend->new( name => $jdata->{name}, email => $jdata->{email} )->send_mail($body); 

	my $resp = { result  => $ret };
	$self->render(json => $resp);
};

app->start;
