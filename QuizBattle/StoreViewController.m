//
//  StoreViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "StoreViewController.h"
#import "PurchaseView.h"
#import "PurchaseTableViewCell.h"
#import "AppDelegate.h"
#import "RageIAPHelper.h"
@interface StoreViewController ()

@end

@implementation StoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self createStoreUi];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    userDefault = [NSUserDefaults standardUserDefaults];
    
    arrDia = [NSArray arrayWithObjects:@"X 2",@"X 6",@"X 11",@"X 24",@"X 78",@"X 140", nil];
    arrBoosters = [NSArray arrayWithObjects:@"X 4",@"X 6",@"X 8", nil];
    arrDiaPrice = [NSArray arrayWithObjects:@"₩ 1,100",@"₩ 3,300",@"₩ 5,500",@"₩ 11,000",@"₩ 33,000",@"₩ 55,000", nil];
    
    arrLife = [NSArray arrayWithObjects:@"X 1",@"X 2",@"X 6",@"X 10",@"X 20",@"X 60", nil];
    
    arrBoosterDetail = [NSArray arrayWithObjects:@"2 times",@"3 times",@"4 times", nil];
    
    arrLifeDetail = [NSArray arrayWithObjects:@"Recharge 5 Life",@"Recharge 10 Life",@"Recharge 30 Life",@"Recharge 50 Life",@"Recharge 100 Life",@"Recharge 300 Life", nil];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg_480.png"]];
    strSelectedButton=@"booster";
   
    // Do any additional setup after loading the view from its nib.
}
-(void)createStoreUi
{
    
    PurchaseView * obj=[[PurchaseView alloc]init];
    obj.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100);
    obj.view.layer.borderWidth=0;
    obj.btnClose.hidden=TRUE;
  [self presentViewController:obj animated:NO completion:nil];
    //obj.delegate=self;
    //[self addChildViewController:obj];
 // [self.view addSubview:obj.view];
//    [self presentViewController:obj animated:YES completion:nil];
    
}
-(void)createStoreUiForStore
{
    if([UIScreen mainScreen].bounds.size.height>555)
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg_568.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"store_bg_480.png"]];
    }
    btnBooster=[[UIButton alloc]initWithFrame:CGRectMake(40, 120, 80, 80)];
    [btnBooster setBackgroundImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
    [self.view addSubview:btnBooster];
    
}
-(void)enableSelectedButton
{
    [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn.png"] forState:UIControlStateNormal];
    [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn.png"] forState:UIControlStateNormal];
    [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn.png"] forState:UIControlStateNormal];
    if ([strSelectedButton isEqualToString:@"diamond"])
    {//diamond_en_btn_active
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond_en_btn_active.png"] forState:UIControlStateNormal];
        //[btnDiamond setHighlighted:YES];
    }
    else if ([strSelectedButton isEqualToString:@"booster"])
    {
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"booster_en_btn_active.png"] forState:UIControlStateNormal];//booster_en_btn_active
        //[btnBooster setHighlighted:YES];
    }
    else
    {//life_en_btn
        [btnLife setBackgroundImage:[UIImage imageNamed:@"life_en_btn_active.png"] forState:UIControlStateNormal];
        
    }
}
-(void)closeView:(id)sender
{
}
-(void)lifeView:(id)sender {
    
    if(purcDescImage)
    {
        purcDescImage.hidden=TRUE;
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
        purcDescImage=[[UIImageView alloc]initWithFrame:CGRectMake(17, 80, 234,80)];
        purcDescImage.image=[UIImage imageNamed:@"small_popup_en.png"];
        [purchaseViewImage addSubview:purcDescImage];
        
    }
    else
    {
        purcDescImage.hidden=FALSE;
    }
    
    purchaseViewImage.image=[UIImage imageNamed:@"booster_buy_popup_en.png"];
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
    purchaseViewImage.image=[UIImage imageNamed:@"diamond_buy_popup_en.png"];
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
    //    cell.picIcon.image=[UIImage imageNamed:@"diamond.png"];
    //    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"blank_topc_bg.png"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
                    
                    if (indexPath.section == 0) {
                        product = products[3];
                    }
                    else if (indexPath.section == 1) {
                        product = products[5];
                    }
                    else if (indexPath.section == 2) {
                        product = products[0];
                    }
                    else if (indexPath.section == 3) {
                        product = products[4];
                    }
                    else if (indexPath.section == 4) {
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
        NSLog(@"IndexPat section -==- %ld",(long)indexPath.section);
        
        int totalDia = (int)[userDefault integerForKey:@"buydiamond"];
        if (indexPath.section == 0) {
            
            if (totalDia>=4) {
                [userDefault setInteger:02 forKey:@"buybooster"];
                totalDia=totalDia-4;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (indexPath.section == 1) {
            
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
        
        if (indexPath.section == 0) {
            
            if (totalDia>=1) {
                
                totalLife = totalLife+5;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-1;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (indexPath.section == 1) {
            
            if (totalDia>=2) {
                
                totalLife = totalLife+10;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-2;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (indexPath.section == 2) {
            
            if (totalDia>=6) {
                
                totalLife = totalLife+30;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-6;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (indexPath.section == 3) {
            
            if (totalDia>=10) {
                
                totalLife = totalLife+50;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-10;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else if (indexPath.section == 4) {
            
            if (totalDia>=20) {
                
                totalLife = totalLife+100;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-20;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        else {
            
            if (totalDia>=60) {
                
                totalLife = totalLife+300;
                [userDefault setInteger:totalLife forKey:@"buylife"];
                totalDia=totalDia-60;
                [userDefault setInteger:totalDia forKey:@"buydiamond"];
            }
        }
        [userDefault synchronize];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateproducts" object:nil];
    
    //=====================
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
