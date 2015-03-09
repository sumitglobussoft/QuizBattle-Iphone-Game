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

#import "PushSampleViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "PushSampleAppDelegate.h"

typedef enum {
    MENU_SHOW_DEVICE_TOKEN,
    MENU_REGISTER_DEVICE_TOKEN,
    MENU_DEREGISTER_CURRENT_DEVICE,
    MENU_DEREGISTER_ALL_DEVICE,
    MENU_SEND_PUSH,
    MENU_GET_PUSH_TOKENS,

    MENU_LOGOUT,

    MENU_COUNT
} MENU_ENUM;


@interface PushSampleViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PushSampleViewController {
    UITableView *_tableView;
    NSArray *_menuTitles;
}

#pragma mark - default

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    [self initMenuTitles];
    [self initTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods 

- (void)initMenuTitles {
    _menuTitles = @[@"Device Token 확인하기",
            @"Device Token 등록하기",
            @"Device Token 등록 해제",
            @"모든 디바이스 등록 해제",
            @"Push 전송",
            @"Push 토큰 정보들 얻기",
            @"로그 아웃"];

}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
            0,
            self.view.frame.size.width,
            self.view.frame.size.height)];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return MENU_COUNT;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Cell 캐싱 안 함

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:nil];

    NSInteger row = indexPath.row;
    cell.textLabel.text = _menuTitles[(NSUInteger) row];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;

    switch (row) {
        case MENU_SHOW_DEVICE_TOKEN : {
            [self invokeShowDeviceToken];
            break;
        }
        case MENU_REGISTER_DEVICE_TOKEN: {
            [self invokeRegisterDeviceToken];
            break;
        }
        case MENU_DEREGISTER_CURRENT_DEVICE : {
            [self invokeDeregisterCurrentDevice];
            break;
        }
        case MENU_DEREGISTER_ALL_DEVICE : {
            [self invokeDeregisterAllDevice];
            break;
        }
        case MENU_SEND_PUSH : {
            [self invokeSend];
            break;
        }
        case MENU_GET_PUSH_TOKENS:
            [self invokeGetPushTokens];
            break;
        case MENU_LOGOUT : {
            [self invokeLogout];
            break;
        }

        default:
            break;
    }

}


#pragma mark - menu actions

- (void)invokeShowDeviceToken {
    NSData *deviceToken = [(PushSampleAppDelegate *) [[UIApplication sharedApplication] delegate] deviceToken];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device Token"
                                                    message:[deviceToken description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];

    [alert show];

}

- (void)invokeRegisterDeviceToken {

    NSData *deviceToken = [(PushSampleAppDelegate *) [[UIApplication sharedApplication] delegate] deviceToken];

    [KOSessionTask pushRegisterDeviceWithToken:deviceToken
                             completionHandler:^(BOOL success, NSInteger expiredAt, NSError *error) {

                                 NSString *msg = success ?
                                         [NSString stringWithFormat:@"[성공] Device Token 유효기간 %d일 남음", expiredAt] :
                                         [error description];

                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Push Token"
                                                                                 message:msg
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];

                                 [alert show];
                             }];

}

- (void)invokeDeregisterCurrentDevice {

    NSData *deviceToken = [(PushSampleAppDelegate *) [[UIApplication sharedApplication] delegate] deviceToken];

    [KOSessionTask pushDeregisterDeviceWithToken:deviceToken
                               completionHandler:^(BOOL success, NSError *error) {
                                   NSString *msg = success ?
                                           @"토큰 삭제 완료" :
                                           [error description];

                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deregister Push Token"
                                                                                   message:msg
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];

                                   [alert show];
                               }];

}

- (void)invokeDeregisterAllDevice {

    [KOSessionTask pushDeregisterAllDeviceWithCompletionHandler:
            ^(BOOL success, NSError *error) {
                NSString *msg = success ?
                        @"모든 기기 토큰 삭제 완료" :
                        [error description];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deregister ALL Push Token"
                                                                message:msg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];

                [alert show];
            }];

}

- (void)invokeSend {

    NSDictionary *customField = @{@"key1" : @"value1", @"key2" : @"value2"};

    KakaoPushMessagePropertyForApns *forApns = [[KakaoPushMessagePropertyForApns alloc] initWithBadgeCount:10
                                                                                                     sound:@"default"
                                                                                                 pushAlert:YES
                                                                                             messageString:@"푸시 잘 갑니까?"
                                                                                               customField:customField];

    KakaoPushMessagePropertyForGcm *forGcm = [[KakaoPushMessagePropertyForGcm alloc] initWithCollapse:@"collapse_id_1234"
                                                                                       delayWhileIdle:NO
                                                                                            returnUrl:@"http://www.example.com/test"
                                                                                          customField:customField];

    KakaoPushMessageObject *pushMsg = [[KakaoPushMessageObject alloc] initWithApnsProperty:forApns
                                                                               gcmProperty:forGcm];

    [KOSessionTask pushSendMsg:pushMsg
             completionHandler:^(BOOL success, NSError *error) {
                 NSString *msg = success ?
                         @"푸시 전송 성공!" :
                         [error description];

                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Push Msg"
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];

                 [alert show];
             }];

}

- (void)invokeGetPushTokens {
    [KOSessionTask pushGetTokensTaskWithCompletionHandler:^(NSArray *tokens, NSError *error) {
        NSString *msg;
        if (!error) {
            msg = [NSString stringWithFormat:@"succeeded to get push tokens. tokens=%@", tokens];
        } else {
            msg = [error description];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Push Tokens"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)invokeLogout {

    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {

        PushSampleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate showLoginView];

    }];

}

@end
