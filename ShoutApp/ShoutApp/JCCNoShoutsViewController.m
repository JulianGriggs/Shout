//
//  JCCNoShoutsViewController.m
//  ShoutApp
//
//  Created by Julian Griggs on 6/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCNoShoutsViewController.h"
#import "JCCAppDelegate.h"

@interface JCCNoShoutsViewController ()

@end

@implementation JCCNoShoutsViewController

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
    
    UITextView *noShoutsView = [[UITextView alloc] initWithFrame:CGRectMake(outerWindowWidth * 0.15625, outerWindowHeight * 0.532, outerWindowWidth * 0.703, outerWindowHeight * 0.370)];
    noShoutsView.backgroundColor = [UIColor blackColor];
    noShoutsView.textAlignment = NSTextAlignmentCenter;
    noShoutsView.textColor = [UIColor whiteColor];
    [noShoutsView setUserInteractionEnabled:NO];
    noShoutsView.text = @"There doesn't appear to be anyone Shouting in this area.  Click the \"Compose\" Icon in the upper right of the screen to become the first!";
    [self.view addSubview:noShoutsView];
    
//    //  add a button to test the internet connection
//    UIButton *tryAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(50, outerWindowHeight * 0.836, 225, outerWindowHeight * 0.088)];
//    tryAgainButton.backgroundColor = [UIColor blackColor];
//    [tryAgainButton setTitle:@"Compose" forState:UIControlStateNormal];
//    [tryAgainButton addTarget:self action:@selector(tryAgainButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:tryAgainButton];
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
