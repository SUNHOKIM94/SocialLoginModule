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
			agtClientLogout();	
		}
		
		agtWebLogout();
		
		agtWebPostLogout();
		
		<c:choose>
			<c:when test="${not empty SAMLResponse}">
				// saml redirect
				$('#logoutForm').submit();
			</c:when>
			<c:otherwise>
				location.href = '${actionUrl}';
			</c:otherwise>
		</c:choose>
	});
	
	function agtClientLogout() {
		
		var agt_ids = '${agtClientData}';
		
		clientModule.logout(agt_ids);
	}
	
	function agtWebLogout() {
		
		<c:if test="${not empty agtWebList}">
			<c:forEach var="url" items="${agtWebList}">
				sendLogout('${url}');
			</c:forEach>
		</c:if>
	}
	
	function agtWebPostLogout() {
		
		var url = '';
		var SAMLRequest = '';
		var RelayState = '';
		
		<c:if test="${not empty agtWebPostList}">
			<c:forEach var="postMap" items="${agtWebPostList}">
				url = '${postMap.request_url}';
				SAMLRequest = '${postMap.SAMLRequest}';
				RelayState = '${postMap.RelayState}';
			
				sendPostLogout(url, SAMLRequest, RelayState);
			</c:forEach>
		</c:if>
	}
	
	function sendLogout(url) {

		$.ajax({
			url : url,
			type: 'get',
			contentType : 'application/x-www-form-urlencoded; charset=utf-8',
			async: true,
			crossDomain: true,
			xhrFields:{
				withCredentials:true
			},
			success : function( result ) {
				console.log(result);
			},
			error : function(request, status, error) {
				console.error('code:' + request.status + ', message:' + request.responseText + ', error:' + error);
			}
		});
	}
	
	function sendPostLogout(url, SAMLRequest, RelayState) {

		$.ajax({
			url : url,
			type: 'post',
			data: { "SAMLRequest" : SAMLRequest , "RelayState" : RelayState},
			contentType : 'application/x-www-form-urlencoded; charset=utf-8',
			async: true,
			crossDomain: true,
			xhrFields:{
				withCredentials:true
			},
			success : function( result ) {
				console.log(result);
			},
			error : function(request, status, error) {
				console.error('code:' + request.status + ', message:' + request.responseText + ', error:' + error);
			}
		});
	}

</script>

</head>
<body>

	<form id="logoutForm" name="logoutForm" method="post" action="${actionUrl}">
		<input type="hidden" name="SAMLResponse" value="${SAMLResponse}" />
		<input type="hidden" name="RelayState" value="${RelayState}" />
		
	</form>

</body>
</html>