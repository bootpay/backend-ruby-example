
require 'bootpay'

@api = Bootpay::Api.new(
  application_id: '5b8f6a4d396fa665fdc2b5ea',
  private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
)

# 1. 토큰 발급
def get_token
  response = @api.request_access_token
  if response.success?
    puts  response.data.to_json
  end
end

# 2. 결제 검증
def verification
  receipt_id = '612df0250d681b001de61de6'
  if @api.request_access_token.success?
    response = @api.verify(receipt_id)
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
        bankcode: Bootpay::BANKCODE["국민은행"] # 은행코드
      }
    )
    puts  response.data.to_json
  end
end

# 4. 빌링키 발급
def get_billing_key
  if @api.request_access_token.success?
    response = @api.get_billing_key(
      order_id:         '1234',
      pg:               'nicepay',
      item_name:        '테스트 결제',
      card_no:          '', # 값 할당 필요
      card_pw:          '', # 값 할당 필요
      expire_year:      '', # 값 할당 필요
      expire_month:     '', # 값 할당 필요
      identify_number:  '' # 값 할당 필요
    )
    puts response.data.to_json
  end
end

# 4-1. 발급된 빌링키로 결제 승인 요청
def subscribe_billing
  billing_key = '612deb53019943001fb52312'
  if @api.request_access_token.success?
    response = @api.subscribe_billing(
      billing_key:    billing_key,
      item_name:      '테스트 결제',
      price:          1000,
      tax_free:       1000,
      order_id:       '1234'
    )
    puts response.data.to_json
  end
end

# 4-2. 발급된 빌링키로 결제 예약 요청
def subscribe_reserve_billing
  billing_key = '612deb53019943001fb52312'
  if @api.request_access_token.success?
    response = @api.subscribe_reserve_billing(
      billing_key:    billing_key,
      item_name:      '테스트 결제',
      price:          1000,
      tax_free:       1000,
      order_id:       '1234',
      execute_at: (Time.now + 10.seconds).to_i # 10초 뒤 결제
    )
    puts response.data.to_json
  end
end

# 4-2-1. 발급된 빌링키로 결제 예약 - 취소 요청
def subscribe_reserve_cancel
  reserve_id = '612deb53019943001fb52312'
  if @api.request_access_token.success?
    response = @api.subscribe_reserve_cancel(reserve_id)
    puts response.data.to_json
  end
end

# 4-3. 빌링키 삭제
def destroy_billing_key
  if @api.request_access_token.success?
    billing_key = '612debc70d681b0039e6133d'
    response = @api.destroy_billing_key(billing_key)
    puts response.data.to_json
  end
end

# 5. (부트페이 단독) 사용자 토큰 발급
def get_easy_user_token
  if @api.request_access_token.success?
    response = @api.get_user_token(
      user_id: '1234',
      email: 'test@gmail.com',
      name: '테스트',
    )
    puts response.data.to_json
  end
end

# 6. (부트페이 단독) 결제 링크 생성
def request_link
  if @api.request_access_token.success?
    response = @api.request_link(
      pg:             'nicepay',
      price:          1000,
      tax_free:       1000,
      order_id:       '1234',
      name:           '결제테스트'
    )
    puts response.data.to_json
  end
end

# 7. 서버 승인 요청
def submit
  receipt_id = '612e09260d681b0021e61ab9'
  if @api.request_access_token.success?
    response = @api.server_submit(receipt_id)
    puts response.data.to_json
  end
end

# 8. 본인 인증 결과 검증
def certificate
  receipt_id = '612e09260d681b0021e61ab9'
  if @api.request_access_token.success?
    response = @api.certificate(receipt_id)
    puts response.data.to_json
  end
end


# 실행 부분
get_token
verification
cancel
get_billing_key
subscribe_billing
subscribe_reserve_billing
subscribe_reserve_cancel
destroy_billing_key
get_easy_user_token
request_link
submit
certificate