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


/***
 Creates the view.
 ***/
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



/***
 Tests the internet connection to see if the user has internet.
 ***/
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

@end
