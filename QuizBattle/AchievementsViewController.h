//
//  AchievementsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementsViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger pointIntValue;
    NSString *gradeplyr;
}
@property(nonatomic)UICollectionView * collection;
@property(nonatomic,retain)UIImageView * achivementImage;
@property(nonatomic,retain)NSArray *achivementImageName,*achievementDetail,*achivementName;
@end
