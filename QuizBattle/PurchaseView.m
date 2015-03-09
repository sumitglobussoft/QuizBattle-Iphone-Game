//
//  PurchaseView.m
//  QuizBattle
//
//  Created by GBS-mac on 9/18/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "PurchaseView.h"
#import "PurchaseTableViewCell.h"
#import "RageIAPHelper.h"
#import "ViewController.h"

@interface PurchaseView ()

@end

@implementation PurchaseView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(id)initWithButton:(NSString*)selectedButton{
    
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        strSelectedButton = selectedButton;
    }
    return self;
}
- (void)viewDidLoad
{
    userDefault = [NSUserDefaults standardUserDefaults];
    
    arrDia = [NSArray arrayWithObjects:@"diamond_buy2",@"diamond_buy6",@"diamond_buy11",@"diamond_buy24",@"diamond_buy78",@"diamond_buy140",@"diamond_buy270", nil];
   
    arrDiaPrice = [NSArray arrayWithObjects:@"₩ 1,100",@"₩ 3,300",@"₩ 5,500",@"₩ 11,000",@"₩ 33,000",@"₩ 55,000",@"₩ 99,000", nil];
    
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        arrLife = [NSArray arrayWithObjects:@"life_buy1_en.png",@"life_buy2_en.png",@"life_buy6_en.png",@"life_buy10_en.png",@"life_buy20_en.png",@"life_buy30_en.png", nil];
        
         arrBoosters = [NSArray arrayWithObjects:@"booster_en_2_times",@"booster_en_3_times",@"booster_en_4_times", nil];

    }
    else if([strLan isEqualToString:@"Korean"])
    {
         arrBoosters = [NSArray arrayWithObjects:@"booster_2_times",@"booster_3_times",@"booster_4_times", nil];
        arrLife = [NSArray arrayWithObjects:@"life_buy1.png",@"life_buy2.png",@"life_buy6.png",@"life_buy10.png",@"life_buy20.png",@"life_buy30.png", nil];
        

    }

    
    
    arrBoosterDetail = [NSArray arrayWithObjects:@"2 times",@"3 times",@"4 times", nil];
    
    arrLifeDetail = [NSArray arrayWithObjects:@"Recharge 5 Life",@"Recharge 10 Life",@"Recharge 30 Life",@"Recharge 50 Life",@"Recharge 100 Life",@"Recharge 300 Life", nil];
    //-------------
    /*if ([UIScreen mainScreen].nativeScale == 2.0f)
    {
        if(self.view.frame.size.height>568)
        {
            
        }
        else if (self.view.frame.size.height==568)
        {
            
        }
        else
        {
            
        }
    }
    if([UIScreen mainScreen].nativeScale >2.1f)
    {
    NSLog(@"in iPhone 6 plus");
    }
    else
    {
     NSLog(@"in iPad ");
    }*/
    //-------------
    
    if([UIScreen mainScreen].bounds.size.height>555)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg_568.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg_480.png"]];
    }
    self.view.layer.cornerRadius=5;
    self.view.layer.borderColor=[UIColor redColor].CGColor;
    self.view.layer.borderWidth=2;
    self.view.clipsToBounds=YES;
    [self createBoosterUI];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonStore" object:nil];
    [super viewDidLoad];
}
-(void)createBoosterUI {
    
    
    //---------------three button in down-------------------
    btnDiamond=[[UIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height-50, 76, 28)];
    [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
    [btnDiamond addTarget:self action:@selector(diamondView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDiamond];
    //--
    btnBooster=[[UIButton alloc]initWithFrame:CGRectMake(130, self.view.frame.size.height-50, 76, 28)];
    [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn_Korean.png"] forState:UIControlStateNormal];
    [btnBooster addTarget:self action:@selector(boosterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBooster];
    //--
    btnLife=[[UIButton alloc]initWithFrame:CGRectMake(210, self.view.frame.size.height-50, 76, 28)];
    [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
    [btnLife addTarget:self action:@selector(lifeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLife];
    //------------
    purchaseViewImage=[[UIImageView alloc]initWithFrame:CGRectMake(30,35,268,380)];
    purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup_en.png"];
    purchaseViewImage.userInteractionEnabled=YES;
    [self.view addSubview:purchaseViewImage];
    UIButton * close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame=CGRectMake(purchaseViewImage.frame.size.width-30, 40, 25, 25);
    [close setBackgroundImage:[UIImage imageNamed:@"close_btnStore.png"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [purchaseViewImage addSubview:close];

    tableVBooster = [[UITableView alloc] init];
    
    if ([strSelectedButton isEqualToString:@"booster"]) {
        
        tableVBooster.frame=CGRectMake(20, 215, self.view.frame.size.width-30, 290);
        
        [tableVBooster reloadData];
        if(!purcDescImage)
        {
            purcDescImage=[[UIImageView alloc]initWithFrame:CGRectMake(17, 80, 234,122)];
           
            [purchaseViewImage addSubview:purcDescImage];
            
        }
        else
        {
            purcDescImage.hidden=FALSE;
        }
        NSString *strLan = [userDefault objectForKey:@"language"];
        
        if([strLan isEqualToString:@"English"])
        {
             purcDescImage.image=[UIImage imageNamed:@"small_popup_en.png"];
            purchaseViewImage.image=[UIImage imageNamed:@"booster_buy_popup_en"];
        }
        else if([strLan isEqualToString:@"Korean"])
        {
             purcDescImage.image=[UIImage imageNamed:@"small_popup_kr.png"];
            purchaseViewImage.image=[UIImage imageNamed:@"booster_buy_popup"];
            
        }
        strSelectedButton=@"booster";

    }
    else if ([strSelectedButton isEqualToString:@"diamond"])
    {
        if(purcDescImage)
        {
            purcDescImage.hidden=TRUE;
        }
        NSString *strLan = [userDefault objectForKey:@"language"];
        
        if([strLan isEqualToString:@"English"])
        {
            purchaseViewImage.image=[UIImage imageNamed:@"diamond_buy_popup_en"];
        }
        else if([strLan isEqualToString:@"Korean"])
        {
            
            purchaseViewImage.image=[UIImage imageNamed:@"diamond_buy_popup"];
            
        }

        strSelectedButton=@"diamond";
        tableVBooster.frame=CGRectMake(20, 70, self.view.frame.size.width, self.view.frame.size.height);
        
        [tableVBooster reloadData];
        
    }
    else{
        tableVBooster.frame=CGRectMake(20, 70, self.view.frame.size.width, self.view.frame.size.height);
        NSString *strLan = [userDefault objectForKey:@"language"];
        
        if([strLan isEqualToString:@"English"])
        {
            purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup_en"];
        }
        else if([strLan isEqualToString:@"Korean"])
        {
            
            purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup"];
            
        }

    }
    tableVBooster.delegate=self;
    tableVBooster.dataSource=self;
    [tableVBooster setBackgroundView:nil];
    tableVBooster.backgroundColor=[UIColor clearColor];
    tableVBooster.opaque=NO;
    tableVBooster.scrollEnabled=false;
    tableVBooster.separatorStyle = UITableViewCellSeparatorStyleNone;
    [purchaseViewImage addSubview:tableVBooster];
    NSString *strLan = [userDefault objectForKey:@"language"];

    if([strLan isEqualToString:@"English"])
    {
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn_Korean.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
        
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn_Korean.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_btn.png"] forState:UIControlStateNormal];

    }

    [self enableSelectedButton];
    
}
-(void)enableSelectedButton
{
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
        
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn_Korean.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_btn_kr.png"] forState:UIControlStateNormal];
        
    }

   if ([strSelectedButton isEqualToString:@"diamond"])
   {//diamond_en_btn_active
       if([strLan isEqualToString:@"English"])
       {
           
           [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn_active.png"] forState:UIControlStateNormal];
       }
       else if([strLan isEqualToString:@"Korean"])
       {
           
           [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_btn_active.png"] forState:UIControlStateNormal];
       }

        //[btnDiamond setHighlighted:YES];
    }
    else if ([strSelectedButton isEqualToString:@"booster"])
    {
        if([strLan isEqualToString:@"English"])
        {
            
            [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn_active.png"] forState:UIControlStateNormal];
        }
        else if([strLan isEqualToString:@"Korean"])
        {
            
            [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_btn_active.png"] forState:UIControlStateNormal];
        }

      //booster_en_btn_active
        //[btnBooster setHighlighted:YES];
    }
    else
    {//life_en_btn
        if([strLan isEqualToString:@"English"])
        {
            
            [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn_active.png"] forState:UIControlStateNormal];
        }
        else if([strLan isEqualToString:@"Korean"])
        {
            
            [btnLife setBackgroundImage:[UIImage imageNamed:@"life_btn_active.png"] forState:UIControlStateNormal];
        }
    }
}
-(void)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}
-(void)lifeView:(id)sender {
    
    if(purcDescImage)
    {
        purcDescImage.hidden=TRUE;
    }
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup_en"];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
      
        purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup"];
        
    }

    strSelectedButton=@"life";
     tableVBooster.frame=CGRectMake(20, 70, self.view.frame.size.width, self.view.frame.size.height);
    [tableVBooster reloadData];
    [self enableSelectedButton];
}
-(void)boosterView:(id)sender
{
    if(!purcDescImage)
    {
        purcDescImage=[[UIImageView alloc]initWithFrame:CGRectMake(17, 80, 234,122)];
        
        [purchaseViewImage addSubview:purcDescImage];

    }
    else
    {
         purcDescImage.hidden=FALSE;
    }
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        purcDescImage.image=[UIImage imageNamed:@"small_popup_en.png"];
        purchaseViewImage.image=[UIImage imageNamed:@"booster_buy_popup_en.png"];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
       purcDescImage.image=[UIImage imageNamed:@"small_popup_kr.png"];
        purchaseViewImage.image=[UIImage imageNamed:@"booster_buy_popup.png"];

    }
           strSelectedButton=@"booster";
//    lblDetailBooster.hidden=NO;
//    
//    if (!lblDetailBooster) {
//       
//        lblDetailBooster = [[UILabel alloc]init];
//        lblDetailBooster.frame=CGRectMake(20, btnLife.frame.origin.y+btnLife.frame.size.height+10, self.view.frame.size.width-40, 100);
//        lblDetailBooster.numberOfLines=5;
//        lblDetailBooster.font=[UIFont systemFontOfSize:10];
//        lblDetailBooster.textAlignment=NSTextAlignmentCenter;
//        lblDetailBooster.lineBreakMode=NSLineBreakByWordWrapping;
//        lblDetailBooster.text=[ViewController languageSelectedStringForKey:@"If you have Booster, you can raise your level Faster, and the Booster will be effective for One hour."];
//        lblDetailBooster.layer.borderWidth=1;
//        [self.view addSubview:lblDetailBooster];
//        
//        UILabel *lblBooster = [[UILabel alloc]init];
//        lblBooster.frame=CGRectMake(100, 5, 50, 20);
//        lblBooster.font=[UIFont boldSystemFontOfSize:13];
//        lblBooster.textAlignment=NSTextAlignmentCenter;
//        lblBooster.text=[ViewController languageSelectedStringForKey:@"Booster"];
//        [lblDetailBooster addSubview:lblBooster];
//        
//        UIImageView *imageVBooster = [[UIImageView alloc]initWithFrame:CGRectMake(lblBooster.frame.origin.x+lblBooster.frame.size.width+5, 5, 15, 25)];
//        imageVBooster.image=[UIImage imageNamed:@"booster.png"];
//        [lblDetailBooster addSubview:imageVBooster];
//    }
//    [btnBooster setHighlighted:YES];
//    [btnBooster setSelected:YES];
//    
//    [btnLife setHighlighted:NO];
//    [btnLife setSelected:NO];
//    
//    [btnDiamond setHighlighted:NO];
//    [btnDiamond setSelected:NO];
//    
//    strSelectedButton=@"booster";
   tableVBooster.frame=CGRectMake(20, 215, self.view.frame.size.width-30, 290);

    [tableVBooster reloadData];
    [self enableSelectedButton];

}
-(void)diamondView:(id)sender
{
    
   if(purcDescImage)
   {
       purcDescImage.hidden=TRUE;
   }
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        purchaseViewImage.image=[UIImage imageNamed:@"diamond_buy_popup_en.png"];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
       
    purchaseViewImage.image=[UIImage imageNamed:@"diamond_buy_popup.png"];
    }

        strSelectedButton=@"diamond";
    tableVBooster.frame=CGRectMake(20, 70, self.view.frame.size.width, self.view.frame.size.height);

    [tableVBooster reloadData];
    [self enableSelectedButton];

}

#pragma mark ===============================
#pragma mark Table View delegates Methods
#pragma mark ===============================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([strSelectedButton isEqualToString:@"diamond"]) {
        return arrDia.count;
    }
    else if ([strSelectedButton isEqualToString:@"booster"]) {
        return arrBoosters.count;
    }
    else
    return [arrLife count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    PurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil) {
        
//        cell=[[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell=[[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier AndSelectedButton:strSelectedButton];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    cell.backgroundColor=[UIColor clearColor];
    
    if ([strSelectedButton isEqualToString:@"diamond"])
    {
        cell.picImageView.image=[UIImage imageNamed:[arrDia objectAtIndex:indexPath.section]];
       
    }
    else if ([strSelectedButton isEqualToString:@"booster"])
    {
        NSLog(@"IndexPat section -==- %ld",(long)indexPath.section);
        cell.picImageView.image=[UIImage imageNamed:[arrBoosters objectAtIndex:indexPath.section]];
           }
    else{
        cell.picImageView.image=[UIImage imageNamed:[arrLife objectAtIndex:indexPath.section]];
        
    }
    [cell.buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyButton.userInteractionEnabled=YES;
    cell.buyButton.tag=indexPath.section;
//    cell.picIcon.image=[UIImage imageNamed:@"diamond.png"];
//    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_topc_bg.png"]];
    
    return cell;
}
-(void)buyAction:(UIButton*)button
{
    NSLog(@"Button tag %d",button.tag);
    // Code for Diamond Tab =======================
    
    if ([strSelectedButton isEqualToString:@"diamond"]) {
        
        activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 50, 50)];
        activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        activityInd.color=[UIColor redColor];
        [self.view addSubview:activityInd];
        [activityInd startAnimating];
        
        [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            NSLog(@"Products -==--= %@",products);
            if (success) {
                
                if (products.count <=0) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"" message:[ViewController languageSelectedStringForKey:@"Please check your internet connection and try again"] delegate:self cancelButtonTitle:[ViewController languageSelectedStringForKey:@"Ok"] otherButtonTitles:nil, nil] show];
                }
                else{
                    
                    SKProduct *product = products[0];
                    
                    if (button.tag == 0) {
                        product = products[3];
                    }
                    else if (button.tag == 1) {
                        product = products[5];
                    }
                    else if (button.tag == 2) {
                        product = products[0];
                    }
                    else if (button.tag == 3) {
                        product = products[4];
                    }
                    else if (button.tag == 4) {
                        product = products[1];
                    }
                    else {
                        product = products[2];
                    }
                    
                    NSLog(@"Buying %@...", product.productIdentifier);
                    
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                }
            }
            [activityInd stopAnimating];
        }];
    }
    //================================================
    
    
    // Buy Booster from diamonds=============
    else if ([strSelectedButton isEqualToString:@"booster"]) {
        NSLog(@"IndexPat section -==- %ld",(long)button.tag);
        
        int totalDia = (int)[userDefault integerForKey:@"buydiamond"];
        if (button.tag == 0) {
            
            if (totalDia>=4) {
                [userDefault setInteger:02 forKey:@"buybooster"];
                totalDia=totalDia-4;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (button.tag == 1) {
            
            if (totalDia>=6) {
                [userDefault setInteger:03 forKey:@"buybooster"];
                totalDia=totalDia-6;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else {
            
            if (totalDia>=8) {
                [userDefault setInteger:04 forKey:@"buybooster"];
                totalDia=totalDia-8;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        [userDefault synchronize];
    }
    // =============================
    
    // Buy Life from diamonds ===============
    else{
        
        int totalDia = (int)[userDefault integerForKey:@"buydiamond"];
        int totalLife = (int)[userDefault integerForKey:@"buylife"];
        
        if (button.tag == 0) {
            
            if (totalDia>=1) {
                
                totalLife = totalLife+5;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-1;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (button.tag == 1) {
            
            if (totalDia>=2) {
                
                totalLife = totalLife+10;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-2;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (button.tag == 2) {
            
            if (totalDia>=6) {
                
                totalLife = totalLife+30;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-6;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (button.tag == 3) {
            
            if (totalDia>=10) {
                
                totalLife = totalLife+50;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-10;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
              //  [userDefault synchronize];
            }
        }
        else if (button.tag == 4) {
            
            if (totalDia>=20) {
                
                totalLife = totalLife+100;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-20;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
               // [userDefault synchronize];
            }
        }
        else {
            
            if (totalDia>=60) {
                
                totalLife = totalLife+300;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-60;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
                //[userDefault synchronize];
            }
        }
        [userDefault synchronize];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateproducts" object:nil];
    
    //=====================
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20; // you can have your own choice, of course
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}
-(void)changeLanguage
{
    NSString *strLan = [userDefault objectForKey:@"language"];
    
    if([strLan isEqualToString:@"English"])
    {
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
        purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup_en.png"];
         purcDescImage.image=[UIImage imageNamed:@"small_popup_en.png"];
    }
    else if([strLan isEqualToString:@"Korean"])
    {
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn.png"] forState:UIControlStateNormal];
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
        purchaseViewImage.image=[UIImage imageNamed:@"life_buy_popup_en.png"];
         purcDescImage.image=[UIImage imageNamed:@"small_popup_en.png"];
    }
}
-(void)purchaseDetails:(NSString*)detail {
    
}
@end
