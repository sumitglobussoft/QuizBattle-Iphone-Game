//
//  AddQuestionViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 9/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "ViewController.h"
#import "SingletonClass.h"
#import <Parse/Parse.h>
@interface AddQuestionViewController ()

@end

@implementation AddQuestionViewController

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
    // Do any additional setup after loading the view.
    
     [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0]];
    
    UIView *viewTopLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [viewTopLayer setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:viewTopLayer];

    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBack.frame=CGRectMake(5, 5, 55, 35);
    //[btnBack setTitle:[ViewController languageSelectedStringForKey:@"Back"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewTopLayer addSubview:btnBack];
    
    UILabel *lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 15, 100, 40)];
    lblHeader.textAlignment=NSTextAlignmentLeft;
    lblHeader.text=[ViewController languageSelectedStringForKey:@"+ Quiz Topic"];
    lblHeader.textColor=[UIColor whiteColor];
    [viewTopLayer addSubview:lblHeader];
    
    
    UILabel *lblTopic = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 100, 40)];
    lblTopic.textAlignment=NSTextAlignmentLeft;
    lblTopic.text=self.strTopic;
    lblTopic.font=[UIFont boldSystemFontOfSize:16];
    lblTopic.textColor=[UIColor blackColor];
    [self.view addSubview:lblTopic];
    
    UIButton *btnPostQues = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPostQues setTitle:[ViewController languageSelectedStringForKey:@"Post"] forState:UIControlStateNormal];
    btnPostQues.frame=CGRectMake(self.view.frame.size.width-120, 75, 90, 35);
    [btnPostQues addTarget:self action:@selector(postQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    btnPostQues.layer.borderWidth=2.0;
    btnPostQues.layer.borderColor=[UIColor blackColor].CGColor;
    btnPostQues.layer.cornerRadius=3;
    btnPostQues.clipsToBounds=YES;
    [self.view addSubview:btnPostQues];
    
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame=CGRectMake(0, lblTopic.frame.origin.y+lblTopic.frame.size.height+10, self.view.frame.size.width, self.view.frame.size.height-scrollView.frame.origin.y-5);
//    scrollView.backgroundColor=[UIColor redColor];
    scrollView.contentSize=CGSizeMake(self.view.frame.size.width, 600);
    scrollView.scrollEnabled=YES;
    [self.view addSubview:scrollView];
    
    textVQues = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 100)];
    textVQues.text=[ViewController languageSelectedStringForKey:@"Write Question (Maximum 60 words)"];
    textVQues.textAlignment=NSTextAlignmentLeft;
    textVQues.textColor=[UIColor lightGrayColor];
    textVQues.delegate=self;
    [scrollView addSubview:textVQues];
    
    
    textVAnsA = [[UITextView alloc] initWithFrame:CGRectMake(5, textVQues.frame.origin.y+textVQues.frame.size.height+10, self.view.frame.size.width-10, 50)];
    textVAnsA.text=[ViewController languageSelectedStringForKey:@"Correct Answer (Maximum 15 words)"];
    textVAnsA.textAlignment=NSTextAlignmentLeft;
    textVAnsA.textColor=[UIColor lightGrayColor];
    textVAnsA.delegate=self;
    [scrollView addSubview:textVAnsA];
    
    
    textVAnsB = [[UITextView alloc] initWithFrame:CGRectMake(5, textVAnsA.frame.origin.y+textVAnsA.frame.size.height+7, self.view.frame.size.width-10, 50)];
    textVAnsB.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
    textVAnsB.textAlignment=NSTextAlignmentLeft;
    textVAnsB.textColor=[UIColor lightGrayColor];
    textVAnsB.delegate=self;
    [scrollView addSubview:textVAnsB];
    
    textVAnsC = [[UITextView alloc] initWithFrame:CGRectMake(5, textVAnsB.frame.origin.y+textVAnsB.frame.size.height+7, self.view.frame.size.width-10, 50)];
    textVAnsC.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
    textVAnsC.textAlignment=NSTextAlignmentLeft;
    textVAnsC.textColor=[UIColor lightGrayColor];
    textVAnsC.delegate=self;
    [scrollView addSubview:textVAnsC];
    
    
    textVAnsD = [[UITextView alloc] initWithFrame:CGRectMake(5, textVAnsC.frame.origin.y+textVAnsC.frame.size.height+7, self.view.frame.size.width-10, 50)];
    textVAnsD.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)" ];
    textVAnsD.textAlignment=NSTextAlignmentLeft;
    textVAnsD.textColor=[UIColor lightGrayColor];
    textVAnsD.delegate=self;
    [scrollView addSubview:textVAnsD];
    
    UIButton *addImgBtn=[[UIButton alloc]initWithFrame:CGRectMake(textVAnsD.frame.origin.x+textVAnsD.frame.size.width-100,textVAnsD.frame.origin.y+textVAnsD.frame.size.height+7,100, 35)];
    [addImgBtn setTitle:[ViewController languageSelectedStringForKey:@"Add Image"] forState:UIControlStateNormal];
    [addImgBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addImgBtn setBackgroundImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
    [addImgBtn addTarget:self action:@selector(addImgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:addImgBtn];
    
    
    UILabel *addImgLbl=[[UILabel alloc]initWithFrame:CGRectMake(textVAnsD.frame.origin.x,addImgBtn.frame.origin.y,200, 30)];
    addImgLbl.text=[ViewController languageSelectedStringForKey:@"Add Image in Question"];
    addImgLbl.textColor=[UIColor blackColor];
    addImgLbl.textAlignment=NSTextAlignmentLeft;
    [scrollView addSubview:addImgLbl];
    
    
    
    imgView=[[UIImageView alloc]initWithFrame:CGRectMake(textVAnsD.frame.origin.x+20, addImgBtn.frame.origin.y+49, textVAnsD.frame.size.width-40,200 )];
    imgView.layer.borderColor=[UIColor blackColor].CGColor;
    imgView.layer.borderWidth=2.0;
    imgView.image=[UIImage imageNamed:@"profile_bg.png"];
    [scrollView addSubview:imgView];
    
    
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)postQuestion:(UIButton*)button
{
    button.enabled=false;
    
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
    [self.view addSubview:imageVAnim];
    
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
    
    
   ///////////////////////PoST ////////////////////////////////////////
    NSString * strQues=textVQues.text;
     NSString * correctAns=textVAnsA.text;
    NSMutableArray *answersarr=[[NSMutableArray alloc]init];
    [answersarr addObject:textVAnsA.text];
    [answersarr addObject:textVAnsB.text];
    [answersarr addObject:textVAnsC.text];
    [answersarr addObject:textVAnsD.text];
    NSData *data=UIImagePNGRepresentation(quesImg);
    
    if (strQues.length>0 && [answersarr count]==4)
    {
        
        BOOL checkInternet=[ViewController networkCheck];
        if (checkInternet) {
            
            PFObject *obj=[PFObject objectWithClassName:@"QuestionRequest"];
            obj[@"Question"]=strQues;
            
            [obj setObject:answersarr forKey:@"Option"];
            obj[@"CorrectAnswer"]=correctAns;
            
            obj[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
            
            if (data) {
                
                PFFile *imgFile=[PFFile fileWithData:data];
                [imgFile saveInBackground];
                obj[@"Picture"]=imgFile;
            }
            [obj saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
             {
                 if (suceed) {
                     NSLog(@"Sucessfully created Object");
                     imgView.image=[UIImage imageNamed:@"7.png"];
                     textVQues.text=[ViewController languageSelectedStringForKey:@"Write Question (Maximum 60 words)"];
                     textVAnsA.text=[ViewController languageSelectedStringForKey:@"Correct Answer (Maximum 15 words)" ];
                     textVAnsB.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
                     textVAnsC.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
                     textVAnsD.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
                     dispatch_async(dispatch_get_main_queue(),^(void)
                                            {
                                        [imageVAnim stopAnimating];
                                        });
                 }
                 else
                 {
                     NSLog(@"Error==%@",error);
                 }
            }];
        }
        
        
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"" message:[ViewController languageSelectedStringForKey:@"Please fill all the fields"] delegate:self cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles:nil]show];
        }
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey: @"OK"] otherButtonTitles: nil] show];
    }
}

#pragma mark ============================
#pragma mark Text View Delegate Methods
#pragma mark ============================

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    textView.text=@"";
    textView.textColor=[UIColor blackColor];
    textView.backgroundColor=[UIColor greenColor];
    
    if (textView==textVAnsA) {
        
        [scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    }
   else if (textView==textVAnsB) {
        
         [scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
   else if (textView==textVAnsC) {
        
        [scrollView setContentOffset:CGPointMake(0, 210) animated:YES];
    }
   else if (textView==textVAnsD) {
       
       [scrollView setContentOffset:CGPointMake(0, 220) animated:YES];
   }
   else {
       
       [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textVQues.text.length==0) {
        textVQues.text=[ViewController languageSelectedStringForKey:@"Write Question (Maximum 60 words)"];
        textVQues.textColor=[UIColor lightGrayColor];
    }
    if (textVAnsA.text.length==0) {
        textVAnsA.text=[ViewController languageSelectedStringForKey:@"Correct Answer (Maximum 15 words)"];
        textVAnsA.textColor=[UIColor lightGrayColor];
    }
    if (textVAnsB.text.length==0) {
        textVAnsB.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
        textVAnsB.textColor=[UIColor lightGrayColor];
    }
    if (textVAnsC.text.length==0) {
        textVAnsC.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
        textVAnsC.textColor=[UIColor lightGrayColor];
    }
    if (textVAnsD.text.length==0) {
        textVAnsD.text=[ViewController languageSelectedStringForKey:@"Wrong Answer (Maximum 15 words)"];
        textVAnsD.textColor=[UIColor lightGrayColor];
    }
    textView.backgroundColor=[UIColor whiteColor];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark---
-(void)addImgBtnAction:(id)sender
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    imgView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    quesImg=imgView.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
