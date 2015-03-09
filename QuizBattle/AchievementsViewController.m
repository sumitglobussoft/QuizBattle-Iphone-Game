//
//  AchievementsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "AchievementsViewController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "ViewController.h"
#import "SingletonClass.h"
@interface AchievementsViewController ()
{
    
}

@end
static float countTotalAchievment=0;
@implementation AchievementsViewController
@synthesize collection;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pointIntValue=0;
    
  [self fetchDataFromParse];
    self.achivementImageName=[[NSArray alloc]initWithObjects:@"KinderGarten",@"ElementarySchool",@"MiddleSchool",@"HighSchool",@"University",@"Master",@"Doctor",@"Quiz King",nil];
    self.achivementName=[[NSArray alloc]initWithObjects:@"알 등급",@"알깨! 등급",@"알깬 등급",@"날개달아 등급",@"많이컸네! 등급",@"아이언 등급",@"히어로 등급",@"퀴즈대마왕",nil];
    [self createUi];
}
-(void)createUi
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    collection=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-200) collectionViewLayout:layout];
    [collection setDataSource:self];
    [collection setDelegate:self];
    collection.bounces=NO;
    collection.showsVerticalScrollIndicator=NO;
    collection.showsHorizontalScrollIndicator=NO;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [collection setBackgroundColor:[UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:.3]];
    collection.allowsSelection=YES;
    self.view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:collection];
    
  
}
#pragma mark=====
#pragma mark custom delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
   
    
    if(cell==nil)
    {
         cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    }
    for (UIImageView *img in cell.contentView.subviews)
    {
        if ([img isKindOfClass:[UIImageView class]])
        {
            [img removeFromSuperview];
        }
    }
    cell.backgroundColor=[UIColor clearColor];
    self.achivementImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width-20, cell.frame.size.width-20)];
    self.achivementImage.layer.cornerRadius = self.achivementImage.frame.size.width/2;
     self.achivementImage.clipsToBounds=YES;
    self.achivementImage.backgroundColor=[UIColor grayColor];
    self.achivementImage.layer.borderWidth = 3.0f;
    
    UIColor *color1 = [UIColor colorWithRed:(CGFloat)176/255 green:(CGFloat)0/255 blue:(CGFloat)4/255 alpha:1];
    
    UIColor *color2 = [UIColor colorWithRed:(CGFloat)243/255 green:(CGFloat)131/255 blue:(CGFloat)55/255 alpha:1];
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.colors = [NSArray arrayWithObjects:(id)color1.CGColor,(id)color2.CGColor, nil];
    [self.achivementImage.layer insertSublayer:layer atIndex:0];
    self.achivementImage.layer.borderColor = (__bridge CGColorRef)(layer.colors);//[UIColor whiteColor].CGColor;
    //---------
    for (UILabel * lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UILabel class]])
        {
            [lbl removeFromSuperview];
        }
    }
    //-----------
    UILabel * achievmentTag=[[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.width-10, cell.frame.size.width,20)];
       achievmentTag.font=[UIFont boldSystemFontOfSize:10];
    achievmentTag.textAlignment=NSTextAlignmentCenter;
    achievmentTag.textColor=[UIColor whiteColor];
    achievmentTag.text=[self.achivementName objectAtIndex:indexPath.row];
    [cell.contentView addSubview:achievmentTag];
    //------------
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.frame = CGRectMake(0,cell.frame.size.height-10,cell.frame.size.width,4);
    NSLog(@"Current row==%ld",(long)indexPath.row);
     self.achivementImage.image=[UIImage imageNamed:[self.achivementImageName objectAtIndex:indexPath.row]];
        
    PFObject * obj=[self.achievementDetail objectAtIndex:0];
    if (progressView.tag!=[self tagValue:gradeplyr])
    {
     progressView.progress=[self progress:[obj[@"TotalXP"] intValue]  grade:[self.achivementImageName objectAtIndex:indexPath.row]];
    }
    else
    {
       
    progressView.progress=[self progress:pointIntValue grade:gradeplyr];
    }
    [self.view addSubview:progressView];
    [cell.contentView addSubview:progressView];
    
    [cell.contentView addSubview:self.achivementImage];
    //-----------------

    
    
    NSLog(@"Progressview.progress %f",progressView.progress);
    
    if(progressView.progress>0&&progressView.progress<1)
    {
          self.achivementImage.image=[UIImage imageNamed:@"Lock.png"];
       
    }
    else if(progressView.progress==1)
    {
       self.achivementImage.image=[UIImage imageNamed:[self.achivementImageName objectAtIndex:indexPath.row]];
    }
    else
    {
        self.achivementImage.image=[UIImage imageNamed:@"Lock.png"];
        achievmentTag.hidden=YES;
        progressView.hidden=YES;
    }
    //----------
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collection.bounds.size.width/2-40, 150);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index%ld",(long)indexPath.row);
    
}
-(UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"%d %%COMPLETED ", (int)(countTotalAchievment*100)];
         headerView.backgroundColor=[UIColor grayColor];
        for (UILabel * lbl in headerView.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                [lbl removeFromSuperview];
            }
        }

        UILabel * status;
        if(!status)
        {
        status=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 10, 200, 30)];
            status.text=title;
            status.font=[UIFont systemFontOfSize:10];
            [headerView addSubview:status];
        }
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.frame = CGRectMake(100,40,100,20);
        progressView.progress=countTotalAchievment;
        progressView.layer.cornerRadius = 5;
        progressView.clipsToBounds = YES;
        progressView.progressTintColor=[UIColor whiteColor];
        [progressView setTransform:CGAffineTransformMakeScale(1.0, 6.0)];
        [headerView addSubview:progressView];
       
        return headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 0);
}
#pragma mark ---
#pragma mark Setting Progress Value
#pragma mark ---
-(float)progress:(long)points grade:(NSString*)grade
{
if ([grade isEqualToString:@"KinderGarten"])
{
           if (points>0 &&points<=270)
        {
            return 0.33;
        }
    else if (points>=271 && points<=540)
    {
        return 0.66;
        
    }
    else if(points>=541)
    {
        return 1;
        countTotalAchievment=.125;
    }
    }
else if ([grade isEqualToString:@"ElementarySchool"])
{
    if(points>=811&&points<=1220)
    {
        return .167;
    }
    else if (points>=1221&&points<=1700)
    {
        return .334;
    }
    else if (points>=1701&&points<=2250)
    {
        return .501;
    }
    else if (points>=2251&&points<=2870)
    {
        return .668;
    }
    else if(points>=2871&&points<=3560)
    {
        return .835;
    }
    else if(points>=3561)
    {
        countTotalAchievment=.25;

        return 1;
    }
}
    if([grade isEqualToString:@"MiddleSchool"])
    {
        if(points>=5151&&points<=7020)
        {
            return .333;
        }
        else if (points>=7021&&points<=9170)
        {
            return .666;
        }
        else if (points>=9171)
        {
            countTotalAchievment=.375;
            return 1;
        }
        
    }
  if([grade isEqualToString:@"HighSchool"])
    {
        if(points>=15771&&points<=24120)
        {
            return .333;
        }
        else if (points>=24121&&points<=34220)
        {
            return .666;
        }
        else if (points>=34221)
        {
            countTotalAchievment=.5;

            return 1;
        }
        
    }
    if([grade isEqualToString:@"University"])
    {
        if(points>=59671&&points<=92120)
    return .25;
    
        else if (points>=92121&&points<=131570)
            return .5;
      
        else if (points>=131571&&points<=178020)
            return .75;
        else if (points>=178021)
        {
            countTotalAchievment=.625;


            return 1;
        }
        }

  if([grade isEqualToString:@"Master"])
        {
    if(points>=359371&&points<=801620)
        return .5;
            else if(points>=801620)
            {
                countTotalAchievment=.75;


                return 1;
            }
            else
            {
                return 0;
            }
        }
   
 if([grade isEqualToString:@"Doctor"])
    {
        if(points>=801621&&points<=1418870)
            return .5;
        else if(points>=1418870)
        {
            countTotalAchievment=.875;
            
            
            return 1;
        }
        else
        {
            return 0;
        }

        
    }
  
if([grade isEqualToString:@"Quiz King"])
    {
        if(points>=1418771)
        {
             countTotalAchievment=1;
            return 1;
            
        }
        else
        {
            return 0;
        }


    }
     return 0;

}
-(void)fetchDataFromParse
{
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
PFQuery *query=[PFQuery queryWithClassName:@"_User"];
[query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].objectId];
            
NSArray *arrObject=[query findObjects];
self.achievementDetail=[NSArray arrayWithArray:arrObject];
   
    }
});
dispatch_async(dispatch_get_main_queue(), ^(void){
    
    [collection reloadData];
    
  });
}
-(NSInteger)tagValue:(NSString *)grade
{
if ([grade isEqualToString:@"ElementarySchool"])
{
 return 0;
}
    
else if([grade isEqualToString:@"HighSchool"])
 {
    return 1;
 }
    else if([grade isEqualToString:@"KinderGarten"])
    {
        return 2;
    }
    else if([grade isEqualToString:@"Master"])
    {
        return 3;
    }
    else if([grade isEqualToString:@"MiddleSchool"])
    {
        return 4;
    }
    else if([grade isEqualToString:@"Doctor"])    {
        return 5;
    }
    else if([grade isEqualToString:@"QuizKing"])
    {
        return 6;
    }
    else if([grade isEqualToString:@"University"])
    {
        return 7;
    }
    else
    {
        return 8;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
