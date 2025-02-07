package com.ubintis.boot.app.social.login.dao;

import com.ubintis.boot.connect.dbms.DBManager;
import com.ubintis.boot.connect.dbms.db.DBConnector;
import com.ubintis.boot.connect.dbms.exception.DBMSException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public class SocialLoginDao {

	@Autowired
	private DBManager dbManager;

	public HashMap<String, String> findSocialConfig( HashMap<String, String> param ) throws DBMSException {

		return dbManager.selectOne( "com.ubintis.boot.app.social.login.dao.config", param, HashMap.class, DBConnector.USER_POOLNAME );
	}

	public List<HashMap<String, String>> findKakaoUserId( HashMap<String, String> param ) throws DBMSException {

		return dbManager.selectList( "com.ubintis.boot.app.social.login.dao.find.kakao.user.id", param, HashMap.class, DBConnector.USER_POOLNAME );
	}

	public List<HashMap<String, String>> findGoogleUserId( HashMap<String, String> param ) throws DBMSException {

		return dbManager.selectList( "com.ubintis.boot.app.social.login.dao.find.google.user.id", param, HashMap.class, DBConnector.USER_POOLNAME );
	}

	public List<HashMap<String, String>> findNaverUserId( HashMap<String, String> param ) throws DBMSException {

		return dbManager.selectList( "com.ubintis.boot.app.social.login.dao.find.naver.user.id", param, HashMap.class, DBConnector.USER_POOLNAME );
	}

	public HashMap<String, String> findUserId( HashMap<String, String> param ) throws DBMSException {

		return dbManager.selectOne( "com.ubintis.boot.app.social.login.dao.find.social.id", param, HashMap.class, DBConnector.USER_POOLNAME );
	}

}
