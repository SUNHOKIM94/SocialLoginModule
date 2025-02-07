<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>

<link href="<c:url value='/resources/user/images/logo/favicon.ico'/>" rel="icon" />

<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/util/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/resources/user/js/client/passninx-client-5.0.js'/>"></script>

<script type="text/javascript">

	$(function() {
		
		if('${client_use_yn}' == 'Y' && !isMobile()) {
			clientModule.set_token('${auth_tk}');
		}
		
		if('${actionUrl}' != '') {
			$('#loginForm').submit();
		
		} else {
			window.close();
			alert('로그인이 완료되었습니다. 화면을 종료해 주시기 바랍니다.');
		}
	});

</script>

</head>
<body>

<form id="loginForm" name="loginForm" method="post" action="${actionUrl}">

	<input type="hidden" name="sso_code" value="${sso_code}" />
	<input type="hidden" name="status" value="${status}"/>
	<input type="hidden" name="redirect_url" value="${redirect_url}" />
	<c:choose>
		<c:when test="${not empty agtParamMap}">
			<c:forEach var="info" items="${agtParamMap}">
				<input type="hidden" name="${info.key}" value="${info.value}" />
			</c:forEach>
		</c:when>
	</c:choose>
	
</form>

</body>
</html>