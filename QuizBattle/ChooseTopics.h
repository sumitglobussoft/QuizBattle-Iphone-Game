//
//  ChooseTopics.h
//  QuizBattle
//
//  Created by GLB-254 on 10/13/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"
@interface ChooseTopics : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,passingGameDetails>
{
    UISearchBar * pickCategory;
    UISearchDisplayController * displayCategory;
    UITableView * chooseTopicTable;
    UIImageView *imageVAnim;
    NSString *challengeReqObjId;
    UIButton * start,* startGame,*cancel;
    UIImageView * iconImg,* themImgView,* profileImgView;
    UIView * topViewChallenge;
    UIImageView * imgViewMobile;
    UILabel * description;
    NSMutableDictionary * dictForChallenege;
    CGFloat width,height;
}
@property(nonatomic,strong)NSArray * arrData;
@end
