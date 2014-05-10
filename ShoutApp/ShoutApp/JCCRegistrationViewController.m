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
#import "JCCMakeRequests.h"

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
        [imageView setFrame:CGRectMake(135, 75, 55, 50)];
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
        [imageView setFrame:CGRectMake(80, 75, 160, 145)];
        [userNameField setFrame:CGRectMake(50, 225, 225, 50)];
        [passwordField setFrame:CGRectMake(50, 275, 225, 50)];
        [emailField setFrame:CGRectMake(50, 325, 225, 50)];
        [registerButton setFrame:CGRectMake(50, 400, 225, 50)];
    }];
}





-(void) setUserCredentials:(NSString *)token
{
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
        // Object with username, password, and email address
        NSDictionary *dictionaryData = @{@"username": userNameField.text, @"password": passwordField.text, @"email": emailField.text};
        
        // Attempts the registration
        if ([JCCMakeRequests attemptRegistration:dictionaryData])
        {
            // Attemps to login as new user
            NSString *token = [JCCMakeRequests attemptAuth:dictionaryData];
            if (token)
            {
                [self setUserCredentials:token];
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
    loginView.backgroundColor = [UIColor blackColor];
    self.view = loginView;
    
    // Adds a tap gesture so that text fields resign first responder on a tap outside
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    // Create Logo Image
    logoImage = [UIImage imageNamed:@"gorilla.png"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 75, 160, 145)];
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
    [backToLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backToLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [backToLoginButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [backToLoginButton addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backToLoginButton];
    
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
