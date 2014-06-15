//
//  JCCConfirmPasswordViewController.m
//  ShoutApp
//
//  Created by Cole McCracken on 6/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#warning TODO remove unnecesarry imports

#import "JCCAppDelegate.h"
#import "JCCConfirmPasswordViewController.h"
#import "JCCUserViewController.h"
#import "JCCViewController.h"
#import "JCCLoginViewController.h"
#import "JCCUserCredentials.h"
#import "JCCProfPicViewController.h"
#import "JCCEditProfileViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMyShoutsTableViewController.h"
#import "JCCMakeRequests.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"


@interface JCCConfirmPasswordViewController ()

@end

@implementation JCCConfirmPasswordViewController
{
    UITextField *passwordField;
    UIButton *confirm;
}

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
    
    // Create the password field
    //    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 325, 225, 50)];
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.572 - 100, 225, outerWindowHeight * 0.088)];
    
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordField setLeftView:spacerView2];
    passwordField.delegate = self;
    passwordField.placeholder = @"Password";
    passwordField.secureTextEntry = YES;
    passwordField.layer.cornerRadius=8.0f;
    passwordField.layer.masksToBounds=YES;
    //    passwordField.layer.borderColor=[[UIColor blackColor]CGColor];
    passwordField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    passwordField.layer.borderWidth= 1.0f;
    [self.view addSubview:passwordField];
    
    // Build login button
    //    confirm = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 225, 50)];
    confirm = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.704 - 100, 225, outerWindowHeight * 0.088)];
    confirm.layer.cornerRadius = 8.0; // this value vary as per your desire
    confirm.clipsToBounds = YES;
    [confirm setTitle:@"Confirm!" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [confirm.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    confirm.backgroundColor = [UIColor grayColor];
    [confirm addTarget:self action:@selector(confirmPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void) confirmPassword:(id)sender
{
    NSDictionary *dictionaryData = @{@"password": passwordField.text};

    // Object for error handling
    NSError* error;
    
    if ([JCCMakeRequests confirmPassword:dictionaryData withPotentialError:&error])
    {
        JCCEditProfileViewController *editProfileView = [[JCCEditProfileViewController alloc] init];
        [self.navigationController pushViewController:editProfileView animated:NO];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid" message:@"wrong password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
}

/***
 Resigns first responder status of the text field when it is no longer being edited.
 ***/
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [passwordField resignFirstResponder];
}


/***
 Dismisses the keyboard back to the bottom and moves text fields with it.
 ***/
-(void) dismissKeyboard
{
    [passwordField resignFirstResponder];
    
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
