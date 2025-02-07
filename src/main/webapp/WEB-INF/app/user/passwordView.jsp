<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="spring" uri="/WEB-INF/tld/spring.tld" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>비밀번호 변경 | Pass-Ni SSO</title>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta name="format-detection" content="telephone=no, address=no, email=no" />
<meta name="title" content="비밀번호 변경">
<meta name="keywords" content="비밀번호 변경">
<link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon" />  
<link rel="stylesheet" href="<c:url value='/resources/user/css/base.css'/>" type="text/css" />
<link rel="stylesheet" href="<c:url value='/resources/user/css/layout.css'/>" type="text/css" />
<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>

<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/seed.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/crypto/pad-ansix923-min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/login/login.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/util/policy.js'/>"></script>
</head>
<body id="login">
	<div class="login_wrap">
		<div class="login_box">
			<div class="login_txt">
				<p>비밀번호 변경</p>
			</div>
			<div class="login_form">
				<form id="pwdForm" name="pwdForm" method="post" action="">
					<input type="hidden" id="user_data" name="user_data" value="" />
					<input type="hidden" id="login_key" name="login_key" value="${login_key}" />
					<fieldset>
						<div class="user_form pw">
							<label class="label" for="current_pwd">현재 비밀번호</label>
							<input type="password" class="text" name="current_pwd" id=current_pwd placeholder="현재 비밀번호" title="현재 비밀번호를 입력하세요" tabindex="1" autocomplete="off" />
						</div>
						<div class="user_form pw">
							<label class="label" for="new_pwd">새 비밀번호</label>
							<input type="password" class="text" name="new_pwd" id="new_pwd" placeholder="새 비밀번호" title="새 비밀번호를 입력하세요" tabindex="2" autocomplete="off" />
						</div>
						<div class="user_form pw">
							<label class="label" for="new_pwd_confirm">새 비밀번호</label>
							<input type="password" class="text" name="new_pwd_confirm" id="new_pwd_confirm" placeholder="새 비밀번호 확인" title="새 비밀번호 확인을 입력하세요" tabindex="3" autocomplete="off" />
						</div>
						<p id="password_fail" class="f_red" style="margin-top:10px; margin-bottom:20px;"></p>
						<div class="button_box">
							<button type="button" onclick="changePasswordProc()" class="btn">변경하기</button>
							<c:if test="${pwChangeLmttTy eq 'C' }">
								<button type="button" onclick="changePasswordLaterProc()" class="btn" style="margin-top:5px;">다음에 변경하기</button>
							</c:if>
						</div>
					</fieldset>
					
				</form>
				<p id="password-policy-message" class="mb10 mt10">
					<!-- 비밀번호는 9자 이상, 20자 이하<br/>
					비밀번호에 동일문자는 3회 이상 사용불가 예) aaa, 111<br/>
					비밀번호에 연속문자는 3회 이상 사용불가 예) abc, 123<br/>
					비밀번호에 영문 소문자, 숫자, 특수문자 포함 -->
				</p>
			</div>
		</div>
		<p class="copy">
			<span>Copyright (c) UbiNtisLab Co., Ltd. All rights reserved.</span>
		</p>
	</div>
	
	<script type="text/javascript">
	
		addEventListener('pageshow', (event) => {
			
			keyModule.init('<c:url value="/user/login/init"/>');
		});
	
		$(function() {
			
			$('input').keypress( function(e) {
			    if(e.keyCode == 13) {
			    	changePasswordProc();
			    }
			});
			
			var err_code = '${error_code}';
			
			if(err_code == 'EAU017') {
				alert('정상적인 요청이 아닙니다.\n로그인 화면으로 이동합니다.');
				location.href = '<c:url value="/user/login/view"/>';
				
			} else {
				
				// 정책 초기화
				var pwdPolicy = '${passwordPolicy}';
				
				PolicyValidator.initPasswordPolicy(pwdPolicy.replaceAll('&quot;', '\"'));
				$('#password-policy-message').html(PolicyValidator.getPasswordPolicyMessage('<br/>'));
				
				$('#current_pwd').focus();
			}
		});
		
		function changePasswordProc() {
			
			var response_data = pwdModule.change('<c:url value="/user/login/pwd/change"/>');
			
			if(response_data != null) {
				var code = response_data.code;
				var data = response_data.data;
				var message = pwdModule.message(response_data);
				
				if(code == 'SS0001') {
					alert(message);
					$('form[name=pwdForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();

				} else if(code == 'SS0007') {
					if( confirm( message ) ) {
						$('form[name=pwdForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();
					} else {
						location.href = '<c:url value="/user/login/view"/>';
					}
					
				} else if(code == 'EAU016' || code == 'EAU017' || code == 'EAU018') {
					alert(message);
					location.href = '<c:url value="/user/login/view"/>';
					
				} else {
					alert(message);
					$('#current_pwd').focus();
				}
			}
		}
		
		function changePasswordLaterProc() {
			
			var response_data = pwdModule.changeLater('<c:url value="/user/login/pwd/change/later"/>');
			
			if(response_data != null) {
				var code = response_data.code;
				var data = response_data.data;
				var message = pwdModule.message(response_data);
				
				if(code == 'SS0001') {
					$('form[name=pwdForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();

				} else if(code == 'SS0007') {
					if( confirm( message ) ) {
						$('form[name=pwdForm]').attr('action', '<c:url value="${sessionScope.ses_agt_login_link_url}"/>').submit();
					} else {
						location.href = '<c:url value="/user/login/view"/>';
					}
					
				} else if(code == 'EAU016' || code == 'EAU017' || code == 'EAU018') {
					alert(message);
					location.href = '<c:url value="/user/login/view"/>';
					
				} else {
					alert(message);
					$('#current_pwd').focus();
				}
			}
		}
		
	</script>

</body>
</html>