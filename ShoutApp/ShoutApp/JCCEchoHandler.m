//
//  JCCEchoHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCEchoHandler.h"
#import "JCCEchoViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCBadConnectionViewController.h"

@implementation JCCEchoHandler
// Happens when user touches the echo button

/***
 Moves to the Echo View controller
 ***/
+ (void)sendEcho:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCEchoViewController *echoViewController = [[JCCEchoViewController alloc] init];
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    [tableViewController.navigationController pushViewController:echoViewController animated:YES];
    // set the text
    [echoViewController setTextField:cell.MessageTextView.text];
    
}

@end
