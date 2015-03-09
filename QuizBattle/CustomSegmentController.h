//
//  CustomSegmentController.h
//  QuizBattle
//
//  Created by GLB-254 on 2/24/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentController : UIView
{
    
}
-(void)drawUi:(int)segNo;
@property(nonatomic,strong)UIButton * segButton1;
@property(nonatomic,strong)UIButton * segButton2;
@property(nonatomic,strong)UIButton * segButton3;
@end
