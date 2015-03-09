//
//  AddQuestionViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 9/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddQuestionViewController : UIViewController<UITextViewDelegate ,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView * imgView;
    UIImage *quesImg;
    UITextView *textVQues;
    UITextView *textVAnsA;
    UITextView *textVAnsB;
    UITextView *textVAnsC;
    UITextView *textVAnsD;
    UIScrollView *scrollView;
}


@property(nonatomic, strong) NSString *strTopic;
@end
