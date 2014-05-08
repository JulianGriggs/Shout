//
//  JCCRegistrationViewController.m
//  ShoutApp
//
//  Created by Julian Griggs on 4/22/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCRegistrationViewController.h"
#import "JCCUserCredentials.h"
#import "JCCUserViewController.h"
#import "JCCViewController.h"


@interface JCCRegistrationViewController ()

@end

@implementation JCCRegistrationViewController
{
    UITextField *userNameField;
    UITextField *emailField;
    UITextField *passwordField;
    
    UIImage *logoImage;
    UIImageView *imageView;
    UIButton *registerButton;
    UIButton *backToLoginButton;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



// Handles how pressing the return key in the keyboard should page through the text fields
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == userNameField)
        [passwordField becomeFirstResponder];
    else if(textField == passwordField)
        [emailField becomeFirstResponder];
    else
        [userNameField becomeFirstResponder];
    
    return NO;
}




// Animation upon beginning the editing of text fields
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        [imageView setFrame:CGRectMake(50, 50, 225, 100)];
        [userNameField setFrame:CGRectMake(50, 130, 225, 50)];
        [passwordField setFrame:CGRectMake(50, 180, 225, 50)];
        [emailField setFrame:CGRectMake(50, 230, 225, 50)];
        [registerButton setFrame:CGRectMake(50, 295, 225, 50)];
//        [backToLoginButton setFrame:CGRectMake(50, 300, 225, 50)];
    }];
    
}



// Animation upon ending the editing of text fields
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}




// Animates the dismissal of the keyboard and the text fields
-(void) dismissKeyboard {
    [userNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        [imageView setFrame:CGRectMake(50, 125, 225, 100)];
        [userNameField setFrame:CGRectMake(50, 225, 225, 50)];
        [passwordField setFrame:CGRectMake(50, 275, 225, 50)];
        [emailField setFrame:CGRectMake(50, 325, 225, 50)];
        [registerButton setFrame:CGRectMake(50, 400, 225, 50)];
//        [backToLoginButton setFrame:CGRectMake(50, 475, 225, 50)];
    }];
}


// Attempts the the registration.  Upon success YES is returned.  Upon failure, NO is returned.
-(BOOL) attemptRegistration
{
    //  format the data
    NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text, @"email": emailField.text};
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // Registration    
    [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/users/register/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    //NSLog(@"Registration GETReply: %@", GETReply);
    //NSLog(@"Registration theReply: %@", theReply);
    
    if ([theReply isEqualToString:@"error"])
    {
        return NO;  // Failure (Username probably alreday exists)
    }
    
    else
    {
        return YES; // Success
    }

}

// Attempts the login.  Upon success, the global variables for username and token are updated and YES is returned.  Upon failure, NO is returned.
-(BOOL)attemptAuth
{
    //  format the data
    NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    // authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", userNameField.text, passwordField.text];
    //NSLog(@"%@ %@", userNameField.text, passwordField.text);
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
    
    //NSLog(@"%@", GETReply);
    
    if (GETReply == nil) return NO; // Failure (Probably didn't give a valid username / password)

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
        NSLog((@"Registered Username: %@ \n Registered Token: %@"), sharedUserName, sharedUserToken);
        // Restores the default values
        /*------------------------*/
        userNameField.text = @"";
        emailField.text = @"";
        passwordField.text = @"";
        [self dismissKeyboard];
        /*------------------------*/
    }
    return YES; //Success (global username and token have been stored)

}



// Returns back to the login screen
-(IBAction)backToLogin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



// Validates email address
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}




// Does error checking and field validation before attempting a registration/login
- (IBAction)postLogin:(id)sender
{
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
    }
    
    // Makes sure that the email given is a valid email address
    else if(![self validateEmailWithString:emailField.text])
    {
        NSString *errorMessage = [NSString stringWithFormat:@"Your email address is not valid.  Please provide a valid email address."];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:errorMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
        
    
    else
    {
        if ([self attemptRegistration])
        {
            if ([self attemptAuth])
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
        
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Your username/password combination doesn't appear to belong to an account!  Please check your login information and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                passwordField.text = @"";
            
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Registration" message:@"This username already belongs to an account!  Please choose a different username." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];

        }
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 125, 225, 100)];
    [imageView setImage:logoImage];
    [self.view addSubview:imageView];
    
    UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    // Create the email field
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 225, 225, 50)];
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
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 275, 225, 50)];
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
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(50, 325, 225, 50)];
    [emailField setLeftViewMode:UITextFieldViewModeAlways];
    [emailField setLeftView:spacerView3];
    emailField.delegate = self;
    emailField.placeholder = @"Email";
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
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 225, 50)];
    registerButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    registerButton.clipsToBounds = YES;
    [registerButton setTitle:@"Register!" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    registerButton.backgroundColor = [UIColor grayColor];
    [registerButton addTarget:self action:@selector(postLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    // Register new username
    backToLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 475, 225, 50)];
    [backToLoginButton setTitle:@"Back to Login" forState:UIControlStateNormal];
    [backToLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backToLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [backToLoginButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [backToLoginButton addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToLoginButton];
    
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
