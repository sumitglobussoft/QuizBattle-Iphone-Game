//
//  SettingsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatDatePicker.h"
#import "CustomMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AboutView.h"
@class MessageCustomCell;

@protocol passingSettingDetails <NSObject>
-(void)settingDetails:(NSArray*)settingDetail;
@end


@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,FlatDatePickerDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
    UITextField * tfDisplayName;
    UITextField * tfCountry;
    UITableView * mainSettingTable;
    UISwitch * aSwitch;
    MessageCustomCell * cells;
    UIScrollView * scrollProfile;
    UIButton * btnChange;
    AVAudioPlayer *myAudioPlayer;
    UISegmentedControl  *seg;
    UITextField * tfBirthDay;
    UILabel * setBirthDay;
    NSData *imageData;
    UIActionSheet *actionSheetWallpaper;
    UIActionSheet *actionSheetImages;
    NSUserDefaults *userDefault;
    UITextField * tfTitle;
    BOOL checkMusic;
    BOOL checkSoundEffect;
    BOOL checkVibration;
    BOOL checkPrivacy;
    BOOL checkChallNoti;
    BOOL checkChatNoti;
    BOOL checkFrndNoti;
    BOOL checkAutoFrnd;
    UIAlertView *messageInitial;
    UIAlertView *messageConfirmation;
    UIView * backgroundAlertView;
    UILabel * lblReject;
    UIImageView *popUpImageview;
    UIButton * okBtn;
    //----------
    UIView *headerView;
    UIWebView * web_View;
    UIImageView * imageVAnim;
    UIView * aboutView;
    UIPickerView * myPickerView;
    NSArray * pickerArray;
    UIImage * profileImage;
    UIButton *saveButton;
}
@property(nonatomic)UICollectionView * collectionImages;
@property (nonatomic)UICollectionView * collectionWallpaper;
@property (nonatomic,retain)NSMutableArray * avtarImages,*wallPaperImages;
@property (nonatomic,assign)BOOL profile;
@property (nonatomic, weak)id<passingSettingDetails>settingDelegate;
@property(nonatomic,assign) BOOL vibrateOn_Off,musicOn_Off;
@property (assign) SystemSoundID pewPewSound;
@property(nonatomic,assign) NSMutableArray *setDetail;
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property (nonatomic) UIView * profileInfo;
@property (nonatomic) UIImageView *themeImageView;
@property (nonatomic) UIImageView *profileImageView;
@property(nonatomic)UIImagePickerController *imagePicker;
@end
