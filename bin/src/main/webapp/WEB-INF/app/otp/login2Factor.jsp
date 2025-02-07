<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>통합로그인 | Pass-Ni SSO</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta name="format-detection" content="telephone=no, address=no, email=no" />
<meta name="title" content="통합로그인">
<meta name="keywords" content="통합로그인">
<link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon" />  
<link rel="stylesheet" href="<c:url value='/resources/user/css/base.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/user/css/layout.css'/>" type="text/css" />

<style type="text/css">
	.time{
		position: absolute;border: 0!important;width: 60px;right: 10px;background: none;color:red;padding:0;outline:none;top:13px;font-size:1rem;
	}
	.push_time{
		border: 0!important;width: 60px;left: 10px;background: none;color:red;padding:0;outline:none;font-size:1rem;
	}
	
	.section-btn{
		text-decoration:none;color:gray;font-weight:600;display:inline-flex;align-items:center;transition:color .2s linear;
	}

	.section-btn i{
		border:2px solid gray;width:30px;height:30px;margin-right:1rem;border-radius:40px;display:flex;align-items:center;justify-content:center;
	}

	.section-btn:hover{
		color:#C0C0C0;
	}
</style>
<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/util/countdown.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/login/login.js'/>"></script>
</head>
<body id="login">
	<div class="login_wrap">
		<div class="login_box">
			<div class="login_txt">
				<p>통합로그인</p>
			</div>
			<div class="login_form">
				<form id="loginForm" name="loginForm" method="post" autocomplete="off">
					<div id="push" style="display:none;">
						<div style="text-align:center;">
							<img src="<c:url value='/resources/user/images/main/loading03.gif'/>" alt="로딩 중">
							<p class="time_inner mt-3">인증 대기중입니다.<input id="push_countdown" class="push_time" type="text" value="3:00" disabled="disabled" /></p>
						</div>
						
						<div class="button_box">
							<button type="button" onclick="fnReSend()" class="btn" style="margin-top:10px;">시간연장</button>
							<button type="button" onclick="fnInitlLink()" class="btn" style="margin-top:10px;">간편인증 초기화</button>
						</div>
						
						<div style="margin-top:20px;">
							푸시 메시지를 클릭하여 간편인증 모바일앱(Smart Login)을 실행하여 주십시오.<br/>지문 또는 안면인식을 이용하여 인증을 진행하여 주십시오.<br/>휴대폰 기기 변경 및 앱을 재설치 한 경우 간편인증 초기화 후 재등록하여 주십시오.
						</div>
					</div>
					
					<div id="motp" style="display:none;">
						<div>
							<input type="text" oninput="numberMaxLength(this);" 
									style="letter-spacing:5px; font-size:1.2rem; height:60px; width:100%"
									maxlength="6" id="motp_no" placeholder="OTP 번호" autocomplete="off"/>
							<input type="text" id="motp_countdown" class="time" value="" disabled="disabled" />
						</div>
						
						<div style="margin-bottom:20px; margin-top:5px;">
							<span style="margin-left: 5px;">OTP 번호를 입력하여 주십시오.</span>
						</div>
						
						<div class="button_box">
							<button type="button" onclick="fnAuth()" class="btn" style="margin-top:10px;">로그인</button>
						</div>
						
						<div class="login_form">
							<div class="util">
								<a href="javascript:fnReSend();" class="join"><span>입력시간 연장</span></a>
								<a href="javascript:fnInitlLink();" class="find"><span>간편인증 초기화</span></a>
							</div>
						</div>
						
						<div style="margin-top:15px;">
							간편인증 모바일앱(Smart Login)을 실행하여 주십시오.<br/>등록된 이용기관의 OTP 번호를 입력해 주십시오.<br/>휴대폰 기기 변경 및 앱을 재설치 한 경우 간편인증 초기화 후 재등록하여 주십시오.
						</div>
					</div>
					
					<div id="sms" style="display:none;">
						<div>
							<input type="text" oninput="numberMaxLength(this);" 
									style="letter-spacing:5px; font-size:1.2rem; height:60px; width:100%"
									maxlength="6" id="sms_no" placeholder="인증번호" autocomplete="off"/>
							<input type="text" id="sms_countdown" class="time" value="" disabled="disabled" />
						</div>
						
						<div style="margin-bottom:20px; margin-top:5px;">
							<span style="margin-left: 5px;">인증번호를 입력하여 주십시오.</span>
						</div>
						
						<div class="button_box">
							<button type="button" onclick="fnAuth()" class="btn" style="margin-top:10px;">로그인</button>
						</div>
						
						<div class="login_form">
							<div class="util">
								<a href="javascript:fnReSend();" class="join"><span>인증번호 재발송</span></a>
								<a href="javascript:fnInitlLink();" class="find"><span>간편인증 초기화</span></a>
							</div>
						</div>
						
						<div style="margin-top:15px;">
							간편인증 등록시 설정한 휴대톤으로 문자 메시지가 발송되었습니다.<br/>SMS로 수신한 인증번호를 입력해 주십시오.<br/>핸드폰 번호가 변경된 경우 간편인증 초기화 후 재등록하여 주십시오.
						</div>
					</div>
					
					<div id="mail" style="display:none;">
						<div>
							<input type="text" oninput="numberMaxLength(this);"
									style="letter-spacing:5px; font-size:1.2rem; height:60px; width:100%"
									maxlength="8" id="mail_no" placeholder="인증문자" autocomplete="off"/>
							<input type="text" id="mail_countdown" class="time" value="" disabled="disabled" />
						</div>
						
						<div style="margin-bottom:20px; margin-top:5px;">
							<span style="margin-left: 5px;">인증문자를 입력하여 주십시오.</span>
						</div>
						
						<div class="button_box">
							<button type="button" onclick="fnAuth()" class="btn" style="margin-top:10px;">로그인</button>
						</div>
						
						<div class="login_form">
							<div class="util">
								<a href="javascript:fnReSend();" class="join"><span>인증문자 재발송</span></a>
								<a href="javascript:fnInitlLink();" class="find"><span>간편인증 초기화</span></a>
							</div>
						</div>
						
						<div style="margin-top:15px;">
							간편인증 등록시 설정한 이메일로 메일이 발송되었습니다.<br/>EMAIL로 수신한 인증문자를 입력해 주십시오.<br/>EMAIL이 변경된 경우 간편인증 초기화 후 재등록하여 주십시오.
						</div>
					</div>
					
				</form>
			</div>
		</div>
		<p class="copy">
			<span>Copyright (c) UbiNtisLab Co., Ltd. All rights reserved.</span>
		</p>
	</div>
	
	<script type="text/javascript">
	
	var _interval;
	var _type;
	var _authflag;
	
	$(document).ready(function() {
		
		_type = '${crtfc_type}';
		_authflag = false;
		
		$('#'+_type).show();
	
		if(_type == 'push') {
			_interval = setInterval('fnAuthProc()', 3000);
			
		} else if(_type == 'motp') {
			$('#motp_no').keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
			$('#motp_no').focus();
			
		} else if(_type == 'sms') {
			$('#sms_no').keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
			$('#sms_no').focus();
			
		} else if(_type == 'mail') {
			$('#mail_no').focus();
		}
	
		$('input').keypress( function(e) {
		    if(e.keyCode == 13) {
		    	e.preventDefault();
		    	fnAuth();
		    }
		});
		
		Countdown.start(3, function() {
			alert('입력 시간이 초과되어 로그인 화면으로 이동합니다.\n\n다시 시도하여 주시기 바랍니다.');
			location.href = '<c:url value="/user/login/view"/>';
		}, _type + '_countdown', 'Y');
		
	});
	
	function numberMaxLength(e) {
		if(e.value.length > e.maxLength) {
		    e.value = e.value.slice(0, e.maxLength);
		}
	}
	
	function fnAuth() {

		if(_type == 'motp' || _type == 'sms' || _type == 'mail') {
			var crtfc_no = '';
			
			if(_type == 'motp') {
	
				if($('#motp_no').val() == '') {
					alert('OTP번호를 입력하여 주십시오.');
					$('#motp_no').focus();
					return false;
				} else {
					crtfc_no = $('#motp_no').val();
				}
				
			} else if(_type == 'sms') {
	
				if($('#sms_no').val() == '') {
					alert('인증 번호를 입력하여 주십시오.');
					$('#sms_no').focus();
					return false;
				} else {
					crtfc_no = $('#sms_no').val();
				}
				
			} else if(_type == 'mail') {
	
				if($('#mail_no').val() == '') {
					alert('인증 문자를 입력하여 주십시오.');
					$('#mail_no').focus();
					return false;
				} else {
					crtfc_no = $('#mail_no').val();
				}
			}

			fnAuthProc(crtfc_no);
		}
		
		return _authflag;
	}
	
	function fnAuthProc(crtfc_no) {
	
		$.ajax({
			url: '<c:url value="/twofactor/sln/auth"/>',
			type: 'post',
			data: {"crtfc_no": crtfc_no},
			dataType: 'json',
			async: false,
			success: function (response_data)
			{
				if(response_data.result) {
					if(_interval) {
						clearInterval(_interval);
					}
					
					fnCheckPolicy();
					
				} else {
					var errcode = response_data.error_code;
	
					if(errcode == 'ESY020') {
						
						if(_type == 'motp') {
							alert('OTP번호가 일치하지 않습니다. 확인 후 다시 입력하여 주십시오.');
							$('#motp_no').val('');
							$('#motp_no').focus();
							
						} else if(_type == 'sms') {
							alert('인증 번호가 일치하지 않습니다. 확인 후 다시 입력하여 주십시오.');
							$('#sms_no').val('');
							$('#sms_no').focus();
							
						} else if(_type == 'mail') {
							alert('인증 문자가 일치하지 않습니다. 확인 후 다시 입력하여 주십시오.');
							$('#mail_no').val('');
							$('#mail_no').focus();
						}
						
					} else if(errcode == 'ESY021') {
						alert('인증 실패 허용 횟수가 초과되어 임시 차단되었습니다. 로그인 화면으로 이동합니다.');
						location.href = '<c:url value="/user/login/view"/>';
						
					} else if(errcode == 'ESY022') {
						alert('인증 실패 허용 횟수가 초과되어 차단되었습니다. 로그인 화면으로 이동합니다.');
						location.href = '<c:url value="/user/login/view"/>';
	
					} else if(errcode == 'ESY023') {
						clearInterval(_interval);
						alert('인증 요청이 취소 되어 로그인 화면으로 이동합니다.');
						location.href = '<c:url value="/user/login/view"/>';
						
					} else {
						if(_interval) {
							clearInterval(_interval);
						}
						alert('오류가 발생하였습니다.[' + errcode + ']');
						
						location.href = '<c:url value="/user/login/view"/>';
					}
				}
			},
			error: function (request, status, error)
			{
				if(_interval) {
					clearInterval(_interval);
				}
				alert('시스템 오류가 발생하였습니다.');
				
				location.href = '<c:url value="/user/login/view"/>';
			}
		});
	}
	
	function fnReSend() {
	
		var msg = '재발송 하시겠습니까?';
		
		if(_type == 'push' || _type == 'motp') {
			msg = '시간연장 하시겠습니까?';
		}
	
		if(confirm(msg)) {
		
			$.ajax({
				url: '<c:url value="/twofactor/sln/send"/>',
				type: 'post',
				dataType: 'json',
				async: false,
				success: function (response_data)
				{
					if(response_data.result) {
						if(_type == 'sms'){
							alert('인증번호가 재전송 되었습니다.');
						} else if(_type == 'mail'){
							alert('인증문자가 재전송 되었습니다.');
						}
						
						Countdown.init();
					} else {
						var errcode = response_data.error_code;
		
						alert('오류가 발생하였습니다.[' + errcode + ']');
						
						location.href = '<c:url value="/user/login/view"/>';
					}
				},
				error: function (request, status, error)
				{
					alert('시스템 오류가 발생하였습니다.');
					
					location.href = '<c:url value="/user/login/view"/>';
				}
			});
		}
	}
	
	function fnInitlLink() {
		
		if(confirm('간편인증을 초기화 하시겠습니까?')) {
		
			var tempForm = $('<form/>', {
				'action' : '<c:url value="/twofactor/sln/link"/>',
				'method' : 'POST'
			}).append($('<input/>', {
				'type' : 'hidden',
				'name' : 'gubun',
				'value' : 'initl'
			})).append($('<input/>', {
				'type' : 'hidden',
				'name' : 'return_url',
				'value' : '${return_url}'
			})).appendTo('body');
		
			tempForm.submit().remove();
		}
	}
	
	function fnCheckPolicy() {
		
		$.ajax({
			url: '<c:url value="/user/login/check/policy"/>',
			type: 'post',
			dataType: 'json',
			async: false,
			success: function (response_data) {
				
				var code = response_data.code;
				var data = response_data.data;
				var message = loginModule.message(response_data);
	
				if(code == 'SS0001') {
					$('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();
	
				} else if(code == 'SS0007') {
					if(data == 'dupAdminBefore') {
						alert(message);
						location.href = '<c:url value="/user/login/view"/>';
						
					} else {
						if(confirm(message)){
							$('form[name=loginForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();
						} else {
							location.href = '<c:url value="/user/login/view"/>';	
						}
					}
					
				} else if(code == 'SS0004' || code == 'SS0005' || code == 'SS0006') {
					alert(message);
					$('form[name=loginForm]').attr('action', '<c:url value="/user/login/pwd/view"/>').submit();
					
				} else if(code == 'EAU016' || code == 'EAU017' || code == 'EAU018'){
					alert(message);
					location.href = '<c:url value="/user/login/view"/>';
				} else {
					alert(message);
					$('#motp_no').focus();
				}
				
			},
			error: function (xhr, error, thrown) {
				ajaxErrorHandle(xhr, error, thrown);
			}
		});
	}
	</script>

</body>
</html>