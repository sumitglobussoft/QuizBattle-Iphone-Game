//
//  SignUpWithEmailViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "SignUpWithEmailViewController.h"
#import "SignUpWithEmailPage.h"
#import "ViewController.h"
#import <Parse/Parse.h>

@interface SignUpWithEmailViewController ()

@end

@implementation SignUpWithEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUi];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collection=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 60, 270, self.view.frame.size.height-100) collectionViewLayout:layout];
    
    [ self.collection setDataSource:self];
    [ self.collection setDelegate:self];
    
    [ self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [ self.collection setBackgroundColor:[UIColor clearColor]];
    self.collection.allowsSelection=YES;
    self.collection.hidden=YES;

   }
-(void)createUi
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headerView setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.view addSubview:headerView];
    
    self.avtarImages=[[NSMutableArray alloc]init];
    
    for(int i=1;i<=20;i++)
    {
        NSString * imgName=[NSString stringWithFormat:@"%d.png",i] ;
        
        [ self.avtarImages addObject:imgName];
    }
    
    NSString *strSignUp = [ViewController languageSelectedStringForKey:@"Sign Up"];
    
    
    ////////back button In Sign Up with Email///////////
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(100, 10,100 , 30)];
    lblHeader.text=strSignUp;
    lblHeader.textAlignment=NSTextAlignmentCenter;
    lblHeader.font=[UIFont boldSystemFontOfSize:20];
    lblHeader.textColor=[UIColor whiteColor];
    [headerView addSubview:lblHeader];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame=CGRectMake(self.view.frame.size.width-100, 10,90, 30);
    btnNext.titleLabel.textAlignment=NSTextAlignmentLeft;
    [btnNext setTitle:[ViewController languageSelectedStringForKey:@"Next >"] forState:UIControlStateNormal];
    btnNext.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnNext];
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(headerView.frame.origin.x+5, 10, 30, 30);
    backbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    //[backbtn setTitle:[ViewController languageSelectedStringForKey:@"< Back"] forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [backbtn addTarget:self action:@selector(backBtnActionInSignUpEmail:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backbtn];
    UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnImage.frame=CGRectMake(20, 95, 80, 80);
    btnImage.layer.cornerRadius=40;
    [btnImage addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnImage];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnImage.frame.size.width, btnImage.frame.size.height)];
    imageV.image=[UIImage imageNamed:@"2.png"];
    [btnImage addSubview:imageV];
    imageData = UIImageJPEGRepresentation(imageV.image, 0.05f);
    
    txtFName = [[UITextField alloc] init];
    txtFName.frame=CGRectMake(115, 115, 170, 30);
    txtFName.placeholder=@"Name";
    txtFName.delegate=self;
    txtFName.layer.borderWidth=1;
    txtFName.textAlignment=NSTextAlignmentCenter;
    txtFName.autocorrectionType=UITextAutocorrectionTypeNo;
    [self.view addSubview:txtFName];
    
    txtFBirthday = [[UITextField alloc] init];
    txtFBirthday.frame=CGRectMake(115, 151, 170, 30);
    txtFBirthday.placeholder=@"Birthday";
    txtFBirthday.delegate=self;
    txtFBirthday.layer.borderWidth=1;
    txtFBirthday.textAlignment=NSTextAlignmentCenter;
    
    //[self.view addSubview:txtFBirthday];
    
    NSString *strBirthD = [ViewController languageSelectedStringForKey:@"Birthday"];
    txtFBirthday.placeholder=strBirthD;
    
    NSString *strUserN = [ViewController languageSelectedStringForKey:@"Display Name"];
    txtFName.placeholder=strUserN;
    
    lblEdit = [[UILabel alloc] initWithFrame:CGRectMake(btnImage.frame.origin.x, btnImage.frame.origin.y+btnImage.frame.size.height-17, btnImage.frame.size.width, 20)];
    NSString *strEdit = [ViewController languageSelectedStringForKey:@"Edit"];
    lblEdit.text=strEdit;
    lblEdit.textColor=[UIColor whiteColor];
    lblEdit.textAlignment=NSTextAlignmentCenter;
    lblEdit.font=[UIFont boldSystemFontOfSize:12];
    [self.view addSubview:lblEdit];
    
   

}
-(void)backBtnActionInSignUpEmail:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)addImageAction:(id)sender {
    
    NSString *actionTitle = [ViewController languageSelectedStringForKey:@"Choose Profile Picture Source"];
    NSString *strCancel = [ViewController languageSelectedStringForKey:@"Cancel"];
    
    NSString *strTakePhoto = [ViewController languageSelectedStringForKey:@"Take Photo"];
    
    NSString *strChooseP = [ViewController languageSelectedStringForKey:@"Choose Photo"];
    
    NSString *strChooseA = [ViewController languageSelectedStringForKey:@"Choose Avatar"];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:strCancel destructiveButtonTitle:nil otherButtonTitles:strTakePhoto,strChooseP,strChooseA, nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"Action sheet button index press -== %ld",(long)buttonIndex);
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    
    if (buttonIndex==0) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
         [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==1){
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
         [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==2) {
        
        [self.view addSubview:self.collection];
        self.collection.hidden=FALSE;
        txtFBirthday.hidden=TRUE;
        txtFName.hidden=TRUE;
        imageV.hidden=TRUE;
        lblEdit.hidden=TRUE;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    NSLog(@"Image Info -=-= %@", editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"Image Info Picking Media-=-= %@", info);
    
    imageV.image=nil;
    imageV.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Upload image
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)nextBtnAction:(id)sender {
    
    NSString *strOk = [ViewController languageSelectedStringForKey:@"OK"];
   
    if ([txtFName.text isEqualToString:@""]) {
        
        NSString *strMess = [ViewController languageSelectedStringForKey:@"Please Enter Username."];
        [[[UIAlertView alloc] initWithTitle:@"" message:strMess delegate:nil cancelButtonTitle:strOk otherButtonTitles: nil] show];
    }
    else{
        
    SignUpWithEmailPage *obj  = [[SignUpWithEmailPage alloc]init];
        
    obj.strUserName=txtFName.text;
    obj.strBirthday=txtFBirthday.text;
    
    if (imageData) {
        obj.dataImage=imageData;
    }
    [self presentViewController:obj animated:YES completion:nil];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [txtFBirthday resignFirstResponder];
    [txtFName resignFirstResponder];
    [self.flatDatePicker dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark==============================
#pragma mark TextField Delegate Methods
#pragma mark==============================

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField==txtFBirthday)
    {
    
        [txtFBirthday resignFirstResponder];
    if (!self.flatDatePicker) {
            self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
            self.flatDatePicker.delegate = self;
            NSString *strPickerText = [ViewController languageSelectedStringForKey:@"Select your birthday"];
            self.flatDatePicker.title = strPickerText;
                   self.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
            self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
        
            [self.flatDatePicker show];
        }
        else{
            [self.flatDatePicker show];
        }
   }
    else
    {
         [self.flatDatePicker dismiss];
    }
  
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self textFieldShouldReturn:txtFName];
}
- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
//        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    txtFBirthday.text = value;
}

#pragma mark---
#pragma mark collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    for (UIImageView *img in cell.contentView.subviews)
    {
        if ([img isKindOfClass:[UIImageView class]])
        {
            [img removeFromSuperview];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView *v in [cell.contentView subviews])
            [v removeFromSuperview];
        if ([self.collection.indexPathsForVisibleItems containsObject:indexPath]) {
            
            UIImageView *avtarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:  [ self.avtarImages objectAtIndex:indexPath.row]]];
            avtarImageView.layer.zPosition=2;
            cell.layer.zPosition=2;
            NSLog(@"images%@",[ self.avtarImages objectAtIndex:indexPath.row]);
            avtarImageView.frame=CGRectMake(0, 0, 100, 100);
            
            cell.backgroundColor=[UIColor clearColor];
            
            [cell.contentView addSubview:avtarImageView];
        }
    });
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index%ld",(long)indexPath.row);
    NSLog(@"Image name -==- %@",[self.avtarImages objectAtIndex:indexPath.row]);
    imageV.image=[UIImage imageNamed:[self.avtarImages objectAtIndex:indexPath.row]];
    imageData = UIImageJPEGRepresentation(imageV.image, 0.05f);
    self.collection.hidden=TRUE;
    txtFBirthday.hidden=FALSE;
    txtFName.hidden=FALSE;
    imageV.hidden=FALSE;
    lblEdit.hidden=FALSE;
}
-(UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

@end