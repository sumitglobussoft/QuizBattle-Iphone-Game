//
//  CustomSegmentController.m
//  QuizBattle
//
//  Created by GLB-254 on 2/24/15.
//  Copyright (c) 2015 GLB-254. All rights reserved.
//

#import "CustomSegmentController.h"

@implementation CustomSegmentController
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)drawUi:(int)segNo
{
    [self createSegUi:segNo];
    
    
}
-(void)createSegUi:(int)segNo
{
    CGFloat x;
    
    self.segButton1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 280/segNo,40)];
    self.segButton1.hidden=YES;
    [self.segButton1 setTitle:@"1" forState:UIControlStateNormal];
    [self.segButton1 setBackgroundColor:[UIColor blackColor]];
    [self addSubview:self.segButton1];
    //------
    x=self.segButton1.frame.origin.x;
    self.segButton2=[[UIButton alloc]initWithFrame:CGRectMake(x+self.segButton1.frame.size.width,0, 280/segNo,40)];
    self.segButton2.hidden=YES;
     [self.segButton2 setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.segButton2 setTitle:@"2" forState:UIControlStateNormal];
        [self addSubview:self.segButton2];
    //------
    x=self.segButton2.frame.origin.x;
    self.segButton3=[[UIButton alloc]initWithFrame:CGRectMake(x+self.segButton2.frame.size.width, 0,280/segNo,40)];
    self.segButton3.hidden=YES;
     [self.segButton3 setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.segButton3 setTitle:@"3" forState:UIControlStateNormal];
       [self addSubview:self.segButton3];
    //------
        

}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)dealloc
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
