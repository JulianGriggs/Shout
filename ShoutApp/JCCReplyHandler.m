//
//  JCCReplyHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCReplyHandler.h"
#import "JCCReplyTableViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCMakeRequests.h"

@implementation JCCReplyHandler

+ (void)sendReply:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCReplyViewController *replyViewController = [[JCCReplyViewController alloc] init];
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [tableViewController.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        // set the text
        [replyViewController passMessageId:cell.MessageIDLabel.text];
        
        [tableViewController.navigationController pushViewController:replyViewController animated:YES];
    }
}

@end
