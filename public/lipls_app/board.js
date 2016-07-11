// regist remove bi modal data when dialog is closed.
$('.modal').on('hidden.bs.modal', function (e) {
        $(e.target).removeData('bs.modal')
                .find(".modal-content").html('');
})
$('.modal').on('hide.bs.modal', function (e) {
        $(e.target).removeData('bs.modal')
                .find(".modal-content").html('');
})

$(document).ready(function() {
        // reserv click event.
        $('#reserv_write_btn').click( function () {
		var post_data = new Object();
                post_data.subj = $('#subj').val();
                post_data.name = $('#name').val();
                post_data.phone = $('#phone').val();
                post_data.start_date = $('#tm_start').val();
                post_data.end_date = $('#tm_end').val();
                post_data.pay_name = $('#pay_name').val();
                post_data.use_cnt = $('#use_cnt').val();
                post_data.shot_desc = $('#shot_desc').val();
                post_data.pw = $('#pw').val();

                //console.log("subj: " + subj + ", name:" + name + ", phone:" + phone + ", start:" + start_date + ", end:" + end_date + ", pay_name:" + pay_name + ", use_cnt:" + use_cnt + ", shot_desc:" + shot_desc + ", pw:" + pw);

                // check validation.
		$.ajax({
			type: "POST",
			url: "/reserv_write",
			data: {POSTDATA: JSON.stringify(post_data)},
			success: function(data) {
				if(data.result == 'Y') {
					window.location = '/reserv';
				}
				else {
					alert('예약실패 (***필수 항목을 확인해 주세요***)');
				}
			},
			error: function() {
				alert("예약요청 실패");
			},
			dataType: "json",
		});
	} );
	$('#reserv_read_check_btn').click( function () {
		var post_data = new Object();
                var id = $('#id').val();
                post_data.pw = $('#pw').val();
                post_data.id = $('#id').val();

                //console.log("subj: " + subj + ", name:" + name + ", phone:" + phone + ", start:" + start_date + ", end:" + end_date + ", pay_name:" + pay_name + ", use_cnt:" + use_cnt + ", shot_desc:" + shot_desc + ", pw:" + pw);

                // check validation.
		$.ajax({
			type: "POST",
			url: "/reserv_read_check",
			data: {POSTDATA: JSON.stringify(post_data)},
			success: function(data) {
				if(data.result == 'Y') {
					 $( ".password" ).empty();
					 $('#reserv_read_table').load('/reserv_read?id=' + id);
				}
				else {
					alert('비밀번호를 확인해주세요!');
				}
			},
			error: function() {
				alert("비밀번호 요청 실패");
			},
			dataType: "json",
		});
	} );
} );
