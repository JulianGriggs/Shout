//
//  JCCEditProfileViewController.m
//  ShoutApp
//
//  Created by Cole McCracken on 6/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#warning TODO remove unnecesarry imports

#import "JCCEditProfileViewController.h"
#import "JCCAppDelegate.h"
#import "JCCLoginViewController.h"
#import "JCCFeedTableViewController.h"
#import "JCCUserViewController.h"
#import "JCCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCUserCredentials.h"
#import "JCCRegistrationViewController.h"
#import "JCCMakeRequests.h"

@interface JCCEditProfileViewController ()

@end

@implementation JCCEditProfileViewController
{
    UITextField *userNameField;
    UITextField *passwordField;
    UITextField *passwordConfirmField;
    UITextField *emailField;
    UIButton *updateButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/***
 Makes it so that pressing the return key toggles between fields.
 ***/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == userNameField)
        [passwordField becomeFirstResponder];
    else if(textField == passwordField)
        [passwordConfirmField becomeFirstResponder];
    else if(textField == passwordConfirmField)
        [emailField becomeFirstResponder];
    else
        [userNameField becomeFirstResponder];
    
    return NO;
}



/***
 Animates up upon beginning the editing of text fields.
 ***/
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        [userNameField setFrame:CGRectMake(50, outerWindowHeight * 0.1588, 225, outerWindowHeight * 0.07)];
        [passwordField setFrame:CGRectMake(50, outerWindowHeight * 0.2289, 225, outerWindowHeight * 0.07)];
        [passwordConfirmField setFrame:CGRectMake(50, outerWindowHeight * 0.299, 225, outerWindowHeight * 0.07)];
        [emailField setFrame:CGRectMake(50, outerWindowHeight * 0.37, 225, outerWindowHeight * 0.07)];
        [updateButton setFrame:CGRectMake(50, outerWindowHeight * 0.47, 225, outerWindowHeight * 0.07)];
        //        [backToLoginButton setFrame:CGRectMake(50, 300, 225, 50)];
    }];
    
}



/***
 Resigns first responder status upon finished editing of text field.
 ***/
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}



/***
 Animates down the dismissal of the keyboard and the text fields.
 ***/
-(void) dismissKeyboard {
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [passwordConfirmField resignFirstResponder];
    [emailField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        [userNameField setFrame:CGRectMake(50, outerWindowHeight * 0.308, 225, outerWindowHeight * 0.088)];
        [passwordField setFrame:CGRectMake(50, outerWindowHeight * 0.396, 225, outerWindowHeight * 0.088)];
        [passwordConfirmField setFrame:CGRectMake(50, outerWindowHeight * 0.484, 225, outerWindowHeight * 0.088)];
        [emailField setFrame:CGRectMake(50, outerWindowHeight * 0.572, 225, outerWindowHeight * 0.088)];
        [updateButton setFrame:CGRectMake(50, outerWindowHeight * .704, 225, outerWindowHeight * 0.088)];
    }];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor blackColor];
    self.view = loginView;
    
    // Adds a tap gesture so that text fields resign first responder on a tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    // Create the email field
    //    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 225, 225, 50)];
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.308, 225, outerWindowHeight * 0.088)];
    [userNameField setLeftViewMode:UITextFieldViewModeAlways];
    [userNameField setLeftView:spacerView1];
    userNameField.delegate = self;
    userNameField.placeholder = @"New Username";
    [userNameField setAutocorrectionType: UITextAutocorrectionTypeNo];
    userNameField.layer.cornerRadius=8.0f;
    userNameField.layer.masksToBounds=YES;
    //    userNameField.layer.borderColor=[[UIColor blackColor]CGColor];
    userNameField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    userNameField.layer.borderWidth= 1.0f;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:userNameField];
    
    // Create the password field
    //    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 275, 225, 50)];
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.392, 225, outerWindowHeight * 0.088)];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordField setLeftView:spacerView2];
    passwordField.delegate = self;
    passwordField.placeholder = @"New Password";
    passwordField.secureTextEntry = YES;
    passwordField.layer.cornerRadius=8.0f;
    passwordField.layer.masksToBounds=YES;
    //    passwordField.layer.borderColor=[[UIColor blackColor]CGColor];
    passwordField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    passwordField.layer.borderWidth= 1.0f;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordField];
    
    
    // Create the password field
    //    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 275, 225, 50)];
    passwordConfirmField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.484, 225, outerWindowHeight * 0.088)];
    [passwordConfirmField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordConfirmField setLeftView:spacerView3];
    passwordConfirmField.delegate = self;
    passwordConfirmField.placeholder = @"Confirm New Password";
    passwordConfirmField.secureTextEntry = YES;
    passwordConfirmField.layer.cornerRadius=8.0f;
    passwordConfirmField.layer.masksToBounds=YES;
    //    passwordConfirmField.layer.borderColor=[[UIColor blackColor]CGColor];
    passwordConfirmField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    passwordConfirmField.layer.borderWidth= 1.0f;
    [self.view addSubview:passwordConfirmField];

    
    
    // Build login button
    //    emailField = [[UITextField alloc] initWithFrame:CGRectMake(50, 325, 225, 50)];
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.572, 225, outerWindowHeight * 0.088)];
    [emailField setLeftViewMode:UITextFieldViewModeAlways];
    [emailField setLeftView:spacerView4];
    emailField.delegate = self;
    emailField.placeholder = @"New Email";
    [emailField setAutocorrectionType: UITextAutocorrectionTypeNo];
    emailField.layer.cornerRadius=8.0f;
    emailField.layer.masksToBounds=YES;
    //    emailField.layer.borderColor=[[UIColor blackColor]CGColor];
    emailField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    emailField.layer.borderWidth= 1.0f;
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:emailField];
    
    
    // Register new username
    //    updateButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 225, 50)];
    updateButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * .704, 225, outerWindowHeight * 0.088)];
    updateButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    updateButton.clipsToBounds = YES;
    [updateButton setTitle:@"Register!" forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [updateButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    updateButton.backgroundColor = [UIColor grayColor];
    [updateButton addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateButton];

}

-(IBAction)editProfile:(id)sender
{
    /***
     Does error checking and field validation before attempting a registration/login.
     ***/
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    int MAX_USERNAME_LENGTH = 15;
    
        // Makes sure that the username is less than max length characters long
    if (userNameField.text.length > MAX_USERNAME_LENGTH)
    {
        NSString *errorMessage = [NSString stringWithFormat:@"Your username is too long!  Must be less than %d characters.", MAX_USERNAME_LENGTH];
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
        
    // Makes sure that no fields are left blank
    else if (([[userNameField.text stringByTrimmingCharactersInSet: set] length] == 0) || ([[passwordField.text stringByTrimmingCharactersInSet: set] length] == 0) || ([[emailField.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        [self dismissKeyboard];
        NSString *errorMessage = [NSString stringWithFormat:@"You must enter something in all fields."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    else if (![passwordField.text isEqualToString:passwordConfirmField.text])
    {
        NSLog(@"more cunt blasters");
        NSLog(passwordField.text);
        NSLog(passwordConfirmField.text);
        NSString *errorMessage = [NSString stringWithFormat:@"Your passwords are not the same"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];

    }

#warning TODO uncomment
    /*    // Makes sure that the email given is a valid email address
         else if(![self validateEmailWithString:emailField.text])
         {
         NSString *errorMessage = [NSString stringWithFormat:@"Your email address is not valid.  Please provide a valid email address."];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
         [alert show];
         }
         */
    else
    {
        // Object with username, password, and email address
        NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text, @"email": emailField.text};
            
        // Attempts the registration
        if ([JCCMakeRequests editProfile:dictionaryData])
        {
            NSLog(@"cunt blasters"); // hehe
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid" message:@"This username already belongs to an account!  Please choose a different username." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
    }
    


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
