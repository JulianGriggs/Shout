//
//  JCCErrorHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 6/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCErrorHandler.h"
#import "JCCBadConnectionViewController.h"

@implementation JCCErrorHandler

+(void) displayErrorView:(UIViewController*) parent withError:(NSError*) error
{
    JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
    [badView setMessage:error.localizedDescription];
    badView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    badView.delegate = (id)parent;
    [parent presentViewController:badView animated:YES completion:nil];
}

@end
