//
//  AboutView.m
//  QuizBattle
//
//  Created by GBS-mac on 12/6/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "AboutView.h"
#import "ViewController.h"

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame=frame;
        [self setBackgroundColor:[UIColor whiteColor]];
        UIImageView *imglogo=[[UIImageView alloc]initWithFrame:CGRectMake(125, 30,70,70)];
        imglogo.image=[UIImage imageNamed:@"logo.png"];
        [self addSubview:imglogo];
        UILabel *logolbl=[[UILabel alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+70, 320, 70)];
        logolbl.text=[ViewController languageSelectedStringForKey:@"Quiz Battle"];
        logolbl.textColor=[UIColor blackColor];
        logolbl.textAlignment=NSTextAlignmentCenter;
        logolbl.font=[UIFont boldSystemFontOfSize:26];
        [self addSubview:logolbl];
        UIButton *termsOfUsebtn=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+140, 320, 30)];
        [termsOfUsebtn setTitle:@"이용 약관"  forState:UIControlStateNormal];
         [termsOfUsebtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [termsOfUsebtn setTitleColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1] forState:UIControlStateNormal];
        [termsOfUsebtn addTarget:self action:@selector(termsOfUseAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:termsOfUsebtn];
        UIButton *privacyBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+170, 320, 30)];
         [privacyBtn setTitle:@"개인 정보 보호 정책" forState:UIControlStateNormal];
        privacyBtn.userInteractionEnabled=YES;
        [privacyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [privacyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [privacyBtn addTarget:self action:@selector(termsOfUseAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:privacyBtn];
        
        UILabel *custmrsuportlbl=[[UILabel alloc]initWithFrame:CGRectMake(0, imglogo.frame.origin.y+200, self.frame.size.width, 40)];
        custmrsuportlbl.text=[ViewController languageSelectedStringForKey:@"For customer supportvisit"];

        custmrsuportlbl.textColor=[UIColor greenColor];
        custmrsuportlbl.font=[UIFont boldSystemFontOfSize:16];
        custmrsuportlbl.textAlignment=NSTextAlignmentCenter;
       // custmrsuportlbl.lineBreakMode=NSLineBreakByWordWrapping;
        [self addSubview:custmrsuportlbl];
        UIButton *supportUrl=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+250,self.frame.size.width, 30)];
        [supportUrl setTitle:@"www.QuizBattle.com" forState:UIControlStateNormal];
        [supportUrl.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [supportUrl setTitleColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1] forState:UIControlStateNormal];
        [supportUrl addTarget:self action:@selector(supporturlAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:supportUrl];

        
        
    }
    return self;
}
#pragma mark AddTapGesture
-(void) handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    
    [web_View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/termsAndConditions.php"]]];
    
    [self addSubview:web_View];
 
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [imageVAnim stopAnimating];
    UIButton *backbtnweb=[[UIButton alloc]initWithFrame:CGRectMake(300,0, 20,20)];
    [backbtnweb setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [backbtnweb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backbtnweb addTarget:self action:@selector(backbtnWebAction) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:backbtnweb];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error) {
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
        [imageVAnim stopAnimating];
        NSLog(@"Error %@",error);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-30, 30, 50)];
    [web_View addSubview:imageVAnim];
    
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    
    imageVAnim.animationImages=arrAnimImages;
    imageVAnim.animationDuration=0.5;
    imageVAnim.animationRepeatCount=0;
    [imageVAnim startAnimating];
}
-(void)backbtnWebAction
{
    [web_View removeFromSuperview];
}

-(void)backbtnAction
{
    
}
-(void)termsOfUseAction
{
    web_View=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    web_View.delegate=self;
    web_View.backgroundColor=[UIColor whiteColor];
      [self addSubview:web_View];
    [web_View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@" https://www.google.com"]]];
}
-(void)loadUrl
{
    

}
-(void)supporturlAction
{
    web_View=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    web_View.delegate=self;
    web_View.backgroundColor=[UIColor whiteColor];
    [web_View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@" http://quiz-battle.co.kr/termsAndConditions.php"]]];
    
   [self addSubview:web_View];

}
-(void)createAboutUI
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
