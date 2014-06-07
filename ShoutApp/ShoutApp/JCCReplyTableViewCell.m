//
//  JCCReplyTableViewCell.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCReplyTableViewCell.h"
#import "AFNetworking.h"
#import "JCCUserCredentials.h"
#import "JCCBadConnectionViewController.h"
#import "JCCMuteHandler.h"
#import "JCCFeedTableViewController.h"
#import "JCCOtherUserViewController.h"
#import "JCCMakeRequests.h"

@implementation JCCReplyTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}



/***
 Asynchronously loads the profile image in the cell.
 ***/
- (void) loadProfileImageUsingDictionary:(NSDictionary *) dictShout
{
    __block NSData *profPicData = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/static/shout/images/"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         profPicData = (NSData*)responseObject;
         [self.ProfileImage setImage:[UIImage imageWithData:profPicData]];
         self.ProfileImage.layer.cornerRadius = 8.0;
         self.ProfileImage.layer.masksToBounds = YES;
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/***
 Transitions to the other user page.
 ***/
- (IBAction)transitionToUserPage:(id)sender
{
    JCCOtherUserViewController *otherViewController = [[JCCOtherUserViewController alloc] init];
    //    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    //    otherViewController.otherUsername = cell.UsernameLabel.text;
    //    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    otherViewController.otherUsername = self.UsernameLabel.text;
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.parentTableViewController.navigationController pushViewController:otherViewController animated:YES];
    }
}



/***
 Sets up the cell including the profile imafe, username label, time label, message text view, and more button.
 ***/
- (JCCReplyTableViewCell *)setUpCellWithDictionary:(NSDictionary *) dictShout
{
    // Asynchronously loads the profile image in the cell
    [self loadProfileImageUsingDictionary:dictShout];
    
    [self.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [self.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
    [self.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    self.InnerView.layer.cornerRadius = 8.0;
    self.InnerView.layer.masksToBounds = YES;
    
    [self.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    [self.ProfileImageButton addTarget:self action:@selector(transitionToUserPage:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}



/***
 Converts a UTC string to a date object.
 ***/
- (NSString *) formatTime:(NSString *) timeString
{
    NSString* input = timeString;
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *now = [NSDate date];
    
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:input];
    double timeInterval = [now timeIntervalSinceDate:utcDate];
    timeInterval = timeInterval + 37;
    
    // years
    if ((timeInterval) / 31536000 >= 1)
    {
        if ((int)(timeInterval) / 31536000 == 1)
        {
            return @"1 year ago";
        }
        else
            return [NSString stringWithFormat:@"%d years ago", (int)(timeInterval) / 31536000];
    }
    
    // days
    else if ((timeInterval) / 86400 >= 1)
    {
        if ((int)(timeInterval) / 86400 == 1)
            return @"1 day ago";
        else
            return [NSString stringWithFormat:@"%d days ago", (int)(timeInterval) / 86400];
    }
    
    // hours
    else if ((timeInterval) / 3600 >= 1)
    {
        if ((int)(timeInterval) / 3600 == 1)
            return @"1 hour ago";
        else
            return [NSString stringWithFormat:@"%d hours ago", (int)(timeInterval) / 3600];
    }
    
    // minutes
    else if ((timeInterval) / 60 >= 1)
    {
        if ((int)(timeInterval) / 60 == 1)
            return @"1 min ago";
        else
            return [NSString stringWithFormat:@"%d mins ago", (int)(timeInterval) / 60];
    }
    
    // Moments
    else if (timeInterval < 1)
        return [NSString stringWithFormat:@"right now"];
    
    // seconds
    else
        return [NSString stringWithFormat:@"%d secs ago", (int)timeInterval];
}


/***
 Displayes the mute option.
 ***/
- (IBAction)showMuteOption:(UIButton*)sender
{
    // post the dislike
    [JCCMuteHandler sendMute:sender fromTableViewController:self.parentTableViewController];
    if([(JCCFeedTableViewController*)self.parentTableViewController fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
        return;
    }
    else
    {
        [self.parentTableViewController.tableView reloadData];
    }
}

@end
