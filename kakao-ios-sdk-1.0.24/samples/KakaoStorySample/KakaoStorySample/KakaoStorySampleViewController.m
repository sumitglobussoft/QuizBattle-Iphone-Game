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

#import "KakaoStorySampleAppDelegate.h"
#import "KakaoStorySampleViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface KakaoStorySampleViewController ()

@property(nonatomic, strong) UIPopoverController *popover;
@property(nonatomic, retain) IBOutlet UIImageView *image;
@property(nonatomic, retain) IBOutlet UILabel *nicknameLabel;
@property(nonatomic, retain) IBOutlet UILabel *birthdayTypeLabel;
@property(nonatomic, retain) IBOutlet UILabel *birthdayLabel;
@property(nonatomic, copy) NSString *postId; // last post id

@end

@implementation KakaoStorySampleViewController

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        self.title = @"KakaoStorySample";
        self.postId = nil;
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

- (IBAction)logoutButtonClicked:(id)sender {
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [[[UIApplication sharedApplication] delegate] performSelector:@selector(showLoginView)];
    }];
}

- (IBAction)getProfileButtonClicked:(id)sender {
    [KOSessionTask storyProfileTaskWithCompletionHandler:^(KOStoryProfile *result, NSError *error) {
        if (result) {
            [self showStoryProfile:result];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)showStoryProfile:(KOStoryProfile *)profile {
    // background image
    UIImage *bgImage = [self imageWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.bgImageURL]]]
                             convertToWidth:self.view.frame.size.width];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[self imageWithImage:bgImage convertToWidth:self.view.frame.size.width]];
    [self.view insertSubview:backgroundView atIndex:0];

    // profile image
    NSString *imageURL = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? profile.thumbnailURL : profile.profileImageURL;
    [_image setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];

    // nickname
    [_nicknameLabel setText:profile.nickName];

    // birthday type
    NSString *birthdayTypeString = nil;

    switch (profile.birthdayType) {
        case KOStoryProfileBirthdayTypeSolar:
            birthdayTypeString = @"Solar";
            break;
        case KOStoryProfileBirthdayTypeLunar:
            birthdayTypeString = @"Lunar";
            break;
        default:
            birthdayTypeString = @"Unknown";
            break;
    }

    [_birthdayTypeLabel setText:birthdayTypeString];

    // birthday
    [_birthdayLabel setText:profile.birthday];

}

- (IBAction)postNoteButtonClicked:(id)sender {
    [KOSessionTask storyPostNoteTaskWithContent:@"post note test"
                                     permission:KOStoryPostPermissionFriend
                                       sharable:YES
                               androidExecParam:@{@"andParam1" : @"value1", @"andParam2" : @"value2"}
                                   iosExecParam:@{@"iosParam1" : @"value1", @"iosParam2" : @"value2"}
                              completionHandler:^(KOStoryPostInfo *post, NSError *error) {
                                  if (!error) {
                                      NSString *msg = [NSString stringWithFormat:@"Success.\r\n%@", post];
                                      self.postId = post.ID;
                                      [self alertWithTitle:@"Post Note" message:msg];
                                  } else {
                                      self.postId = nil;
                                      [self alertWithTitle:@"Post Note" message:@"Failed to post"];
                                  }
                              }];
}

- (IBAction)postPhotoButtonClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
    picker.delegate = self;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        _popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [_popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0)
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
    } else {
        [self presentModalViewController:picker animated:YES];
    }
}

// an image is selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [_popover dismissPopoverAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }

    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSMutableArray *chosenImages = [[NSMutableArray alloc] init];
    [chosenImages addObject:chosenImage];

    [KOSessionTask storyMultiImagesUploadTaskWithImages:chosenImages
                                      completionHandler:^(NSArray *imageUrls, NSError *error) {
                                          if (!error) {
                                              [KOSessionTask storyPostPhotoTaskWithImageUrls:imageUrls
                                                                                     content:@"post photo test"
                                                                                  permission:KOStoryPostPermissionFriend
                                                                                    sharable:YES
                                                                            androidExecParam:@{@"andParam1" : @"value1", @"andParam2" : @"value2"}
                                                                                iosExecParam:@{@"iosParam1" : @"value1", @"iosParam2" : @"value2"}
                                                                           completionHandler:^(KOStoryPostInfo *post, NSError *error) {
                                                                               if (!error) {
                                                                                   NSString *msg = [NSString stringWithFormat:@"Success.\r\n%@", post];
                                                                                   self.postId = post.ID;
                                                                                   [self alertWithTitle:@"Post Photo" message:msg];
                                                                               } else {
                                                                                   self.postId = nil;
                                                                                   [self alertWithTitle:@"Post Photo" message:@"Failed to post"];
                                                                               }
                                                                           }];
                                          } else {
                                              [self alertWithTitle:@"Post Photo" message:@"Failed to post"];
                                          }
                                      }];
}

- (IBAction)postLinkButtonClicked:(id)sender {
    [KOSessionTask storyGetLinkInfoTaskWithUrl:@"https://developers.kakao.com"
                             completionHandler:^(KOStoryLinkInfo *link, NSError *error) {
                                 if (!error) {
                                     [KOSessionTask storyPostLinkTaskWithLinkInfo:link
                                                                          content:@"post link test"
                                                                       permission:KOStoryPostPermissionFriend
                                                                         sharable:YES
                                                                 androidExecParam:@{@"andParam1" : @"value1", @"andParam2" : @"value2"}
                                                                     iosExecParam:@{@"iosParam1" : @"value1", @"iosParam2" : @"value2"}
                                                                completionHandler:^(KOStoryPostInfo *post, NSError *error) {
                                                                    if (!error) {
                                                                        NSString *msg = [NSString stringWithFormat:@"Success.\r\n%@", post];
                                                                        self.postId = post.ID;
                                                                        [self alertWithTitle:@"Post Link" message:msg];
                                                                    } else {
                                                                        self.postId = nil;
                                                                        [self alertWithTitle:@"Post Link" message:@"Failed to post"];
                                                                    }
                                                                }];
                                 } else {
                                     [self alertWithTitle:@"Post Link" message:@"Failed to post"];
                                 }
                             }];
}

- (IBAction)getMyStoryButtonClicked:(id)sender {
    if (self.postId == nil) {
        [self alertWithTitle:@"MyStory" message:@"Before getting MyStory, please click any post buttons such as PostNote, PostPhoto and PostLink"];
        return;
    }
    [KOSessionTask storyGetMyStoryTaskWithMyStoryId:self.postId
                                  completionHandler:^(KOStoryMyStoryInfo *myStory, NSError *error) {
                                      if (!error) {
                                          NSString *msg = [NSString stringWithFormat:@"Success.\r\n%@", myStory];
                                          [self alertWithTitle:@"MyStory" message:msg];
                                      } else {
                                          [self alertWithTitle:@"MyStory" message:@"Failed to get MyStory"];
                                      }
                                  }];
}

- (IBAction)getMyStoriesButtonClicked:(id)sender {
    if (self.postId == nil) {
        [self alertWithTitle:@"MyStories" message:@"Before getting MyStories, please click any post buttons such as PostNote, PostPhoto and PostLink"];
        return;
    }
    [KOSessionTask storyGetMyStoriesTaskWithLastMyStoryId:self.postId
                                        completionHandler:^(NSArray *myStories, NSError *error) {
                                            if (!error) {
//                                                for (KOStoryMyStoryInfo *myStory in myStories) {
//                                                    NSString *myStoryMsg = [NSString stringWithFormat:@"%@", myStory];
//                                                    [self alertWithTitle:@"MyStories" message:myStoryMsg];
//                                                    break;
//                                                }
                                                NSString *msg = [NSString stringWithFormat:@"Success.\r\n%@", myStories];
                                                [self alertWithTitle:@"MyStories" message:msg];
                                            } else {
                                                [self alertWithTitle:@"MyStories" message:@"Failed to get MyStories"];
                                            }
                                        }];
}

- (IBAction)deleteMyStoryButtonClicked:(id)sender {
    if (self.postId == nil) {
        [self alertWithTitle:@"MyStory" message:@"Before deleting MyStory, please click any post buttons such as PostNote, PostPhoto and PostLink"];
        return;
    }
    [KOSessionTask storyDeleteMyStoryTaskWithMyStoryId:self.postId
                                  completionHandler:^(NSError *error) {
                                      if (!error) {
                                          NSString *msg = [NSString stringWithFormat:@"Success."];
                                          [self alertWithTitle:@"DelMyStory" message:msg];
                                      } else {
                                          [self alertWithTitle:@"DelMyStory" message:@"Failed to delete MyStory"];
                                      }
                                  }];
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToWidth:(float)width {
    float ratio = image.size.width / width;
    float height = image.size.height / ratio;
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

@end
