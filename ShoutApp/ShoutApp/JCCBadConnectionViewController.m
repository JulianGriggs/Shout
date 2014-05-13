//
//  JCCBadConnectionViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/13/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCBadConnectionViewController.h"
#import "JCCAppDelegate.h"
#import "JCCMakeRequests.h"

@interface JCCBadConnectionViewController ()

@end

@implementation JCCBadConnectionViewController

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
    
    // hide the back button
    self.navigationItem.hidesBackButton = YES;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Create Logo Image
    UIImage *logoImage = [UIImage imageNamed:@"gorilla.png"];
    //    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 75, 225, 210)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(outerWindowWidth * 0.15625, outerWindowHeight * 0.132, outerWindowWidth * 0.703, outerWindowHeight * 0.370)];
    
    [imageView setImage:logoImage];
    [self.view addSubview:imageView];
    
    
    //  set black background color
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UITextView *badInternetView = [[UITextView alloc] initWithFrame:CGRectMake(outerWindowWidth * 0.15625, outerWindowHeight * 0.532, outerWindowWidth * 0.703, outerWindowHeight * 0.370)];
    badInternetView.backgroundColor = [UIColor blackColor];
    badInternetView.textAlignment = NSTextAlignmentCenter;
    badInternetView.textColor = [UIColor whiteColor];
    [badInternetView setUserInteractionEnabled:NO];
    badInternetView.text = @"I have some bad news friend. It appears your internet connection is poor. In order for this app to work properly you need a better connection. Please press \"Try Again\" to test your connection and get back to enjoying Shout!";
    [self.view addSubview:badInternetView];
    
    //  add a button to test the internet connection
    UIButton *tryAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.836, 225, outerWindowHeight * 0.088)];
    tryAgainButton.backgroundColor = [UIColor blackColor];
    [tryAgainButton setTitle:@"Try Again" forState:UIControlStateNormal];
    [tryAgainButton addTarget:self action:@selector(tryAgainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tryAgainButton];
}

//  try again
-(IBAction)tryAgainButtonPressed:(id)sender
{
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        [JCCMakeRequests displayLackOfInternetAlert];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
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
