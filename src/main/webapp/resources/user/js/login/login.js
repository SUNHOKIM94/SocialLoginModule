
var _login_key;
var _passni_key;
var _passni_iv;

var keyModule = (function () {
	
	var server_url;

	function fn_set_login_key() {
		
		$.ajax({
			url: server_url,
			type: 'post',
			dataType: 'json',
			async: false,
			success: function (responseData)
			{
				var login_key = responseData.result_data;
					
				_passni_key = CryptoJS.enc.Hex.parse(login_key.substring(0, 64));
				_passni_iv = CryptoJS.enc.Hex.parse(login_key.substring(64, 96));
				
				_login_key = login_key;
			},
			error: function ()
			{
				alert('시스템 오류 발생하였습니다.[connect]\n관리자에게 문의하시기 바랍니다.');
			}
		});
	}
	
	return {
		
		init: function(url) {
			server_url = url;
			
			fn_set_login_key();
		}
	};
	
})();

function fn_encrypt_data(data) {

	var byte_data = CryptoJS.SEED.encrypt(data, _passni_key, {
		iv : _passni_iv,
		mode : CryptoJS.mode.CBC,
		padding : CryptoJS.pad.AnsiX923
	});

	var encrypt_data = byte_data.ciphertext.toString();
	
	return encrypt_data;
}

function fn_server_request(url, req_data) {
	
	var obj_data;
	
	$.ajax({
		url: url,
		type: 'post',
		data: req_data,
		dataType: 'json',
		async: false,
		success: function (responseData)
		{
			obj_data = responseData;
		},
		error: function ()
		{
			alert('시스템 오류 발생하였습니다.[connect]\n관리자에게 문의하시기 바랍니다.');
		}
	});
	
	return obj_data;
}

var loginModule = (function () {
	
	return {
		
		auth: function(url) {
			
			if(!_passni_key || _passni_key == '' || !_passni_iv || _passni_iv == '') {
				alert('시스템 오류가 발생하였습니다.[key]\n관리자에게 문의하시기 바랍니다.');
				return null;
			}
			
			var login_id = $.trim( $('#login_id').val() );
			var login_pwd = $.trim( $('#login_pwd').val() );
			
			if(login_id == '') {
				alert('아이디를 입력하여 주십시오.');
				$('#login_id').focus();
				return null;
			}
			
			if(login_pwd == '') {
				alert('비밀번호를 입력하여 주십시오.');
				$('#login_pwd').focus();
				return null;
			}
			
			$('#login_id').val('');
			$('#login_pwd').val('');
			
			var jsonObj = {'login_id':login_id,'login_pwd':login_pwd};
			var jsonStr = JSON.stringify( jsonObj );
			
			var user_data = fn_encrypt_data( jsonStr );
			
			var req_data = 'user_data=' + user_data;
			
			var obj_data = fn_server_request( url, req_data );
			
			return obj_data;
		},
		
		message: function(response_data) {
				
			var code = response_data.code;
			var value = '';
			var message = '아이디 또는 비밀번호가 올바르지 않습니다.';
			
			if(code == 'SS0004') {
				message = '최초 로그인 하여 비밀번호 변경화면으로 이동합니다.\n비밀번호를 변경하여 주십시오.';
				
			} else if(code == 'SS0005') {
				message = '초기화된 비밀번호를 사용하여 비밀번호 변경화면으로 이동합니다.\n비밀번호를 변경하여 주십시오.';
				
			} else if(code == 'SS0006') {
				value = response_data.data;
				message = '오래된 비밀번호를 사용하고 있어 비밀번호 변경화면으로 이동합니다.\n비밀번호를 변경하여 주십시오.';
				
			} else if(code == 'SS0007') {
				value = response_data.data;
				
				if(value == 'dupAdminAfter') {
					message = '동일한 권한을 소유한 관리자가 접속중입니다.\n접속중인 관리자의 접속을 종료하고 계속 진행하시겠습니까?';
				} else if(value == 'dupAdminBefore') {
					message = '전체 관리자 권한을 소유한 관리자가 접속중입니다.\n접속중인 관리자가 로그아웃 후 접속이 가능합니다.';
				} else {
					message = '[' + value + '] IP 에서 접속중인 계정입니다.\n이전 접속을 종료하고 계속 진행하시겠습니까?';
				}
				
			} else if(code == 'EAU001') {
				//message = '아이디가 올바르지 않습니다.';
			} else if(code == 'EAU002') {
				//message = '비밀번호가 올바르지 않습니다.';
				
			} else if(code == 'EAU003') {
				message = '접속 기간이 시작전이거나 만료되었습니다.';
				
			} else if(code == 'EAU004') {
				message = '접속 가능한 아이피 정보가 아닙니다.';
				
			} else if(code == 'EAU005') {
				value = response_data.data;
				//message = '비밀번호 오류 횟수를 초과하여 접속이 불가합니다.[' + value + '회]';
				
			} else if(code == 'EAU006') {
				value = response_data.data;
				//message = '비밀번호 오류 횟수를 초과하여 ' + value + '분 동안 접속이 불가합니다.';
				
			} else if(code == 'EAU007') {
				//message = '비밀번호 오류 횟수를 초과하여 접속이 차단되었습니다.';
				
			} else if(code == 'EAU016') {
				message = '정상적인 접근 경로가 아닙니다.[' + code + ']\n잠시후 다시 시도하여 주십시오.';
				
			} else if(code == 'EAU017') {
				message = '정상적인 접근 경로가 아닙니다.[' + code + ']\n잠시후 다시 시도하여 주십시오.';
				
			} else if(code == 'EAU018') {
				message = '인증 서버 시스템 세션이 만료되었습니다.\n잠시후 다시 시도하여 주십시오.';
				
			} else if(code == 'EOP001') {
				message = '해당 시스템에 대한 접속 권한이 없습니다.\n\n관리자에게 문의하시기 바랍니다.';
				
			} else {
				message = '인증 서버 시스템 오류가 발생하였습니다.[' + code + ']\n관리자에게 문의하시기 바랍니다.';
			}
			
			return message;
		}
	};
	
})();

var pwdModule = (function () {
	
	return {
		
		change: function(url) {
			
			if(!_passni_key || _passni_key == '' || !_passni_iv || _passni_iv == '') {
				alert('시스템 오류가 발생하였습니다.[key]\n관리자에게 문의하시기 바랍니다.');
				return null;
			}
			
			var current_pwd = $.trim( $('#current_pwd').val() );
			var new_pwd = $.trim( $('#new_pwd').val() );
			var new_pwd_confirm = $.trim( $('#new_pwd_confirm').val() );
			
			if(current_pwd == '') {
				alert('현재 비밀번호를 입력하여 주십시오.');
				$('#current_pwd').focus();
				return null;
			}
			
			if(new_pwd == '') {
				alert('새 비밀번호를 입력하여 주십시오.');
				$('#new_pwd').focus();
				return null;
			}
			
			if(new_pwd_confirm == '') {
				alert('새 비밀번호 확인을 입력하여 주십시오.');
				$('#new_pwd_confirm').focus();
				return null;
			}
			
			// 패스워드 정책 체크
			var checkResult = PolicyValidator.checkPasswordPolicy('new_pwd', 'new_pwd_confirm', 'current_pwd');

			if(!checkResult.flag ) {
				alert(checkResult.message);

				$(this).blur();
				$('#new_pwd').focus();

				return null;
			}
			
			$('#current_pwd').val('');
			$('#new_pwd').val('');
			$('#new_pwd_confirm').val('');
			
			var jsonObj = {'current_pwd':current_pwd,'new_pwd':new_pwd};
			var jsonStr = JSON.stringify( jsonObj );
			
			var user_data = fn_encrypt_data( jsonStr );
			
			var req_data = 'user_data=' + user_data;
			
			var obj_data = fn_server_request( url, req_data );
			
			return obj_data;
		},
		
		changeLater: function(url) {
			
			$('#current_pwd').val('');
			$('#new_pwd').val('');
			$('#new_pwd_confirm').val('');
			
			var req_data = 'user_data=' + _login_key;
			
			var obj_data = fn_server_request( url, req_data );
			
			return obj_data;
		},
		
		message: function(response_data) {
			
			var code = response_data.code;
			var value = '';
			var message = '';
			
			if(code == 'SS0001') {
				message = '비밀번호가 정상적으로 변경되었습니다.';
				
			} else if( code == 'SS0007' ) {
				value = response_data.data;
				
				if( value == 'dupAdminAfter' ) {
					message = '비밀번호가 정상적으로 변경되었습니다.\n동일한 권한을 소유한 관리자가 접속중입니다.\n접속중인 관리자의 접속을 종료하고 계속 진행하시겠습니까?';
				} else if( value == 'dupAdminBefore' ) {
					message = '비밀번호가 정상적으로 변경되었습니다.\n전체 관리자 권한을 소유한 관리자가 접속중입니다.\n접속중인 관리자가 로그아웃 후 접속이 가능합니다.';
				} else {
					message = '비밀번호가 정상적으로 변경되었습니다.\n[' + value + '] IP 에서 접속중인 계정입니다.\n이전 접속을 종료하고 계속 진행하시겠습니까?';
				}
				
			} else if(code == 'EAU010') {
				message = '사용자 정보가 없습니다.';
				
			} else if(code == 'EAU011') {
				message = '현재 비밀번호가 올바르지 않습니다.';
				
			} else if(code == 'EAU012') {
				message = '이전에 사용한 비밀번호 입니다.';
				
			} else if(code == 'EAU016') {
				message = '정상적인 접근 경로가 아닙니다.[' + code + ']\n잠시후 다시 시도하여 주십시오.';
				
			} else if(code == 'EAU017') {
				message = '정상적인 접근 경로가 아닙니다.[' + code + ']\n잠시후 다시 시도하여 주십시오.';
				
			} else if(code == 'EAU018') {
				message = '인증 서버 시스템 세션이 만료되었습니다.\n잠시후 다시 시도하여 주십시오.';
				
			} else {
				message = '인증 서버 시스템 오류가 발생하였습니다.[' + code + ']\n관리자에게 문의하시기 바랍니다.';
			}
			
			return message;
		}
	};

})();
