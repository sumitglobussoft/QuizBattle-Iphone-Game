//
//  GraphView.h
//  GraphExample
//
//  Created by GBS-ios on 9/6/14.
//  Copyright (c) 2014 Globussoft. All rights reserved.
//

#define kGraphHeight 10//300
#define kDefaultGraphWidth 310//900
#define kOffsetX 40
#define kStepX 40
#define kGraphBottom 160//270
#define kGraphTop 0
#define kStepY 40
#define kOffsetY 40
#define kstartPoint 30
#define kCircleRadius 3

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic, strong) NSArray *coordinateX;
@property (nonatomic, strong) NSArray *coordinateY;


//--------------------------------------

@property (nonatomic, strong) NSArray *graphValueArray;
@property (nonatomic, strong) NSArray *lineColorArray;
@property (nonatomic, copy) UIColor *defaultColor;

//==============
-(id) initWithFrame:(CGRect)frame andDefaultLineColor:(UIColor *)lineColor;
//==========


@end
