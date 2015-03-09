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

/*!
 @header KOStoryLinkInfo.h
 카카오스토리의 스크랩한 링크 정보를 담고 있는 구조체.
 */

#import <Foundation/Foundation.h>

/*!
 @class KOStoryLinkInfo
 @discussion 카카오스토리의 스크랩한 링크 정보를 담고 있는 구조체.
 */

@interface KOStoryLinkInfo : NSObject

/*!
 @property url
 @abstract 스크랩한 url
 */
@property(nonatomic, readonly) NSString *url;

/*!
 @property host
 @abstract 스크랩한 host
 */
@property(nonatomic, readonly) NSString *host;

/*!
 @property title
 @abstract 스크랩한 제목
 */
@property(nonatomic, readonly) NSString *title;

/*!
 @property image
 @abstract 스크랩한 대표 이미지 url array. 최대 3개.
 */
@property(nonatomic, readonly) NSArray *image;

/*!
 @property desc
 @abstract 스크랩한 설명
 */
@property(nonatomic, readonly) NSString *desc;


- (id)initWithUrl:(NSString *)url
             host:(NSString *)host
            title:(NSString *)title
            image:(NSArray *)image
             desc:(NSString *)desc;

@end
