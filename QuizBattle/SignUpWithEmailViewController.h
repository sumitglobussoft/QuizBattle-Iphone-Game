//
//  SignUpWithEmailViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatDatePicker.h"

@interface SignUpWithEmailViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, FlatDatePickerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UIButton * checkMarkFirst,*checkMarkSecond,*checkMarkThird,*checkMarkFourth;
    UIImageView *imageV;
    UILabel *lblEdit;
    UITextField *txtFName;
    UITextField *txtFBirthday;
    NSData *imageData;
}
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@property(nonatomic)UICollectionView * collection;
@property (nonatomic,retain)NSMutableArray * avtarImages;

@end
