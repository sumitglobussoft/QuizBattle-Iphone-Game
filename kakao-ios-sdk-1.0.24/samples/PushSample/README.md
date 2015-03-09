
# PushSample 앱 실행 주의사항

------------------------------------------------------------------
------------------------------------------------------------------

## 실제 iOS 기기에서 실행해야 합니다.

PushSample 앱을 제대로 실행하기 위해서는 반드시 **실제 iOS Device에서 실행**해야 합니다.

만약 시뮬레이터에서 실행하게 되면 다음과 같은 문제들이 발생합니다.
- Push Notification용 Device Token 발급 불가
- Push 수신 불가


------------------------------------------------------------------

## 현재 APNS Development(a.k.a Sandbox) 인증서는 지원하지 않습니다. 

현재 [Kakao Developers_](https://developers.kakao.com)에서 Push 설정 시, APNS Production용 인증서만 설정 가능합니다. (추후 지원 예정)

현재 APNS Production용 인증서만 가능하다보니 기기에서 작동시키기 위해서 Build 시 Code Signing을 Developer가 아닌, Distribution으로 하셔야 합니다.

------------------------------------------------------------------

## Sample App 구동을 위한 TODO 요약

### [Apple Developer](https://developer.apple.com)에서 할 일
- [Apple Developer](https://developer.apple.com)에서 앱 등록
- Push Notification 설정에서 Production SSL 인증서 추가
- Distribution(Ad Hoc) Provisioning Profile 생성

### [Kakao Developers_](https://developers.kakao.com)에서 할 일
- 앱 생성(혹은 수정)
- iOS 플랫폼 추가 후 Bundle Identifier를 적절하게 입력
- Push 사용 여부 Enable
- APNS Production SSL 인증서 등록

### Sample App 수정
- Bundle Identifier 수정
- KAKAO_APP_KEY 속성 수정
- URL scheme 수정
- Build Settings > code signing 섹션에서 code signing에 사용할 인증서와 provisioning profile을 적절하게 선택