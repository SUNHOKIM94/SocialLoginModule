<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<title>사용자 정보제공 동의</title>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<meta name="format-detection" content="telephone=no, address=no, email=no" />
	<meta name="title" content="사용자 정보제공 동의">
	<meta name="keywords" content="사용자 정보제공 동의">
	<link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon" />  
	<link rel="stylesheet" href="<c:url value='/resources/user/css/base.css'/>" type="text/css" />
	<link rel="stylesheet" href="<c:url value='/resources/user/css/layout.css'/>" type="text/css" />
	
</head>
<body id="login">

	<div class="login_wrap">
		<div class="login_box">
			<div class="login_txt">
				<p>사용자 정보제공 동의</p>
			</div>
			<div class="login_form">
				<form id="loginForm" name="loginForm" method="post" action="">
					<input type="hidden" id="agt_id" name="agt_id" value="${agt_id}" />
					<input type="hidden" id="after_url" name="after_url" value="${after_url}" />
					${agt_nm} 에서 ${user_id}님의 개인정보에 접근하는 것에 동의하십니까?<br/>
					제공된 정보는 이용자 식별, 통계, 계정 연동 및 CS 등을 위해 서비스 이용기간 동안 활용/보관됩니다.<br/>
					기본정보 및 필수 제공항목은 Application서비스를 이용하기 위해 반드시 제공되어야 할 정보입니다.<br/><br/>
					
					<font style="font-weight: bold;font-size: 18px;">기본정보</font><br/>
					-이용자 고유 식별자<br/><br/>
					
					<font style="font-weight: bold;font-size: 18px;">필수 제공 항목</font><br/>
					-이메일<br/>
					-등등<br/><br/>
					<div class="button_box">
						<button type="button" onclick="agree()" class="btn">동의</button>
					</div>
					<div class="button_box" style="margin-top:10px;">
						<button type="button" onclick="cancel()" class="btn">취소</button>
					</div>
				</form>
			</div>
		</div>
		<p class="copy">
			<span>Copyright (c) UbiNtisLab Co., Ltd. All rights reserved.</span>
		</p>
	</div>
	
	<div id="member-login-desc">
		
	</div>
	
	<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
	
	<script type="text/javascript">
		
		$(document).ready(function(){
			
			var err_code = '${error_code}';
			if( err_code != '' ) {
				alert(err_code);
			}
			
		});
		
		function agree() {
			
			$('form[name=loginForm]').attr('action', '<c:url value="/user/oidc/login/usrInfoAgree"/>').submit();
		}
		
		function cancel() {
			location.href = '<c:url value="${redirect_uri}?error=user_cancel"/>';
		}
		
	</script>
</body>
</html>