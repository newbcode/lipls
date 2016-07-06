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
        // initialize board datepicker.
        $('#tm_start').datetimepicker({
                viewMode: 'days',
                format: 'YYYY-MM-DD HH',
                sideBySide: true,
        });
        $('#tm_end').datetimepicker({
                viewMode: 'days',
                format: 'YYYY-MM-DD HH',
                sideBySide: true,
        });

        // reserv click event.
        $('#reserv_write_btn').click( function () {
                var subj = $('#subj').val();
                var name = $('#name').val();
                var phone = $('#phone').val();
                var start_date = $('#tm_start').val();
                var end_date = $('#tm_end').val();
                var pay_name = $('#pay_name').val();
                var use_cnt = $('#use_cnt').val();
                var shot_desc = $('#shot_desc').val();
                var pw = $('#pw').val();

                console.log("subj: " + subj + ", name:" + name + ", phone:" + phone + ", start:" + start_date + ", end:" + end_date + ", pay_name:" + pay_name + ", use_cnt:" + use_cnt + ", shot_desc:" + shot_desc + ", pw:" + pw);

                // check validation.
                if(!subj) {
                        alert("제목을 입력 하세요!");
                        return false;
                }
		if(!name) {
                        alert("이름을 입력 하세요!");
                        return false;
                }
		if(!phone) {
                        alert("전화번호를 입력 하세요!");
                        return false;
                }
		if(!start_date) {
                        alert("예약 시작일을 선택하세요!");
                        return false;
                }
		if(!end_date) {
                        alert("예약 종료일을 선택하세요!");
                        return false;
                }
		if(!pay_name) {
                        alert("입금하실분 이름을 입력하세요");
                        return false;
                }
		if(!pw) {
                        alert("비밀번호 입력하세요");
                        return false;
                }

                //$('#singo_table_area').load('/spam_singo_table?date=' + singo_date + '&class=' + singo_class);
        } );
} );
