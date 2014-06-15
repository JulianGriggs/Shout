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
{

}

/***
 Displays the alert modal upon clicking the alert button.  If the user then confirms their decision to mute the author of the shout they selected, then a synchronous mute is sent to the server.  Otherwise, the modal disappears.  If a user tries to mute themselves, a modal pops up informing them that this is not a permitted action.
 ***/
+ (void)sendMute:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
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
                                  // Object for error handling
                                  NSError* error;
                                  
                                  [JCCMakeRequests postMute:[cell.UsernameLabel text] withPotentialError:error];
                                  [tableViewController.tableView reloadData];
                              }
                          }];
    }
    
}

@end
