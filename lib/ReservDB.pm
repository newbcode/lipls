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

package ReservDB;

use Moose;
use DBIx::Simple;
use Data::Printer;

has 'table_name' => (
	is  => 'rw',
	isa => 'Str',
);

has 'list_id' => (
	is  => 'ro',
	isa => 'Str',
);

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
	my ($self, $info ) = @_;

	my $table = $self->table_name();

	$dbh->query(
		"INSERT INTO $table (`name`, `subject`, `phone`, `pay_name`, `use_cnt`, `shot_desc`, `pw`, `start_date`, `end_date`) VALUES (??)",
		$info->{name}, $info->{subj}, $info->{phone}, $info->{pay_name}, $info->{use_cnt}, 
		$info->{shot_desc}, $info->{pw}, $info->{start_date}, $info->{end_date}
	);

	unless ( $dbh->error ) {
		print "ERROR\n";
		return $dbh->error;
	}

	return 1;
}

sub t_read {
	my $self = shift;

	my $table = $self->table_name();
	my $id = $self->list_id();

	my $h = $dbh->query( "SELECT * FROM $table WHERE id=$id") or die $dbh->error;
	my @result = $h->hashes;

	return @result;
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

	return @result;
}

1;
