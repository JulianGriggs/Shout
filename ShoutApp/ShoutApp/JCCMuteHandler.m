//
//  JCCMuteHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCMuteHandler.h"
#import "JCCReplyTableViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCMakeRequests.h"
#import "JCCBadConnectionViewController.h"
#import "JCCUserCredentials.h"
#import "UIAlertView+Blocks.h"

@implementation JCCMuteHandler

// handles the mute option
+ (void)sendMute:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController
{
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
        if ([cell.UsernameLabel.text isEqualToString:sharedUserName])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mute" message:@"You can't mute yourself!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [UIAlertView showWithTitle:@"Mute"
                               message:@"You will never be able to receive shouts from this person again.  Are you sure you want to mute this person?"
                     cancelButtonTitle:@"No"
                     otherButtonTitles:@[@"Yes"]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"])
                                  {
                                      if([JCCMakeRequests postMute:[cell.UsernameLabel text]] == nil)
                                      {
                                          JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
                                          [tableViewController.navigationController pushViewController:badView animated:NO];
                                      }
                                      [tableViewController.tableView reloadData];
                                  }
                              }];
        }
    }
}

@end
