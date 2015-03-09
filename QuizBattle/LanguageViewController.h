//
//  LanguageViewController.h
//  QuizBattle
//
//  Created by Sumit Ghosh on 04/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *pickbtn;
    NSArray *langarr;
    NSString * strSelLang;
    NSUserDefaults *userDefault;
    UILabel *chooselanguage;
    UIButton *backbtn;
    UITableView *languageTable;
    UILabel *elbl;
}
@property(nonatomic)BOOL pick;
@property(nonatomic,strong)NSArray *LanguageArray;
@end
