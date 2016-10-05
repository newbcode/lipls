#===============================================================================
#
#         FILE: ReservDB.pm
#
#  DESCRIPTION: 예약페이지 DB API
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  newbcode@lilpls.com
#      COMPANY:  Lipls
#      VERSION:  0.001
#      CREATED:  2016년 07월 10일
#     REVISION:  ---
#===============================================================================

package Reserv;

use Moose;
use DBIx::Simple;
use Date::Parse;
use Data::Dumper;

has 'table_name' => (
	is  => 'rw',
	isa => 'Str',
);

has 'list_id' => (
	is  => 'ro',
	isa => 'Str',
);

# Customize log file location and minimum log level
my $log = Mojo::Log->new(path => './log/mojo.log', level => 'info');

#Mysql 접속
my $dbh = DBIx::Simple->connect(
        'DBI:mysql:database=lipls',
	'lipls', 'lipls',
        {   
		#RaiseError => 1,
		#mysql_enable_utf8 => 1,
                mysql_auto_reconnect => 1,
        }
);

sub t_write {
	my ($self, $info, $loginname ) = @_;

	my $table = $self->table_name();

	if ( $table eq 'reserv_board' ) {
		$dbh->query(
			"INSERT INTO $table (`name`, `subject`, `phone`, `pay_name`, `use_cnt`, `shot_desc`, `pw`, `start_date`, `end_date`) VALUES (??)",
			$info->{name}, $info->{subj}, $info->{phone}, $info->{pay_name}, $info->{use_cnt}, 
			$info->{shot_desc}, $info->{pw}, $info->{start_date}, $info->{end_date}
		);
	}
	else {
		$dbh->query(
			"INSERT INTO $table (`reserv_id`, `name`, `reply`) VALUES (??)",
			$info->{notice_id}, $loginname, $info->{content}             
		) or die $dbh->error;
	}

	unless ( $dbh->error ) {
		print "ERROR\n";
		return $dbh->error;
	}

	return 1;
}

sub t_read {
	my $self = shift;

	my $table = $self->table_name;
	my $id = $self->list_id;

	if ( $table eq 'reserv_board' ) {
		my $h = $dbh->query( "SELECT * FROM $table WHERE id=$id") or die $dbh->error;
		my @result = $h->hashes;

		return @result;
	}
	else {
		my $reply_rows = $dbh->query("SELECT * FROM $table WHERE reserv_id=$id") or die $dbh->error;
		my $replys;
		while( my $row = $reply_rows->hash) {
			my $datetime = str2time("$row->{wdate} -0900");
			$replys->{$datetime} = $row;
			#$log->info("date: $count");
			#$log->info("RE: $replys->{$datetime}")
		}

		return $replys;
	}
}

sub t_del {
	my $self = shift;

	my $table = $self->table_name();
	my $id = $self->list_id();

	$dbh->query( "DELETE FROM $table WHERE id=$id") or die $dbh->error;

	return 1;
}

sub t_list {
	my $self = shift;

	my $table = $self->table_name();

	my $h = $dbh->query( "SELECT `id`, `name`, `subject`, `wdate` FROM $table") or die $dbh->error;
	my @result = $h->hashes;

	my $info;
	foreach my $h ( @result ) {
		#$log->info("$h->{id}");
		$info->{$h}->{id} 	= $h->{id};
		$info->{$h}->{name} 	= $h->{name};
		$info->{$h}->{subject} 	= $h->{subject};
		$info->{$h}->{wdate} 	= $h->{wdate};
		$info->{$h}->{re_cnt} 	= reply_cnt($h->{id});
	}
	#$log->info("P" . Dumper($info));
	#return @result;
	return $info;
}

sub reply_cnt {
	my $id = shift;
	my $table = 'reserv_board_reply';

	my $reply_rows = $dbh->query("SELECT * FROM $table WHERE reserv_id=$id") or die $dbh->error;
	my $replys;
	my $cnt = 0;
	while( my $row = $reply_rows->hash) {
		$cnt++;
	}
	#$log->info("id: $id re_cnt: $cnt");
	return $cnt;
}

1;
