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


@interface JCCLoginViewController ()

@end

@implementation JCCLoginViewController
{
    UITextField *userNameField;
    UITextField *passwordField;
    UIButton *loginButton;
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
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void) dismissKeyboard {
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)postLogin:(id)sender
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (userNameField.text.length > 30)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Your username is too long!  Must be less than 30 characters." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else if ([[userNameField.text stringByTrimmingCharactersInSet: set] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You didn't enter a username!  Try again!"  delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    
        //  format the data
        NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text};
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        
        // authentication
        //        Hard coded works for some reason
        //        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"blirby", @"blirby"];
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", userNameField.text, passwordField.text];
        NSLog(@"%@ %@", userNameField.text, passwordField.text);
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        NSLog(@"%@", authValue);
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/login"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        NSLog(@"%@", theReply);
        
        // Make Sure the response says it is valid

        
        // Created the user view controller
        JCCUserViewController *userViewController = [[JCCUserViewController alloc] init];
        // Sets the username field to the appropriate value
        userViewController.userName = userNameField.text;
        userViewController.password = passwordField.text;
//        userViewController.userName = @"blirby";
//        userViewController.password = @"blirby";
        
        // Created the table view controller
        JCCViewController *viewController = [[JCCViewController alloc] init];
        // Sets the username field to the appropriate value
        viewController.userName = userNameField.text;
        viewController.password = passwordField.text;
//        viewController.userName = @"blirby";
//        viewController.password = @"blirby";
        

        [self.navigationController pushViewController:userViewController animated:NO];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //  build the view
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor whiteColor];
    self.view = loginView;

    // Adds a tap gesture so that text fields resign first responder on a tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Create the email field
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 75, 225, 50)];
    userNameField.delegate = self;
    userNameField.placeholder = @" Username";
    [userNameField setAutocorrectionType: UITextAutocorrectionTypeNo];
    userNameField.layer.cornerRadius=8.0f;
    userNameField.layer.masksToBounds=YES;
    userNameField.layer.borderColor=[[UIColor blackColor]CGColor];
    userNameField.layer.borderWidth= 1.0f;
    [self.view addSubview:userNameField];

    
    // Create the password field
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 175, 225, 50)];
    passwordField.delegate = self;
    passwordField.placeholder = @" Password";
    passwordField.secureTextEntry = YES;
    passwordField.layer.cornerRadius=8.0f;
    passwordField.layer.masksToBounds=YES;
    passwordField.layer.borderColor=[[UIColor blackColor]CGColor];
    passwordField.layer.borderWidth= 1.0f;
    [self.view addSubview:passwordField];
    
    // Build login button
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 490, 175, 50)];
    loginButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    loginButton.clipsToBounds = YES;
    [loginButton setTitle:@"Login!" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton addTarget:self action:@selector(postLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Remove back button in top navigation
    self.navigationItem.hidesBackButton = YES;
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
