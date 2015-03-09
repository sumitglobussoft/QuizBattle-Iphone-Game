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

#import "KakaoLinkSampleViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface KakaoLinkSampleViewController ()

@property(nonatomic, retain) IBOutlet UIButton *labelTypeButton;
@property(nonatomic, retain) IBOutlet UIButton *imageTypeButton;
@property(nonatomic, retain) IBOutlet UIButton *linkTypeButton;
@property(nonatomic, retain) IBOutlet UIButton *buttonTypeButton;
@property(nonatomic, retain) IBOutlet UIButton *sendButton;

@property(nonatomic, retain) NSMutableDictionary *kakaoTalkLinkObjects;
@end

@implementation KakaoLinkSampleViewController

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }

        self.kakaoTalkLinkObjects = [[NSMutableDictionary alloc] init];
        self.title = @"KakaoLinkSample";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)labelTypeButtonClicked:(id)sender {
    UIButton *button = _labelTypeButton;
    NSString *text = [[_labelTypeButton titleLabel] text];
    NSString *key = @"label";

    if ([text hasSuffix:@"[ ON ]"]) {
        [_kakaoTalkLinkObjects removeObjectForKey:key];
        [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ ON ]" withString:@"[ OFF ]"] forState:UIControlStateNormal];
        return;
    }

    // label type
    KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:@"Test Label"];
    [_kakaoTalkLinkObjects setObject:label forKey:key];
    [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ OFF ]" withString:@"[ ON ]"] forState:UIControlStateNormal];

}

- (IBAction)imageTypeButtonClicked:(id)sender {
    UIButton *button = _imageTypeButton;

    NSString *text = [[button titleLabel] text];
    NSString *key = @"image";

    if ([text hasSuffix:@"[ ON ]"]) {
        [_kakaoTalkLinkObjects removeObjectForKey:key];
        [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ ON ]" withString:@"[ OFF ]"] forState:UIControlStateNormal];
        return;
    }

    // image type
    KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:@"https://developers.kakao.com/assets/img/link_sample.jpg"
                                                            width:138
                                                           height:80];

    [_kakaoTalkLinkObjects setObject:image forKey:key];
    [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ OFF ]" withString:@"[ ON ]"] forState:UIControlStateNormal];
}

- (IBAction)linkTypeButtonClicked:(id)sender {
    UIButton *button = _linkTypeButton;
    NSString *text = [[button titleLabel] text];
    NSString *key = @"link";

    if ([text hasSuffix:@"[ ON ]"]) {
        [_kakaoTalkLinkObjects removeObjectForKey:key];
        [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ ON ]" withString:@"[ OFF ]"] forState:UIControlStateNormal];
        return;
    }

    // web link type
    KakaoTalkLinkObject *link = [KakaoTalkLinkObject createWebLink:@"Test Link"
                                                               url:@"http://www.kakao.com"];

    [_kakaoTalkLinkObjects setObject:link forKey:key];

    [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ OFF ]" withString:@"[ ON ]"] forState:UIControlStateNormal];
}

- (IBAction)buttonTypeButtonClicked:(id)sender {

    UIButton *button = _buttonTypeButton;
    NSString *text = [[button titleLabel] text];
    NSString *key = @"button";

    if ([text hasSuffix:@"[ ON ]"]) {
        [_kakaoTalkLinkObjects removeObjectForKey:key];
        [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ ON ]" withString:@"[ OFF ]"] forState:UIControlStateNormal];
        return;
    }

    [button setTitle:[text stringByReplacingOccurrencesOfString:@"[ OFF ]" withString:@"[ ON ]"] forState:UIControlStateNormal];

    // app button type
    KakaoTalkLinkAction *androidAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid
                                                                      devicetype:KakaoTalkLinkActionDeviceTypePhone
                                                                       execparam:@{@"a" : @"a", @"b" : @"2", @"c" : @"3"}];

    KakaoTalkLinkAction *iphoneAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                                                     devicetype:KakaoTalkLinkActionDeviceTypePhone
                                                                      execparam:@{@"a" : @"i", @"b" : @"2", @"c" : @"3"}];

    KakaoTalkLinkAction *ipadAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                                                   devicetype:KakaoTalkLinkActionDeviceTypePad
                                                                    execparam:@{@"a" : @"p", @"b" : @"2", @"c" : @"3"}];

    KakaoTalkLinkObject *buttonObj = [KakaoTalkLinkObject createAppButton:@"Test Button"
                                                                  actions:@[androidAppAction, iphoneAppAction, ipadAppAction]];

    [_kakaoTalkLinkObjects setObject:buttonObj forKey:key];
}

- (IBAction)sendButtonClicked:(id)sender {
    if ([_kakaoTalkLinkObjects count] < 1) {
        [self alertWithTitle:@"KakaoLinkSample" message:@"Please select"];
        return;
    }

    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        [KOAppCall openKakaoTalkAppLink:[_kakaoTalkLinkObjects allValues]];
    }
}

- (IBAction)clearButtonClicked:(id)sender {
    [_kakaoTalkLinkObjects removeAllObjects];

    NSArray *buttons = @[_labelTypeButton, _imageTypeButton, _linkTypeButton, _buttonTypeButton];

    for (UIButton *button in buttons) {
        [button setTitle:[[[button titleLabel] text] stringByReplacingOccurrencesOfString:@"[ ON ]" withString:@"[ OFF ]"] forState:UIControlStateNormal];
    }
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

@end
