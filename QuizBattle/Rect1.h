//
//  Rect.h
//  DemoPie
//
//  Created by GLB-254 on 10/6/14.
//  Copyright (c) 2014 globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rect1 : UIView
{
    NSArray * displayXp;
    float totalPoints_GameOver;
    NSString *gradeNameIngraph;
    float sum;
}
@property (nonatomic) BOOL flagProfile;
@property (nonatomic,strong) NSNumber * totalScoreOfAllPoints;
@property (nonatomic, strong) NSArray * subcategoryId,*subcategoryName;
@property (nonatomic, strong) NSArray * points,*winGainStatus,*totalScore;
@end
