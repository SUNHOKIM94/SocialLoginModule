<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String agt_id = request.getParameter( "agt_id" );
	String agt_url = request.getParameter( "agt_url" );
	
	session.setAttribute( "ses_agt_prtcl_type", "TOKEN" );
	session.setAttribute( "ses_agt_id", agt_id );
	session.setAttribute( "ses_agt_url", agt_url );
	session.setAttribute( "ses_agt_login_link_url", "/user/login/link" );
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PniccJNI module state</title>
</head>
<body>
	test
</body>
</html>
