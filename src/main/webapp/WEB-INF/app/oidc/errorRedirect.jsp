<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title></title>

<style type="text/css">

</style>

<script type="text/javascript" src="<c:url value='/resources/user/js/jquery-3.6.3.min.js'/>"></script>

<script type="text/javascript">

	$(document).ready(function(){
		$('#errorForm').submit();
	});

</script>

</head>
<body>
<%
	String srvc_se = String.valueOf(request.getAttribute("srvc_se"));
	String actionUrl = String.valueOf(request.getAttribute("actionUrl"));
	String value_info = String.valueOf(request.getAttribute("value_info"));
	
	if(srvc_se.equals("iOS")){
		session.invalidate();
		actionUrl += value_info;
		response.sendRedirect(actionUrl);
	}else if(srvc_se.equals("android")){
		session.invalidate();
		response.sendRedirect("blank" + value_info);
	}


%>
<form id="errorForm" name="errorForm" method="post" action="${actionUrl}">

	<c:choose>
		<c:when test="${not empty error_info}">
			<c:forEach var="info" items="${error_info}">
				<input type="hidden" name="${info.key}" value="${info.value}" />
			</c:forEach>
		</c:when>
	</c:choose>
	
</form>

</body>
</html>