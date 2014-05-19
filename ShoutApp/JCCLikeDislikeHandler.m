//
//  JCCLikeDislikeHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCLikeDislikeHandler.h"
#import "JCCTableViewCell1.h"
#import "JCCMakeRequests.h"

@implementation JCCLikeDislikeHandler


// Send the like
+ (void)sendUp:(UIButton*)sender fromTableViewController: (UITableViewController *)tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    // If black set to white, else set to black
    if ([cell.UpLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "down" button to black
        [cell.DownLabel setTextColor:[UIColor blackColor]];
        cell.DownLabel.backgroundColor = [UIColor whiteColor];
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor whiteColor]];
        cell.UpLabel.backgroundColor = [UIColor blackColor];
        cell.UpLabel.layer.cornerRadius = 8.0;
        cell.UpLabel.layer.masksToBounds = YES;
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor blackColor]];
        cell.UpLabel.backgroundColor = [UIColor whiteColor];
    }
    
    // post the like
    if([JCCMakeRequests postLike:getMessageID] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [tableViewController.navigationController pushViewController:badView animated:NO];
        return;
    }
}




// Happens whenever a user clicks the "DOWN" button
+ (void)sendDown:(UIButton*)sender fromTableViewController:(UITableViewController *) tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    // If black set to white, else set to black
    if ([cell.DownLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "up" button to black
        [cell.UpLabel setTextColor:[UIColor blackColor]];
        cell.UpLabel.backgroundColor = [UIColor whiteColor];
        // Sets the color of the "down" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor whiteColor]];
        cell.DownLabel.backgroundColor = [UIColor blackColor];
        cell.DownLabel.layer.cornerRadius = 8.0;
        cell.DownLabel.layer.masksToBounds = YES;
        
    }
    
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor blackColor]];
        cell.DownLabel.backgroundColor = [UIColor whiteColor];
    }
    
    // post the dislike
    if([JCCMakeRequests postDislike:getMessageID] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [tableViewController.navigationController pushViewController:badView animated:NO];
        return;
    }
}


@end
