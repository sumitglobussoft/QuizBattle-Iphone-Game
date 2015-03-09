//
//  GraphView.m
//  GraphExample
//
//  Created by GBS-ios on 9/6/14.
//  Copyright (c) 2014 Globussoft. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize defaultColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.defaultColor = [UIColor blackColor];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andDefaultLineColor:(UIColor *)lineColor{
    
    self = [super initWithFrame:frame];
    if (self){
        self.defaultColor = lineColor;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    CGContextMoveToPoint(context, kstartPoint, 0);
    CGContextAddLineToPoint(context, kstartPoint, kGraphBottom);
    
    CGContextAddLineToPoint(context, self.frame.size.width, kGraphBottom);
    CGContextStrokePath(context);
    CGContextSaveGState(context);
    
    
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);

    //======================================
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    //changed from gray
    // How many lines?
    int howMany = 7;//(kDefaultGraphWidth - kOffsetX) / kStepX;
    
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context,30+ kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, 30+kOffsetX + i * kStepX, kGraphBottom);
    }
    
    
    //-------------------------
    int howManyHorizontal = 3;//(kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, 30, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    CGContextStrokePath(context);
    CGContextSaveGState(context);
    //========================================
   
    [self drawCoordinateXWithContext:context];
    [self drawCoordinateYWithContext:context];
    
    //==================
    
    for (int i =0; i < self.graphValueArray.count; i++) {
     
        NSArray *valueArray = [self.graphValueArray objectAtIndex:i];
        UIColor *color = self.defaultColor;
        
        if (self.lineColorArray.count>i) {
            color = [self.lineColorArray objectAtIndex:i];
        }
        
        [self drawLineGraphWithContext:context andValues:valueArray andColor:color];
        
    }
    
}

#pragma mark -
//Set X Coodinate

-(void) drawCoordinateXWithContext:(CGContextRef)context{
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    for (int i =0; i<self.coordinateX.count; i++) {
        int a = i+1;
        float x =  a*kStepX+28;
        CGMutablePathRef path = CGPathCreateMutable();
//        CGRect textFrame = CGRectMake(x, kGraphBottom + 13, 30, 20);
        CGRect textFrame = CGRectMake(x, kGraphBottom+16, 30, 20);
        CGPathAddRect(path, NULL, textFrame);
        NSAttributedString* attString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[self.coordinateX objectAtIndex:i]]];
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attString);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attString length]), path, NULL);
        CTFrameDraw(frame, context);
        CFRelease(frame);
        CFRelease(frameSetter);
        CFRelease(path);
    }
}

//Set YCordinate
-(void) drawCoordinateYWithContext:(CGContextRef)context{
    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    UIFont *font = [UIFont systemFontOfSize:10];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    for (int i =0; i<self.coordinateY.count; i++) {
        
        int a = i+1;
        float y = kGraphBottom - a*kStepY;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
//        CGRect textFrame = CGRectMake(5, y + 13, 25, 20);
        CGRect textFrame = CGRectMake(5, y-2, 25, 20);
        CGPathAddRect(path, NULL, textFrame);
        NSAttributedString* attString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[self.coordinateY objectAtIndex:i]]attributes:dict];
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attString);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attString length]), path, NULL);
        CTFrameDraw(frame, context);
        CFRelease(frame);
        CFRelease(frameSetter);
        CFRelease(path);
    }
}



#pragma mark -
-(void) drawLineGraphWithContext:(CGContextRef)context andValues:(NSArray *)valueArray andColor:(UIColor *)color{
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetLineDash(context, 0.0, nil, 0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, kstartPoint, kGraphBottom);
    
    for (int i = 0; i<valueArray.count; i++) {
        
        //CGContextAddLineToPoint(context, i*kStepX+kstartPoint, kGraphBottom-i*kStepY);
        NSString *str = [NSString stringWithFormat:@"%@",[valueArray objectAtIndex:i]];
        int a = i + 1;
        CGFloat n = [str floatValue];
        
        CGContextAddLineToPoint(context, a*kStepX+kstartPoint, kGraphBottom-n);
        
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    
    //----Add Circle
    for (int i=0; i<valueArray.count; i++) {
        
        int a = i+1;
        float x = a*kStepX+kstartPoint;
        NSString *str = [NSString stringWithFormat:@"%@",[valueArray objectAtIndex:i]];
        CGFloat n = [str floatValue];
        float y = kGraphBottom-n;
        
        
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(context, rect);
    }
    CGContextDrawPath(context, kCGPathFillStroke);

}

@end
