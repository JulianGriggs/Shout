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
    UIImage *logoImage;
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
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/api-token-auth/"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];

        // They didn't give a valid username / password
        if (GETReply == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Your username/password combination doesn't appear to belong to an account!  Please check your login information and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            passwordField.text = @"";
        }
        
        else
        {
            // This parses the response from the server as a JSON object
            NSDictionary *loginToken = [NSJSONSerialization JSONObjectWithData: GETReply options:kNilOptions error:nil];
            //NSLog(@"%@", loginToken);
            NSString *token = [loginToken objectForKey:@"token"];
            // Make Sure the response says it is valid

        
            // Created the user view controller
            JCCUserViewController *userViewController = [[JCCUserViewController alloc] init];
            // Sets the username field to the appropriate value
            userViewController.userName = userNameField.text;
            userViewController.token = token;
            NSLog(@"login token: %@", token);
        
            // Created the table view controller
            JCCViewController *viewController = [[JCCViewController alloc] init];
            // Sets the username field to the appropriate value
            viewController.userName = userNameField.text;
            viewController.token = token;
        

            [self.navigationController pushViewController:userViewController animated:NO];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //  build the view
    UIView *loginView = [[UIView alloc] init];
    loginView.backgroundColor = [UIColor lightGrayColor];
    self.view = loginView;

    // Adds a tap gesture so that text fields resign first responder on a tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Create Logo Image
    logoImage = [UIImage imageNamed:@"ShoutIcon.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 75,225, 100)];
    [imageView setImage:logoImage];
    [self.view addSubview:imageView];
    
    // Create the email field
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 175, 225, 50)];
    userNameField.delegate = self;
    userNameField.placeholder = @" Username";
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
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 225, 225, 50)];
    passwordField.delegate = self;
    passwordField.placeholder = @" Password";
    passwordField.secureTextEntry = YES;
    passwordField.layer.cornerRadius=8.0f;
    passwordField.layer.masksToBounds=YES;
//    passwordField.layer.borderColor=[[UIColor blackColor]CGColor];
    passwordField.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    passwordField.layer.borderWidth= 1.0f;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordField];
    
    // Build login button
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 225, 50)];
    loginButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    loginButton.clipsToBounds = YES;
    [loginButton setTitle:@"Login!" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor grayColor];
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
