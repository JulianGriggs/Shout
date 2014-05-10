//
//  JCCLoginViewController.m
//  ShoutApp
//
//  Created by Julian Griggs on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCLoginViewController.h"
#import "JCCFeedTableViewController.h"
#import "JCCUserViewController.h"
#import "JCCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCUserCredentials.h"
#import "JCCRegistrationViewController.h"
#import "JCCMakeRequests.h"

@interface JCCLoginViewController ()
//CGFloat fourInch = 568;
@end

@implementation JCCLoginViewController
{
    UITextField *userNameField;
    UITextField *passwordField;
    UIButton *loginButton;
    UIImage *logoImage;
    UIImageView *imageView;
    UIButton *registerButton;
    CGFloat outerWindowHeight; // 568 on 4 inch screen ----- 480 on 2.5 inch
    CGFloat outerWindowWidth;  // 320 on 4 inch screen ----- 480 on 3.5 inch
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == userNameField)
        [passwordField becomeFirstResponder];
    else
        [userNameField becomeFirstResponder];
    
    return NO;
}





- (void) textFieldDidBeginEditing:(UITextField *)textField
{

        [UIView animateWithDuration:0.25 animations:^{
            [imageView setFrame:CGRectMake(outerWindowWidth * 0.4218, outerWindowHeight * 0.1327, outerWindowWidth * 0.1718, outerWindowHeight * 0.088)];
            [userNameField setFrame:CGRectMake(50, outerWindowHeight * 0.2288, 225, outerWindowHeight * 0.088)];
            [passwordField setFrame:CGRectMake(50, outerWindowHeight * 0.3169, 225, outerWindowHeight * 0.088)];
            [loginButton setFrame:CGRectMake(50, outerWindowHeight * 0.42, 225, outerWindowHeight * 0.088)];
            [registerButton setFrame:CGRectMake(50, outerWindowHeight * 0.49, 225, outerWindowHeight * 0.088)];
        }];

    
}




- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void) dismissKeyboard {
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [imageView setFrame:CGRectMake(outerWindowWidth * 0.15625, outerWindowHeight * 0.132, outerWindowWidth * 0.703, outerWindowHeight * 0.370)];
        [userNameField setFrame:CGRectMake(50, outerWindowHeight * 0.484, 225, outerWindowHeight * 0.088)];
        [passwordField setFrame:CGRectMake(50, outerWindowHeight * 0.572, 225, outerWindowHeight * 0.088)];
        [loginButton setFrame:CGRectMake(50, outerWindowHeight * 0.704, 225, outerWindowHeight * 0.088)];
        [registerButton setFrame:CGRectMake(50, outerWindowHeight * 0.836, 225, outerWindowHeight * 0.088)];
    }];
}

- (IBAction)postLogin:(id)sender
{
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (userNameField.text.length > 30)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Your username is too long!  Must be less than 30 characters." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    else if (([[userNameField.text stringByTrimmingCharactersInSet: set] length] == 0) || ([[passwordField.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
         [self dismissKeyboard];
    }
    
    else
    {
    
        //  format the data
        NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text};
        NSString *token = [JCCMakeRequests attemptAuth:dictionaryData];

        if (token)
        {
            [self setUserCredentials:token];
            [self addMainViewControllers];
        }
        
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Your username/password combination doesn't appear to belong to an account!  Please check your login information and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            passwordField.text = @"";
        }
    }
}




-(void) setUserCredentials:(NSString *)token
{
    // Sets the username and token for this session of the app
    sharedUserName = userNameField.text;
    sharedUserToken = token;

    // Restores the default values
    userNameField.text = @"";
    passwordField.text = @"";
    [self dismissKeyboard];
}



-(void) addMainViewControllers
{
    // Created the user view controller
    JCCUserViewController *userViewController = [[JCCUserViewController alloc] init];
    // Created the table view controller
    JCCViewController *viewController = [[JCCViewController alloc] init];
    
    [self.navigationController pushViewController:userViewController animated:NO];
    [self.navigationController pushViewController:viewController animated:NO];

}



-(IBAction)moveToRegistration:(id)sender
{
    JCCRegistrationViewController *registration = [[JCCRegistrationViewController alloc]init];
    [self.navigationController pushViewController:registration animated:YES];
}




// Returns YES upon success, and NO upon failure
-(BOOL)attemptAuthWithToken
{
    if ([sharedUserToken isEqual: @""])
        return NO;
    
    else return YES;
}



-(void)viewWillAppear:(BOOL)animated
{
//    // Remove back button in top navigation
    self.navigationItem.hidesBackButton = YES;
    if ([self attemptAuthWithToken])
        [self addMainViewControllers];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //  build the view
    
    // Sets the instance variable containing the size of the outer window
    outerWindowHeight = self.view.frame.size.height;
    outerWindowWidth = self.view.frame.size.width;
        NSLog(@"window width: %f", outerWindowWidth);
    NSLog(@"window height: %f", outerWindowHeight);

    
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor blackColor];
    self.view = loginView;

    // Adds a tap gesture so that text fields resign first responder on a tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Create Logo Image
    logoImage = [UIImage imageNamed:@"gorilla.png"];
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 75, 225, 210)];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(outerWindowWidth * 0.15625,
                                                              outerWindowHeight * 0.132,
                                                              outerWindowWidth * 0.703,
                                                              outerWindowHeight * 0.370)];

    [imageView setImage:logoImage];
    [self.view addSubview:imageView];
    
    // Create the email field
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];

//    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 275, 225, 50)];
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.484, 225, outerWindowHeight * 0.088)];

    [userNameField setLeftViewMode:UITextFieldViewModeAlways];
    [userNameField setLeftView:spacerView1];
    userNameField.delegate = self;
    userNameField.placeholder = @"Username";
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
//    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 325, 225, 50)];
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.572, 225, outerWindowHeight * 0.088)];

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
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordField];
    
    // Build login button
//    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 225, 50)];
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.704, 225, outerWindowHeight * 0.088)];
    loginButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    loginButton.clipsToBounds = YES;
    [loginButton setTitle:@"Login!" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    loginButton.backgroundColor = [UIColor grayColor];
    [loginButton addTarget:self action:@selector(postLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Register new username
//    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 475, 225, 50)];
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.836, 225, outerWindowHeight * 0.088)];
    [registerButton setTitle:@"Sign Up For Shout!" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [registerButton addTarget:self action:@selector(moveToRegistration:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

    // Remove back button in top navigation
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitle:@"SHOUT!"];
    
    
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
