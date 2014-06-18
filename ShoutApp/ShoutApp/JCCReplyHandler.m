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
#import "JCCBadConnectionViewController.h"

@implementation JCCReplyHandler


/***
 Moves to reply view
 ***/
+ (void)sendReply:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCReplyViewController *replyViewController = [[JCCReplyViewController alloc] init];
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    // set the text
//    [replyViewController passMessageId:cell.MessageIDLabel.text];
    
    [replyViewController setMessageId:cell.MessageIDLabel.text];
    [replyViewController setProfileImage:cell.ProfileImage];
    [replyViewController setNumberLikes:[cell.NumberOfUpsLabel.text integerValue]];
    [replyViewController setNumberDislikes:[cell.NumberOfDownsLabel.text integerValue]];
    [replyViewController setUserName:cell.UsernameLabel.text];
    [replyViewController setTimeLabel:cell.TimeLabel.text];
    if ([cell.UpLabel.backgroundColor isEqual:[UIColor blackColor]])
    {
        [replyViewController setUserLiked:YES];
    }
    else
    {
        [replyViewController setUserLiked:NO];
    }
    
    if ([cell.DownLabel.backgroundColor isEqual:[UIColor blackColor]])
    {
        [replyViewController setUserDisliked:YES];
    }
    else
    {
        [replyViewController setUserDisliked:NO];
    }
    
    [tableViewController.navigationController pushViewController:replyViewController animated:NO];
    
}

@end
