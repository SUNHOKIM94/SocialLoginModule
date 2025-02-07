var PolicyValidator = {
	// password 정책
	pw_size_yn:'N',
	pw_size_min:1,
	pw_size_max:30,
	pw_incls_upper_yn:'N',
	pw_incls_lower_yn:'N',
	pw_incls_num_yn:'N',
	pw_incls_spcl_yn:'N',
	pw_same_yn:'N',
	pw_same_num:0,
	pw_ctnu_yn:'N',
	pw_ctnu_num:0,
	pw_kybrd_ctnu_yn:"N",
	pw_kybrd_ctnu_num:0,
	pw_change_same_limit_yn:'N',
	pw_change_same_limit_num:0,

	// password 정책 메시지
	pw_size_message:'비밀번호는 1자 이상, 99자 이하',
	pw_incls_prefix:'비밀번호에 ',
	pw_incls_upper_message:'영문 대문자',
	pw_incls_lower_message:'영문 소문자',
	pw_incls_num_message:'숫자',
	pw_incls_spcl_message:'특수문자',
	pw_incls_suffix:' 포함 ',
	pw_same_message:'비밀번호는 동일문자 0회 이상 사용불가',
	pw_ctnu_message:'비밀번호는 연속문자 0회 이상 사용불가',
	pw_kybrd_ctnu_message:'비밀번호는 키보드 배열 연속 0회 이상 사용불가',
	pw_change_same_limit_message:'이전에 사용한 비밀번호는 사용불가',
	pw_confirm_message:'비밀번호와 비밀번호 확인은 동일하게 입력해야 합니다.',
	pw_prev_same_message:'현재 비밀번호와 같은 비밀번호는 사용할 수 없습니다.',
	
	msg_01:' 여야 합니다.',
	msg_02:' 합니다.',
	msg_03:'가 포함 되어야 합니다.',

	initPasswordPolicy: function(passwordPolicyJsonStr)
	{
		if ( passwordPolicyJsonStr != null && passwordPolicyJsonStr != 'null' )
		{
			
			var passwordPolicy = JSON.parse(passwordPolicyJsonStr);
			
			this.pw_size_yn = passwordPolicy.pw_size_yn;
			this.pw_size_min = passwordPolicy.pw_size_min;
			this.pw_size_max = passwordPolicy.pw_size_max;
			this.pw_incls_upper_yn = passwordPolicy.pw_incls_upper_yn;
			this.pw_incls_lower_yn = passwordPolicy.pw_incls_lower_yn;
			this.pw_incls_num_yn = passwordPolicy.pw_incls_num_yn;
			this.pw_incls_spcl_yn = passwordPolicy.pw_incls_spcl_yn;
			this.pw_same_yn = passwordPolicy.pw_same_yn;
			this.pw_same_num = passwordPolicy.pw_same_num;
			this.pw_ctnu_yn = passwordPolicy.pw_ctnu_yn;
			this.pw_ctnu_num = passwordPolicy.pw_ctnu_num;
			this.pw_kybrd_ctnu_yn = passwordPolicy.pw_kybrd_ctnu_yn;
			this.pw_kybrd_ctnu_num = passwordPolicy.pw_kybrd_ctnu_num;
			this.pw_change_same_limit_yn = passwordPolicy.pw_change_same_limit_yn;
			this.pw_change_same_limit_num = passwordPolicy.pw_change_same_limit_num;

			this.pw_size_message = '비밀번호는 ' + this.pw_size_min + '자 이상, ' + this.pw_size_max + '자 이하';
			this.pw_same_message = '비밀번호는 동일문자 ' + this.pw_same_num + '회 이상 사용불가';
			this.pw_ctnu_message = '비밀번호는 연속문자 ' + this.pw_ctnu_num + '회 이상 사용불가';
			this.pw_kybrd_ctnu_message = '비밀번호는 키보드 배열 연속 ' + this.pw_kybrd_ctnu_num + '회 이상 사용불가';
		}
	},

	checkPasswordPolicy: function(passwordInputId, passwordConfirmInputId, passwordPrevInputId)
	{
		var returnObj = {};

		var passwordValue = document.getElementById(passwordInputId).value;
		var passwordConfirmElement = document.getElementById(passwordConfirmInputId);
		var passwordPrevElement = document.getElementById(passwordPrevInputId);

		if ( passwordPrevElement && passwordPrevElement.value == passwordValue )
		{
			returnObj.flag = false;
			returnObj.message = this.pw_prev_same_message;

			return returnObj;
		}

		if ( passwordConfirmElement && !(passwordConfirmElement.value == passwordValue) )
		{
			returnObj.flag = false;
			returnObj.message = this.pw_confirm_message;

			return returnObj;
		}

		if ( this.pw_size_yn == 'Y' )
		{
			var passwordValueLength = passwordValue.length;

			if ( passwordValueLength < this.pw_size_min || passwordValueLength > this.pw_size_max )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_size_message + this.msg_01;

				return returnObj;
			}
		}

		if ( this.pw_incls_upper_yn == 'Y' )
		{
			var upperPattern = /^.*(?=.*[A-Z]).*$/;

			if ( !upperPattern.test(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_incls_prefix + this.pw_incls_upper_message + this.msg_03;

				return returnObj;
			}
		}

		if ( this.pw_incls_lower_yn == 'Y' )
		{
			var lowerPattern = /^.*(?=.*[a-z]).*$/;

			if ( !lowerPattern.test(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_incls_prefix + this.pw_incls_lower_message + this.msg_03;

				return returnObj;
			}
		}

		if ( this.pw_incls_num_yn == 'Y' )
		{
			var numberPattern = /^.*(?=.*\d).*$/;

			if ( !numberPattern.test(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_incls_prefix + this.pw_incls_num_message + this.msg_03;

				return returnObj;
			}
		}

		if ( this.pw_incls_spcl_yn == 'Y' )
		{
			var specialPattern = /^.*(?=.*[!@#$%^&\*\(\)_\-+=`~\\\|\[\]\{\}\;\:\'\"\,\.\<\>\/\?]).*$/;

			if ( !specialPattern.test(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_incls_prefix + this.pw_incls_spcl_message + this.msg_03;

				return returnObj;
			}
		}
		
		if ( this.pw_same_yn == 'Y' )
		{
			if( !this.checkSameCount(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_same_message + this.msg_02;

				return returnObj;
			}
		}

		if ( this.pw_ctnu_yn == 'Y' )
		{
			if( !this.checkContinueCount(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_ctnu_message + this.msg_02;

				return returnObj;
			}
		}
		
		if (this.pw_kybrd_ctnu_yn == 'Y')
		{
			if( !this.checkKeyboardContinueCount(passwordValue) )
			{
				returnObj.flag = false;
				returnObj.message = this.pw_kybrd_ctnu_message + this.msg_02;

				return returnObj;
			}
		}

		returnObj.flag = true;

		return returnObj;
	},

	getPasswordPolicyMessage: function(lineSeperator)
	{
		var message = '';

		if ( this.pw_size_yn == 'Y' )
		{
			message += (message=='' ? '' : lineSeperator) + this.pw_size_message;
		}

		var inclsMessage = '';

		if ( this.pw_incls_upper_yn == 'Y' )
		{
			inclsMessage += (inclsMessage=='' ? this.pw_incls_prefix : ', ') + this.pw_incls_upper_message;
		}

		if ( this.pw_incls_lower_yn == 'Y' )
		{
			inclsMessage += (inclsMessage=='' ? this.pw_incls_prefix : ', ') + this.pw_incls_lower_message;
		}

		if ( this.pw_incls_num_yn == 'Y' )
		{
			inclsMessage += (inclsMessage=='' ? this.pw_incls_prefix : ', ') + this.pw_incls_num_message;
		}

		if ( this.pw_incls_spcl_yn == 'Y' )
		{
			inclsMessage += (inclsMessage=='' ? this.pw_incls_prefix : ', ') + this.pw_incls_spcl_message;
		}

		if ( inclsMessage!='' )
		{
			inclsMessage += this.pw_incls_suffix;
			message += (message=='' ? '' : lineSeperator) + inclsMessage;
		}
		
		if ( this.pw_same_yn == 'Y' )
		{
			message += (message=='' ? '' : lineSeperator) + this.pw_same_message + ' ex) aaa, 111';
		}

		if ( this.pw_ctnu_yn == 'Y' )
		{
			message += (message=='' ? '' : lineSeperator) + this.pw_ctnu_message + ' ex) abc, 123';
		}
		
		if ( this.pw_kybrd_ctnu_yn == 'Y' )
		{
			message += (message=='' ? '' : lineSeperator) + this.pw_kybrd_ctnu_message + ' ex) qwer, asdf';
		}
		
		if ( this.pw_change_same_limit_yn == 'Y' )
		{
			message += (message=='' ? '' : lineSeperator) + this.pw_change_same_limit_message;
		}

		return message;
	},
	
	checkPwSize: function(value)
	{
		if(this.pw_size_yn == 'Y') {
			var pwValueLength = value.length;

			if(pwValueLength < this.pw_size_min || pwValueLength > this.pw_size_max) {
				return false;
			}
		}
		
		return true;
	},
	
	checkPwInclsUpper: function(value)
	{
		if(this.pw_incls_upper_yn == 'Y') {
			var upperPattern = /^.*(?=.*[A-Z]).*$/;

			if(!upperPattern.test(value)) {
				return false;
			}	
		}
		
		return true;
	},
	
	checkPwInclsLower: function(value)
	{
		if(this.pw_incls_lower_yn == 'Y') {
			var lowerPattern = /^.*(?=.*[a-z]).*$/;

			if(!lowerPattern.test(value)) {
				return false;
			}
		}
		
		return true;
	},
	
	checkPwInclsNum: function(value)
	{
		if(this.pw_incls_num_yn == 'Y') {
			var numberPattern = /^.*(?=.*\d).*$/;

			if(!numberPattern.test(value)) {
				return false;
			}
		}
		
		return true;
	},
	
	checkPwInclsSpcl: function(value)
	{
		if( this.pw_incls_spcl_yn == 'Y' ) {
			var specialPattern = /^.*(?=.*[!@#$%^&\*\(\)\+=`~\\\|\[\]\{\}\;\:\'\"\,\<\>\/\?_\-.]).*$/;
			if(!specialPattern.test(value)) {
				return false;
			}
		}
		
		return true;
	},
	
	checkSameCount: function (passwordStr)
	{
		var cnt_same=0;
		var max_conut=0;

		for (var t=0; t < passwordStr.length-1; t++)
		{
			if ( passwordStr.substring(t,(t+1)) == passwordStr.substring((t+1),(t+2)) )
			{
				cnt_same++;
			}
			else
			{
				if ( cnt_same > max_conut )
				{
					max_conut = cnt_same;
				}

				cnt_same=0;
			}
		}

		if( cnt_same > max_conut ) {
			max_conut = cnt_same;
		}

		if( (max_conut + 1) >= this.pw_same_num ) {
			return false;
		} else {
			return true;
		}
	},

	checkContinueCount: function (passwordStr)
	{
		var count = 0;
		var max_cnt = 0;

		for (var t=0; t < passwordStr.length-1; t++)
		{
			if ( passwordStr.charCodeAt(t) == (passwordStr.charCodeAt(t+1)-1) )
			{
				count++;
			}
			else
			{
				if ( count > max_cnt )
				{
					max_cnt = count;
				}

				count = 0;
			}
		}

		if ( count > max_cnt )
			max_cnt = count;

		if( (max_cnt + 1) >= this.pw_ctnu_num ) {
			return false;
		} else {
			return true;
		}
	},
	
	checkKeyboardContinueCount: function (passwordStr)
	{
		if ( this.pw_kybrd_ctnu_yn == 'Y' ){
			var keyboard = ['1234567890', 'qwertyuiop', 'asdfghjkl', 'zxcvbnm', '0987654321', 'poiuytrewq', 'lkjhgfdsa', 'mnbvcxz', '!@#$%^&*()_+', '+_)(*&^%$#@!'];
			
			var flag = true;
			
			for (var t = 0; t < passwordStr.length - this.pw_kybrd_ctnu_num + 1; t++) {
				var sliceValue = passwordStr.substring(t, t + this.pw_kybrd_ctnu_num);
				
				// 모든 조건을 한번씩 순회
				if (keyboard.some((code) => code.includes(sliceValue))) {
					flag = false;
					break;
				}
			}
			
			return flag;
		}
		
		return true;
	}

};