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

@interface JCCLoginViewController ()

@end

@implementation JCCLoginViewController
{
    UITextField *userNameField;
    UITextField *passwordField;
    UIButton *loginButton;
    UIImage *logoImage;
    UIImageView *imageView;
    UIButton *registerButton;
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
    [imageView setFrame:CGRectMake(50, 50, 225, 100)];
    [userNameField setFrame:CGRectMake(50, 130, 225, 50)];
    [passwordField setFrame:CGRectMake(50, 180, 225, 50)];
    [loginButton setFrame:CGRectMake(50, 240, 225, 50)];
    [registerButton setFrame:CGRectMake(50, 300, 225, 50)];
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
    [imageView setFrame:CGRectMake(50, 175, 225, 100)];
    [userNameField setFrame:CGRectMake(50, 275, 225, 50)];
    [passwordField setFrame:CGRectMake(50, 325, 225, 50)];
    [loginButton setFrame:CGRectMake(50, 400, 225, 50)];
    [registerButton setFrame:CGRectMake(50, 475, 225, 50)];
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
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        
        // authentication
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

        NSLog(@"LOGIN REPLY: %@", GETReply);
         NSLog(@"theReply: %@", theReply);
        // They didn't give a valid username / password
        
        
        
        if ([theReply rangeOfString:@"token"].location == NSNotFound)
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
            
            
            /***********************************************************/
            // Sets the username and token for this session of the app
            sharedUserName = userNameField.text;
            sharedUserToken = token;
            /***********************************************************/
            
            // Restores the default values
            /*------------------------*/
            userNameField.text = @"";
            passwordField.text = @"";
            [self dismissKeyboard];
            /*------------------------*/
            
            [self addMainViewControllers];
        }
        
    }
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 175, 225, 100)];
    [imageView setImage:logoImage];
    [self.view addSubview:imageView];
    
    // Create the email field
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 275, 225, 50)];
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
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 325, 225, 50)];
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
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 225, 50)];
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
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 475, 225, 50)];
    [registerButton setTitle:@"Sign Up For Shout" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [registerButton addTarget:self action:@selector(moveToRegistration:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

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
