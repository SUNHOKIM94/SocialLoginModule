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

<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/login/login.js'/>"></script>
</head>
<body id="login">
	<form id="loginForm" name="loginForm" method="post" autocomplete="off">
	</form>
	
	<script type="text/javascript">
	
	$(document).ready(function() {
		fnCheckPolicy();
	});

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