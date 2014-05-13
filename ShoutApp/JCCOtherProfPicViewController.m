//
//  JCCOtherProfPicViewController.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/12/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCOtherProfPicViewController.h"

@interface JCCOtherProfPicViewController ()

@end

@implementation JCCOtherProfPicViewController
{
    UIImage *newProfImage;
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





// Called the first time the view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.imageView setImage:self.profPicture];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
