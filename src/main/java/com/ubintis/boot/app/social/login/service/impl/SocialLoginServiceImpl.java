package com.ubintis.boot.app.social.login.service.impl;

import com.ubintis.boot.app.social.field.SocialCodeField;
import com.ubintis.boot.app.social.login.dao.SocialLoginDao;
import com.ubintis.boot.app.social.login.service.SocialLoginService;
import com.ubintis.boot.connect.dbms.exception.DBMSException;
import com.ubintis.boot.sso.com.field.CodeField;
import com.ubintis.boot.sso.com.user.vo.UserVO;
import com.ubintis.boot.sso.user.app.service.UserLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class SocialLoginServiceImpl implements SocialLoginService {

	@Autowired
	private SocialLoginDao socialLoginDao;
	@Autowired
	private UserLoginService userLoginService;

	@Override
	public HashMap<String, String> findUserId( String socialLoginId, String socialLoginType ) throws DBMSException {

		HashMap<String, String> paramMap = new HashMap<>();
		HashMap<String, String> rtnMap = new HashMap<>();
		List<HashMap<String, String>> rtnListMap = new ArrayList<>();

		paramMap.put( "social_id", socialLoginId );

		switch( socialLoginType ){
		case SocialCodeField.SOCIAL_LOGIN_TYPE_KAKAO:
			rtnListMap = socialLoginDao.findKakaoUserId( paramMap );
			break;
		case SocialCodeField.SOCIAL_LOGIN_TYPE_GOOGLE:
			rtnListMap = socialLoginDao.findGoogleUserId( paramMap );
			break;
		case SocialCodeField.SOCIAL_LOGIN_TYPE_NAVER:
			rtnListMap = socialLoginDao.findNaverUserId( paramMap );
			break;
		}

		if( rtnListMap == null || rtnListMap.isEmpty() ) {
			rtnMap.put( "error_code", SocialCodeField.SOCIAL_LOGIN_REGIST );
			return rtnMap;
		}

		for( HashMap<String, String> row : rtnListMap ) {
			String userId = row.get( "user_id" );
			paramMap.put( "user_id", userId );

			rtnMap = socialLoginDao.findUserId( paramMap );

			if( rtnMap != null && !rtnMap.isEmpty() ) {

				UserVO userVO = userLoginService.findUser( rtnMap.get( "user_id" ) );

				if( userVO == null ) {
					rtnMap.put( "error_code", SocialCodeField.SOCIAL_LOGIN_REGIST );
					return rtnMap;
				}

				rtnMap.put( "user_nm", userVO.getUser_nm() );
				rtnMap.put( "error_code", CodeField.SUCCESS );

				break;
			}

		}
		return rtnMap;
	}

	@Override
	public HashMap<String, String> findSocialConfig( String socialLoginType ) throws DBMSException {

		HashMap<String, String> paramMap = new HashMap<>();

		paramMap.put( "social_login_type", socialLoginType );

		return socialLoginDao.findSocialConfig( paramMap );
	}

}
