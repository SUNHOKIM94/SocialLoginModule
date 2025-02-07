// 클라이언트 URL
var CLIENT_URL = 'https://127.0.0.1:49443/serverapi?method=';

// 클라이언트 버전
var CLIENT_VERSION = '5.0';

// 클라이언트에서 로그인 체크(초)
var LOGIN_CHECK_INTERVAL = '0';

// 클라이언트 설치 URL
var INSTALL_URL = '/common/client/install.jsp?link_url=';

var SERVER_ID = 'sso-server';

var NX_FILE_NAME = 'passninx50_setup.exe';

var clientModule = (function() {
	
	var context_path;

	function clientInit(req_data) {

		var res_data = fn_request(CLIENT_URL + 'init', req_data);

		if(res_data != 'error') {
			
			if(res_data.result == 'S001') {
				
				if(parseFloat(CLIENT_VERSION) > parseFloat(res_data.version)) {
					// 설치 페이지로 이동(업그레이드)
					alert("Pass-Ni NX Client가 업그레이드 되었습니다.\n\n설치 페이지로 이동합니다.");
					openInstallPage();
				}

			} else {
				// 오류 발생
				alert('Pass-Ni NX Client에 오류가 발생하였습니다.[' + res_data.result + ']\n\n잠시 후 다시 시도하여 주시기 바랍니다.');
			}

		} else {
			// 설치 페이지로 이동(신규)
			alert('Pass-Ni NX Client가 미설치 되었습니다.\n\n설치 페이지로 이동합니다.');
			openInstallPage();
		}

		return;
	}
	
	function openInstallPage() {
		
		var link_url = window.location.href;
		
		try {
			top.location.href = context_path + INSTALL_URL + link_url;
				
		} catch(e) {}
	}
	
	function setClientToken(req_data) {
		
		var res_data = fn_request(CLIENT_URL + 'set_token', req_data);
		
		if(res_data != 'error') {
			
			if(res_data.result == 'S001') {
				return true;
			}
		}
		
		console.error('setClientToken : ' + res_data);
		
		return false;
	}
	
	function getClientToken(req_data) {
		
		var res_data = fn_request(CLIENT_URL + 'get_token', req_data);
		
		if(res_data != 'error') {
			
			if(res_data.result == 'S001') {
				return res_data.data;
			}
		}
		
		console.error('getClientToken : ' + res_data);
		
		return '';
	}
	
	function clientSSO(req_data) {
		
		var res_data = fn_request(CLIENT_URL + 'sso', req_data);
		
		if(res_data != 'error') {
			
			if(res_data.result == 'S001') {
				return true;
			}
		}
		
		console.error('clientSSO : ' + res_data);
		
		return false;
	}
	
	function clientLogout(req_data) {
		
		var res_data = fn_request(CLIENT_URL + 'logout', req_data);
		
		if(res_data != 'error') {
			
			if(res_data.result == 'S001') {
				return true;
			}
		}
		
		console.error('clientLogout : ' + res_data);
		
		return false;
	}
	
	function fn_request(url, req_data) {

		var res_data;

		$.ajax({
			url : url,
			type : 'post',
			contentType : 'application/x-www-form-urlencoded; charset=utf-8',
			data : req_data,
			dataType : 'json',
			async : false,
			success : function(responseData) {
				res_data = responseData;
			},
			error : function(request, status, error) {
				console.error('code:' + request.status + ', message:' + request.responseText + ', error:' + error);
				
				res_data = 'error';
			}
		});

		return res_data;
	}
	
	function fn_context_path() {

		var hostIndex = location.href.indexOf(location.host)
				+ location.host.length;
		var context = location.href.substring(hostIndex, location.href.indexOf(
				'/', hostIndex + 1));

		if (context == '/user') {
			context_path = '';
		} else {
			context_path = context;
		}
	}
	
	return {
		
		init : function(server_url, client_secret) {
			
			fn_context_path();
			
			var req_data = '';
			req_data += 'server_id=' + SERVER_ID;
			req_data += '&api_url=' + server_url + '/api';
			req_data += '&client_secret=' + client_secret;
			
			clientInit(req_data);
		},
		
		set_token : function(auth_tk) {
			var req_data = '';
			req_data += 'server_id=' + SERVER_ID;
			req_data += '&auth_tk=' + auth_tk;
			req_data += '&check_interval=' + LOGIN_CHECK_INTERVAL;
			
			return setClientToken(req_data);
		},
		
		get_token : function() {
			var req_data = 'server_id=' + SERVER_ID;
			
			return getClientToken(req_data);
		},
		
		sso : function(agt_id) {
			var req_data = '';
			req_data += 'server_id=' + SERVER_ID;
			req_data += '&agt_id=' + agt_id;
			
			return clientSSO(req_data);
		},
		
		logout : function(agt_ids) {
			var req_data = '';
			req_data += 'server_id=' + SERVER_ID;
			req_data += '&agt_ids=' + agt_ids;
			
			return clientLogout(req_data);
		}
	};
	
})();
