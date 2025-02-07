<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>   
<%@page import="com.ubintis.crypto.*"%>  
<%@page import="com.ubintis.crypto.jni.*"%> 
<%
PniccJNI pnicc = new PniccJNI();
String strVer = pnicc.GetVersion();
String strCMVPVer = pnicc.GetCMVPVersion();

int state = pnicc.GetModuleState();
String reInit = "no Re-InitializeAPI ";
// 오류상태인경우 암호모듈 다시 초기화
if(state == PniccJNI.MODULE_STATE_ERROR || state == PniccJNI.MODULE_STATE_LOADED)
{
	pnicc.FinalizeAPI();
	int nRet = pnicc.InitializeAPI();
	if (nRet == PniccJNI.SUCCESS) {
		reInit = "Re-InitializeAPI SUCCESS";
	}
	else {
		reInit = "Re-InitializeAPI FAILED";
	}
}

state = pnicc.GetModuleState();
String strState = "";
switch(state) {
case PniccJNI.MODULE_STATE_NOT_LOADED: strState = "MODULE_STATE_NOT_LOADED"; break;
case PniccJNI.MODULE_STATE_ERROR: strState = "MODULE_STATE_ERROR"; break;
case PniccJNI.MODULE_STATE_LOADED: strState = "MODULE_STATE_LOADED"; break;
case PniccJNI.MODULE_STATE_FINALIZE: strState = "MODULE_STATE_FINALIZE"; break;
case PniccJNI.MODULE_STATE_INITIALIZE: strState = "MODULE_STATE_INITIALIZE"; break;
case PniccJNI.MODULE_STATE_POWER_UP_SELFTEST: strState = "MODULE_STATE_POWER_UP_SELFTEST"; break;
case PniccJNI.MODULE_STATE_CONDITIONAL_SELFTEST: strState = "MODULE_STATE_CONDITIONAL_SELFTEST"; break;
case PniccJNI.MODULE_STATE_VERIFIED_SERVICE: strState = "MODULE_STATE_VERIFIED_SERVICE"; break;
default: strState = String.valueOf(state) ; break;
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PniccJNI Re-instailize</title>
</head>
<body>
PniccJNI Version: <%=strVer %></br>
CMVP: <%=strCMVPVer %></br>
State: <%= strState%></br>
reInit: <%= reInit %>
</body>
</html>