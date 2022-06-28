
require 'bootpay-backend-ruby'

@api = Bootpay::RestClient.new(
  application_id: '5b8f6a4d396fa665fdc2b5ea',
  private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
)

# 1. (부트페이 통신을 위한) 토큰 발급
def get_token
  response = @api.request_access_token
  if response.success?
    puts  response.data.to_json
  end
end

 

# 2. 결제 단건 조회 
def get_payment
  receipt_id = '612df0250d681b001de61de6'
  if @api.request_access_token.success?
    response = @api.receipt_payment(
      "62a818cf1fc19203154a8f2e"
    )
    puts  response.data.to_json
  end
end

# 3. 결제 취소 (전액 취소 / 부분 취소)
def cancel
  if @api.request_access_token.success?
    response = @api.cancel_payment(
      receipt_id:      "612df0250d681b001de61de6",
      cancel_username:        'test',
      cancel_message:         'test',
      cancel_price:     1000, # 부분취소 요청시
      refund: { # 가상계좌 환불 요청시, 단 CMS 특약이 되어있어야만 환불요청이 가능하다.
        account: '675601010124', # 환불계좌
        accountholder: '홍길동', # 환불계좌주
        bankcode: "국민" # 은행코드
      }
    )
    puts  response.data.to_json
  end
end

# 4-1. 빌링키 발급
def get_billing_key
  if @api.request_access_token.success?
    response = @api.request_subscribe_billing_key(
      subscription_id:         '1234',
      pg:               '나이스페이',
      order_name:        '테스트 결제',
      card_no:          '', # 카드번호 16자리 
      card_pw:          '', # 카드 비밀번호 2자리 
      card_expire_year:      '', # 카드 유효기간 2자리 
      card_expire_month:     '', # 카드 유효기간 2자리
      card_identity_no:  '' # 생년월일 6자리 
    )
    puts response.data.to_json
  end
end

# 4-2. 발급된 빌링키로 결제 승인 요청
def subscribe_billing
  if @api.request_access_token.success?
    response = @api.request_subscribe_card_payment(
      billing_key:    '612deb53019943001fb52312',
      order_name:     '테스트 결제',
      price:          1000,
      tax_free:       1000,
      order_id:       Time.current.to_i
    )
    puts response.data.to_json
  end
end

# 4-3. 발급된 빌링키로 결제 예약 요청
def subscribe_reserve_billing
  billing_key = '612deb53019943001fb52312'
  if @api.request_access_token.success?
    response = @api.subscribe_payment_reserve( 
      billing_key:        '628c0d0d1fc19202e5ef2866',
      order_name:         '테스트결제',
      price:              1000,
      order_id:           Time.current.to_i,
      user:               {
        phone:    '01000000000',
        username: '홍길동',
        email:    'test@bootpay.co.kr'
      },
      reserve_execute_at: (Time.current + 30.seconds).iso8601
    )
    puts response.data.to_json
  end
end

# 4-4. 발급된 빌링키로 결제 예약 - 취소 요청
def subscribe_reserve_cancel
  if @api.request_access_token.success?
    response = @api.cancel_subscribe_reserve('612deb53019943001fb52312')
    puts response.data.to_json
  end
end

# 4-5. 빌링키 삭제
def destroy_billing_key
  if @api.request_access_token.success?
    response = @api.destroy_billing_key('612debc70d681b0039e6133d')
    puts response.data.to_json
  end
end


# 4-6. 빌링키 조회
def destroy_billing_key
  if @api.request_access_token.success?
    response = @api.lookup_subscribe_billing_key('612debc70d681b0039e6133d')
    puts response.data.to_json
  end
end

# 5. (생체인증, 비밀번호 결제를 위한) 구매자 토큰 발급
def get_easy_user_token
  if @api.request_access_token.success?
    response = @api.request_user_token(
      user_id: '1234',
      email: 'test@gmail.com',
      username: '홍길동',
    )
    puts response.data.to_json
  end
end

# 6. 서버 승인 요청
def server_confirm 
  if @api.request_access_token.success?
    response = @api.confirm_payment('612e09260d681b0021e61ab9')
    puts response.data.to_json
  end
end

# 7. 본인 인증 결과 조회
def certificate
  if @api.request_access_token.success?
    response = @api.certificate('612e09260d681b0021e61ab9')
    puts response.data.to_json
  end
end


# 8. (에스크로 이용시) PG사로 배송정보 보내기
def shipping_start 
  if @api.request_access_token.success?
    response = @api.shipping_start(
    receipt_id:      "62a818cf1fc19203154a8f2e",
    tracking_number: '123456',
    delivery_corp:   'CJ대한통운',
    user:            {
      username: '강훈',
      phone:    '01095735114',
      address:  '경기도 화성시 동탄기흥로 277번길 59',
      zipcode:  '08490'
    }
  )
  print response.data.to_json
  end
end

# 실행 부분
get_token
get_payment
cancel
get_billing_key
subscribe_billing
subscribe_reserve_billing
subscribe_reserve_cancel
destroy_billing_key
get_easy_user_token 
server_confirm
certificate
shipping_start