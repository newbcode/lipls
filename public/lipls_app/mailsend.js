$(document).ready(function() {
        // reserv click event.
        $('#mail_send_btn').click( function () {
		var post_data = new Object();
                post_data.name = $('#name').val();
                post_data.email= $('#email').val();
                post_data.message = $('#message').val();

                //console.log("subj: " + subj + ", name:" + name + ", phone:" + phone + ", start:" + start_date + ", end:" + end_date + ", pay_name:" + pay_name + ", use_cnt:" + use_cnt + ", shot_desc:" + shot_desc + ", pw:" + pw);

                // check validation.
		$.ajax({
			type: "POST",
			url: "/mail_send",
			data: {POSTDATA: JSON.stringify(post_data)},
			success: function(data) {
				if(data.result == 'Y') {
					alert('LIPLS로 메일발송이 되었습니다.');
					window.location = '/contact';
				}
				else {
					alert('발송실패 (***필수 항목을 확인해 주세요***)');
				}
			},
			error: function() {
				alert("발송실패");
			},
			dataType: "json",
		});
	} );
} );
