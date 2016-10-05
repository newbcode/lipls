#===============================================================================
#
#         FILE: MailSend.pm
#
#  DESCRIPTION: GMAIL로 메일보내기
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  newbcode@lilpls.com
#      COMPANY:  Lipls
#      VERSION:  0.001
#      CREATED:  2016년 07월 19일
#     REVISION:  ---
#===============================================================================

package MailSend;

use Moose;
use Data::Printer;
use Email::Send::SMTP::Gmail;

has 'name' => (
	is  => 'rw',
	isa => 'Str',
);

has 'email' => (
	is  => 'ro',
	isa => 'Str',
);

# Customize log file location and minimum log level
my $log = Mojo::Log->new(path => './log/mojo.log', level => 'info');

sub send_mail {
	my ($self, $message) = @_;

	my $addr = 'codenewb@gmail.com';
	my $pw = 'ubnndcakvyxfjhio';
	my $subject = 'LIPLS 홈페이지를 통해 문의한 내용입니다';

	my ( $mail, $error_msg ) = Email::Send::SMTP::Gmail->new(
		-smtp  => 'smtp.gmail.com',
		-login => $addr, 
		-pass  => $pw,
	);

	if ( $mail == -1 ) {
		print "error: $error_msg";
		exit;
	}

	my ( $result, $err_msg ) = $mail->send(
		#-to      => 'contact@lipls.com',
		-to      => 'newbcode@naver.com',
		-subject => "$subject"."-- $self->name",
		-body    => $message,

		# 첨부 파일이 있는 경우
		#-attachments=> '/home/gypark/doc.txt,/home/gypark/music.mp3',
	);
	return 'success';
}

1;
