//
//  JCCForgotPasswordViewController.m
//  ShoutApp
//
//  Created by Cole McCracken on 6/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCForgotPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCAppDelegate.h"
#import "JCCMakeRequests.h"

@interface JCCForgotPasswordViewController ()

@end

@implementation JCCForgotPasswordViewController
{
    UITextField *emailField;
    UIButton *resetPasswordButton;
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
 Moves to forgot your password page by adding it to the stack
 ***/
-(IBAction)resetPassword:(id)sender
{
    NSError* error;
    NSDictionary *dictionaryData = @{@"email":emailField.text};
    
    BOOL response = [JCCMakeRequests attemptResetPassword:dictionaryData withPotentialError:&error];
    if (response) {
        [resetPasswordButton setTitle:@"success" forState:(UIControlStateNormal)];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [resetPasswordButton setTitle:@"failure" forState:(UIControlStateNormal)];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.184, 225, outerWindowHeight * 0.088)];
    emailField.delegate = self;
    emailField.placeholder = @"email";
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
    
    resetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.360, 225, outerWindowHeight * 0.088)];
    resetPasswordButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    resetPasswordButton.clipsToBounds = YES;
    [resetPasswordButton setTitle:@"resetPassword!" forState:UIControlStateNormal];
    [resetPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [resetPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    resetPasswordButton.backgroundColor = [UIColor grayColor];
    [resetPasswordButton addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetPasswordButton];
    

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
