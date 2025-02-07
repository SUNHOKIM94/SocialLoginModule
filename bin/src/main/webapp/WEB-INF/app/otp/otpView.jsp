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
		position: absolute;border: 0!important;width: 60px;right: 10px;background: none;color: red;padding:0;outline:none;top:13px;font-size:1rem;
	}
	input::placeholder {
	  letter-spacing:0px;
	}
</style>

<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/seed.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/pad-ansix923-min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/login/login.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/util/countdown.js'/>"></script>
</head>
<body id="login">
	<div class="login_wrap">
		<div class="login_box">
			<div class="login_txt">
				<p>통합로그인</p>
			</div>
			<div class="login_form">
				<form id="loginForm" name="loginForm" method="post" autocomplete="off">
					<fieldset>
						<div class="user_form" style="margin-bottom:10px;">
							<input type="text" class="text" id="otp_no" name="otp_no" oninput="numberMaxLength(this);"
								style="line-height: 1.25rem;height: 60px!important;letter-spacing:5px; font-size:1.2rem;"
								maxlength="12" autocomplete="off" placeholder="OTP 번호" autofocus />
							<input type="text" id="otp_countdown" class="time" value="" disabled="disabled" />
						</div>
						<div class="button_box">
							<button type="button" onclick="loginProc()" class="btn">로그인</button>
						</div>
					</fieldset>
					
				</form>
			</div>
		</div>
		<p class="copy">
			<span>Copyright (c) UbiNtisLab Co., Ltd. All rights reserved.</span>
		</p>
	</div>
	
	<script type="text/javascript">
	
		$(function() {
			
			$('#otp_no').keyup(function(){$(this).val( $(this).val().replace(/[^0-9]/g,"") );} );
			
			$('input').keypress( function(e) {
			    if(e.keyCode == 13) {
			    	e.preventDefault();
			    	fnValidateOtpNo();
			    }
			});
			
			$('#otp_no').focus();
			
			Countdown.start(3, function() {
				alert('입력 시간이 초과되어 로그인 화면으로 이동합니다.<br/><br/>다시 시도하여 주시기 바랍니다.');
				location.href = '<c:url value="/user/login/view"/>';
			}, 'otp_countdown', 'Y');
		});
		
		function numberMaxLength(e) {
			if(e.value.length > e.maxLength) {
			    e.value = e.value.slice(0, e.maxLength);
			}
		}
		
		function fnValidateOtpNo() {
			
			$.ajax({
	    		url: '<c:url value="/twofactor/otp/ajaxValidOtpNo"/>',
	    		type: 'post',
	    		data: {otp_no : $('#otp_no').val()},
	    		dataType: 'json',
	    		async: false,
	    		success: function (response_data) {

	    			var code = response_data.code;
	    			var data = response_data.data;
	    			
	    			if( code == 'SS0001') {
						fnCheckPolicy();
						
					} else if(code == 'EAU014'){
						alert('OTP번호가 일치하지 않습니다. 확인 후 다시 입력하여 주십시오.');
						$('#otp_no').focus();
						$('#otp_no').val('');
					} else if(code == 'EAU005'){
						alert('OTP 인증 오류 횟수를 초과하여 접속이 불가합니다.[' + data + '회]');
						location.href = '<c:url value="/error/code?errorCode="/>' + code;
					} else if(code == 'EAU006'){
						alert('OTP 인증 오류 횟수를 초과하여 ' + data + '분 동안 접속이 불가합니다.');
						location.href = '<c:url value="/error/code?errorCode="/>' + code;
					} else if(code == 'EAU007'){
						alert('OTP 인증 오류 횟수를 초과하여 접속이 차단되었습니다.');
						location.href = '<c:url value="/error/code?errorCode="/>' + code;
					} else if(code == 'EAU018'){
						alert('인증 서버 시스템 세션이 만료되었습니다.\n잠시후 다시 시도하여 주십시오.');
						location.href = '<c:url value="/error/code?errorCode="/>' + code;
					} else {
						alert('인증 서버 시스템 오류가 발생하였습니다.[' + code + ']\n관리자에게 문의하시기 바랍니다.');
						location.href = '<c:url value="/error/code?errorCode="/>' + code;
					}
	    		},
	    		error: function (xhr, error, thrown) {
	    			alert('시스템 오류 발생하였습니다.[connect]\n관리자에게 문의하시기 바랍니다.');
	    			location.href = '<c:url value="/error/500"/>';
	    		}
	    	});
		}
		
		function fnCheckPolicy() {
			
			$.ajax({
	    		url: '<c:url value="/user/login/check/policy"/>',
	    		type: 'post',
	    		data: {},
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
						location.href = '<c:url value="/error/"/>' + response_code;
					} else {
						alert(message);
						$('#otp_no').focus();
					}
					
	    		},
	    		error: function (xhr, error, thrown) {
	    			alert('시스템 오류 발생하였습니다.[connect]\n관리자에게 문의하시기 바랍니다.');
	    			location.href = '<c:url value="/error/500"/>';
	    		}
	    	});
		}
	</script>

</body>
</html>