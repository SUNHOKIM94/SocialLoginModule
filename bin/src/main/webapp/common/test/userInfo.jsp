<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

<%
	// 사용자 정보 요청을 위한 접근 토큰
    String access_token = nvl(request.getParameter("access_token"));
	String userInfo = "";
	if( !access_token.equals("") ){
			
		String url = "https://nsso.passni.com:9443/sso/user/oidc/api/userInfo";
		
		userInfo = callApi(url, access_token);
		
		if(userInfo != null){
			System.out.println("userInfo : " + userInfo);	
		} else {
			// HTTP 상태코드가 200이 아닌 경우
		}
		
	} else {
		// 유효하지 않은 요청
	}
	
 %>
 
<%!
	public String nvl( Object o ) {
		if( o == null ) {
			return "";
		} else {
			return ( String.valueOf( o ) ).trim();
		}
	}

	public String callApi(String api_url, String access_token){
		
		try{
			URL url = new URL(api_url);
			
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			// Authorization: Bearer [접근 토큰] 형식으로 헤더에 포함 
			con.setRequestProperty("Authorization", "Bearer " + access_token);
			
			int responseCode = con.getResponseCode();
			BufferedReader br;
			
			if(responseCode==200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				
				String inputLine;
				StringBuffer res = new StringBuffer();
				
				while ((inputLine = br.readLine()) != null) {
					res.append(inputLine);
				}
				
				br.close();
				
				return res.toString();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
%>

<!DOCTYPE html>
<html>
<body>
userInfo : <%=userInfo %>
</body>
</html>