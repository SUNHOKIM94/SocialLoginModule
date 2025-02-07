package com.ubintis.boot.app.social.login.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.ubintis.boot.connect.dbms.exception.DBMSException;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;

import java.util.HashMap;

public interface SocialLoginService {

	HashMap<String, String> findUserId( String socialLoginId, String socialLoginType ) throws DBMSException;

	HashMap<String, String> findSocialConfig( String socialLoginType ) throws DBMSException;

}
