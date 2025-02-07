package com.ubintis.boot.app.social.login.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.ubintis.boot.app.social.field.SocialCodeField;
import com.ubintis.boot.app.social.login.service.SocialLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.HashMap;
import java.util.stream.Collectors;

@Controller
@RequestMapping( "/google" )
public class GoogleLoginController {

	@Autowired
	private SocialLoginService socialLoginService;

	@RequestMapping( "/oidc/view" )
	public void oidcView( HttpServletRequest request, HttpServletResponse response ) throws Exception {

		String socialLoginType = SocialCodeField.SOCIAL_LOGIN_TYPE_GOOGLE;
		HashMap<String, String> rtnMap = socialLoginService.findSocialConfig( socialLoginType );

		String client_id = rtnMap.get( "google_client_id" );
		String callback_url = rtnMap.get( "google_callback_url" );
		String login_link = rtnMap.get( "google_login_link" );
		String response_type = rtnMap.get( "google_response_type" );

		String authUrl = login_link + "?client_id=" + client_id + "&redirect_uri=" + callback_url + "&response_type=" + response_type + "&scope=openid%20email";
		response.sendRedirect( authUrl );

	}

	@RequestMapping( "/oidc/auth" )
	public String oidcAuth( HttpServletRequest request, HttpServletResponse response ) throws Exception {

		String code = request.getParameter( "code" );

		// 1. Authorization Code를 사용하여 ID Token 요청
		String tokenResponse = getTokenFromGoogle( code );
		String idToken = extractIdToken( tokenResponse );

		// 2. ID Token에서 이메일 추출
		String email = extractEmailFromIdToken( idToken );

		return "redirect:/social/login/auth?user_id=" + email + "&user_type=" + SocialCodeField.SOCIAL_LOGIN_TYPE_GOOGLE;
	}

	private String getTokenFromGoogle( String code ) throws Exception {

		String socialLoginType = SocialCodeField.SOCIAL_LOGIN_TYPE_GOOGLE;
		HashMap<String, String> rtnMap = socialLoginService.findSocialConfig( socialLoginType );

		String client_id = rtnMap.get( "google_client_id" );
		String callback_url = rtnMap.get( "google_callback_url" );
		String client_secret = rtnMap.get( "google_client_secret" );
		String access_url = rtnMap.get( "google_access_url" );

		String urlParameters = "code=" + code + "&client_id=" + client_id + "&client_secret=" + client_secret + "&redirect_uri=" + callback_url + "&grant_type=authorization_code";

		HttpURLConnection conn = ( HttpURLConnection )new URL( access_url ).openConnection();
		conn.setRequestMethod( "POST" );
		conn.setDoOutput( true );
		conn.getOutputStream().write( urlParameters.getBytes() );

		try( BufferedReader reader = new BufferedReader( new InputStreamReader( conn.getInputStream() ) ) ) {
			return reader.lines().collect( Collectors.joining() );
		}
	}

	private String extractIdToken( String tokenResponse ) {

		JsonObject json = JsonParser.parseString( tokenResponse ).getAsJsonObject();
		return json.get( "id_token" ).getAsString();
	}

	private String extractEmailFromIdToken( String idToken ) throws Exception {

		String socialLoginType = SocialCodeField.SOCIAL_LOGIN_TYPE_GOOGLE;
		HashMap<String, String> rtnMap = socialLoginService.findSocialConfig( socialLoginType );

		String return_type = rtnMap.get( "google_return_type" );

		String[] parts = idToken.split( "\\." );
		String payload = new String( Base64.getUrlDecoder().decode( parts[1] ) );
		JsonObject json = JsonParser.parseString( payload ).getAsJsonObject();
		return json.get( return_type ).getAsString();
	}

}
