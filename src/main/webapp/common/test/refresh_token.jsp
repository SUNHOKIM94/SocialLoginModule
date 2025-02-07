<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Insert title here</title>
</head>
<body>
<%
	String clientId = "oidc_test";//애플리케이션 클라이언트 아이디값";
	String client_secret = "7F779F125DFD1F45A0C185A7314BCEDA6AB30AE7FA11B66A2846025A7BDCCCB8";//애플리케이션 클라이언트 비밀값";
    String refresh_token = request.getParameter("refresh_token");
	
	
	
	String apiURL;
    apiURL = "https://nsso.passni.com:9443/sso/user/oidc/api/token?grant_type=refresh_token";
    apiURL += "&refresh_token=" + refresh_token;
    apiURL += "&client_id=" + clientId;
    apiURL += "&client_secret=" + client_secret;
    String result = "";
	
	try{
		URL url = new URL(apiURL);
		HttpURLConnection con = null;

		con = (HttpURLConnection)url.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("User-Agent", request.getHeader( "User-Agent" ));
		
		int responseCode = con.getResponseCode();
		BufferedReader br;
		
		if(responseCode==200) { // 정상 호출
			br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else {  // 에러 발생
			br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		}
		String inputLine;
		StringBuffer res = new StringBuffer();
		while ((inputLine = br.readLine()) != null) {
			res.append(inputLine);
		}
		br.close();
		if(responseCode==200) {
			result = res.toString();
		}
	} catch (Exception e) {
		System.out.println(e);
		e.printStackTrace();
	}


	
 %>

	<form>
		result : <%=result%></br>
	</form>
</body>
</html>