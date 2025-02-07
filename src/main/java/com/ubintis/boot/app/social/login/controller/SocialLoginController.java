package com.ubintis.boot.app.social.login.controller;

import com.ubintis.boot.app.social.login.service.SocialLoginService;
import com.ubintis.boot.common.util.ClientUtil;
import com.ubintis.boot.common.util.StrUtil;
import com.ubintis.boot.connect.dbms.exception.DBMSException;
import com.ubintis.boot.sso.com.audit.AuditManager;
import com.ubintis.boot.sso.com.field.CodeField;
import com.ubintis.boot.sso.com.session.ComUserSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;

@Controller
@RequestMapping( "/social/login" )
public class SocialLoginController {

	@Autowired
	private ComUserSession comUserSession;
	@Autowired
	private SocialLoginService socialLoginService;
	@Autowired
	private AuditManager auditManager;

	/*
	소셜로그인 인증
	 */
	@RequestMapping( "/auth" )
	public String auth( HttpServletRequest request ) throws DBMSException {

		HashMap<String, String> rtnMap = new HashMap<>();
		String socialLoginId = StrUtil.NVL( request.getParameter( "user_id" ) );
		String socialLoginType = StrUtil.NVL( request.getParameter( "user_type" ) );
		String userIp = ClientUtil.getIp( request );
		String userBrowser = ClientUtil.getBrowser( request );
		String errorCode = "";
		String userId = "";
		String userNm = "";
		if( "".equals( socialLoginId ) || "".equals( socialLoginType ) ) {
			errorCode = CodeField.ERR_PARAMETER_DATA;
			return "redirect:/error/code?errorCode=" + errorCode;
		}

		rtnMap = socialLoginService.findUserId( socialLoginId, socialLoginType );

		errorCode = StrUtil.NVL( rtnMap.get( "error_code" ) );

		if( errorCode.equals( CodeField.SUCCESS ) ) {
			userId = StrUtil.NVL( rtnMap.get( "user_id" ) );
			userNm = StrUtil.NVL( rtnMap.get( "user_nm" ) );

			auditManager.setUserOpertLog( request, userId, userNm, errorCode );
			comUserSession.setLogin( request, userId, userNm, userIp, userBrowser );
		} else {
			auditManager.setUserOpertLog( request, userId, userNm, errorCode );
			return "redirect:/user/login/view?error_code=" + errorCode;
		}

		return "redirect:/user/login/link";
	}

}
