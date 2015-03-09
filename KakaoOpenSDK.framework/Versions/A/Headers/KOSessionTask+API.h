/**
* Copyright 2014 Kakao Corp.
*
* Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


#import "KakaoPushMessageObject.h"
#import "KOSessionTask.h"
/*!
 @header KOSessionTask+API.h
 인증된 session 정보를 바탕으로 각종 API를 호출할 수 있습니다.
 */

/*!
 인증된 session 정보를 바탕으로 각종 API를 호출할 수 있습니다.
 */
@interface KOSessionTask (API)

/*!
 @abstract KOStoryPostPermission 스토리 포스팅 공개 범위
 @constant KOStoryPostPermissionPublic 전체공개
 @constant KOStoryPostPermissionFriend 친구공개
 @constant KOStoryPostPermissionOnlyMe 나만보기
 */
typedef NS_ENUM(NSInteger, KOStoryPostPermission) {
    KOStoryPostPermissionPublic = 0,
    KOStoryPostPermissionFriend,
    KOStoryPostPermissionOnlyMe
};


#pragma mark - KakaoTalk

/*!
 @abstract 현재 로그인된 사용자의 카카오톡 프로필 정보를 얻을 수 있습니다.
 @param completionHandler 카카오톡 프로필 정보를 얻어 처리하는 핸들러
 @discussion
 */
+ (instancetype)talkProfileTaskWithCompletionHandler:(KOSessionTaskCompletionHandler)completionHandler;


@end
