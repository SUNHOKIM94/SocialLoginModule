<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

<%
	// SSO에서 발급받은 [CLIENT_ID]
	String client_id = "oidc_test";

	// SSO에서 발급받은 [CLIENT_SECRET]
	String client_secret = "7F779F125DFD1F45A0C185A7314BCEDA6AB30AE7FA11B66A2846025A7BDCCCB8";
	
	// URL Encode된 콜백 URL. 로그인 요청시 전송한 콜백 URL과 동일해야 한다.
	String redirect_uri = URLEncoder.encode("https://nsso.passni.com:9443/sso/common/test/callback.jsp");
	
	// 코드 발급 성공시 전달되는 코드값
    String code = nvl(request.getParameter("code"));
	
	// 코드 발급 성공시 전달되는 state값(CSRF 공격을 방지하기 위해 로그인 요청시 보냈던 랜덤값과 일치한지 비교한다.)
	String state = nvl(request.getParameter("state"));
	
	// 로그인 요청시 세션에 저장했던 state값
	//String ses_state = nvl(session.getAttribute("state"));
	String ses_state = "bbb";
	
	// 코드 발급 실패시 전달되는 에러 코드
	String error = nvl(request.getParameter("error"));
	
	String tokenInfo = "";
	
	System.out.println("error : " + error);
	if( error.equals("") ){
		System.out.println("ses_state : " + ses_state + ", state : " + state);	
		if(!"".equals(ses_state) && state.equals(ses_state)){
			// 토큰 (발급/갱신/삭제) URL (https://[SERVER_URL]/sso/usr/oauth/api/token)
			String url = "https://nsso.passni.com:9443/sso/user/oidc/api/token";
			url += "?grant_type=authorization_code";
			url += "&client_id=" + client_id;
			url += "&client_secret=" + client_secret;
			url += "&redirect_uri=" + redirect_uri;
			url += "&code=" + code;

			tokenInfo = callApi(url);

			if(tokenInfo != null){
				System.out.println("tokenInfo : " + tokenInfo);
			} else {
				// HTTP 상태코드가 200이 아닌 경우
			}
		} else {
			// 유효하지 않은 요청
		}
	} else {
		//에러코드에 따른 처리
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

	public String callApi(String api_url){
		
		try{
			URL url = new URL(api_url);
			
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			
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
tokenInfo : <%=tokenInfo %>
</body>
</html>
