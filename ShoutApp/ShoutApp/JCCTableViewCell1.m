//
//  JCCTableViewCell1.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/9/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCTableViewCell1.h"
#import "JCCLikeDislikeHandler.h"
#import "JCCReplyHandler.h"
#import "JCCEchoHandler.h"
#import "JCCMuteHandler.h"
#import "JCCMakeRequests.h"
#import "JCCUserCredentials.h"
#import "AFNetworking.h"

@implementation JCCTableViewCell1



// Send the like
- (IBAction)sendUp:(UIButton*)sender
{
    // post the like
    [JCCLikeDislikeHandler sendUp:sender fromTableViewController:self.parentTableViewController];
}




// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    // post the dislike
    [JCCLikeDislikeHandler sendDown:sender fromTableViewController:self.parentTableViewController];
}





// Happens when a user touches the reply button
- (IBAction)sendReply:(UIButton*)sender
{
    [JCCReplyHandler sendReply:sender fromTableViewController:self.parentTableViewController];
}





// Happens when user touches the echo button
- (IBAction)sendEcho:(UIButton*)sender
{
    [JCCEchoHandler sendEcho:sender fromTableViewController:self.parentTableViewController];
}




// handles the mute option
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




// converts a UTC string to a date object
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
    
    
    //  years
    if ((timeInterval) / 31536000 >= 1)
    {
        if ((int)(timeInterval) / 31536000 == 1)
        {
            return @"1 year ago";
        }
        return [NSString stringWithFormat:@"%d years ago", (int)(timeInterval) / 31536000];
    }
    
    //  days
    else if ((timeInterval) / 86400 >= 1)
    {
        if ((int)(timeInterval) / 86400 == 1)
        {
            return @"1 day ago";
        }
        return [NSString stringWithFormat:@"%d days ago", (int)(timeInterval) / 86400];
    }
    
    //  hours
    else if ((timeInterval) / 3600 >= 1)
    {
        if ((int)(timeInterval) / 3600 == 1)
        {
            return @"1 hour ago";
        }
        return [NSString stringWithFormat:@"%d hours ago", (int)(timeInterval) / 3600];
    }
    
    //  minutes
    else if ((timeInterval) / 60 >= 1)
    {
        if ((int)(timeInterval) / 60 == 1)
        {
            return @"1 min ago";
        }
        return [NSString stringWithFormat:@"%d mins ago", (int)(timeInterval) / 60];
    }
    
    if (timeInterval < 1)
        return [NSString stringWithFormat:@"right now"];
    
    //  seconds
    return [NSString stringWithFormat:@"%d secs ago", (int)timeInterval];
    
}




// Asynchronously loads the profile image in the cell
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





- (JCCTableViewCell1 *)setUpCellWithDictionary:(NSDictionary *) dictShout
{
    // Asynchronously loads the profile image in the cell
    [self loadProfileImageUsingDictionary:dictShout];
    
    [self.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [self.MessageTextView setBackgroundColor:[UIColor lightTextColor]];
    [self.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
    
    
    [self.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    [self.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"likes"]]];
    [self.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"dislikes"]]];
    [self.NumberOfRepliesLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"numReplies"]]];
    
    
    [self.MessageIDLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"id"]]];
    [self.SenderIDLabel setText:@""];
    
    // Connects the buttons to their respective actions
    [self.UpButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.DownButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.ReplyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    [self.EchoButton addTarget:self action:@selector(sendEcho:) forControlEvents:UIControlEventTouchUpInside];
    [self.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    self.InnerView.layer.cornerRadius = 8.0;
    self.InnerView.layer.masksToBounds = YES;
    
    
    // Set current like/dislike
    NSArray *usersLiked = [dictShout objectForKey:@"usersLiked"];
    NSArray *usersDisliked = [dictShout objectForKey:@"usersDisliked"];
    
    // Default colors for likes/dislikes
    [JCCLikeDislikeHandler setDefaultLikeDislike:self];
    
    // Check to see if like or dislike should be highlighted
    for (NSString* person in usersLiked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setLikeAsMarked:self];
    }
    
    for (NSString* person in usersDisliked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setDislikeAsMarked:self];
    }
    
    return self;
    
}





- (void)awakeFromNib
{
    // Initialization code
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
