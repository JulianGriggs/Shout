//
//  JCCLikeDislikeHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCLikeDislikeHandler.h"
#import "JCCBadConnectionViewController.h"
#import "JCCUserCredentials.h"
#import "AFNetworking.h"

@implementation JCCLikeDislikeHandler


/***
  Sends the like.  This updates the UI to show that user has liked the message.  In addition it asynchronously sends a "like" to the server.
 ***/
+ (void)sendUp:(UIButton*)sender fromTableViewController: (JCCFeedTableViewController *)tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    if ([cell.UpLabel.textColor isEqual:[UIColor blackColor]])
    {
        cell.UpLabel.layer.cornerRadius = 8.0;
        cell.UpLabel.layer.masksToBounds = YES;
        [self setLikeAsMarked:cell];
        [self incrementLike:cell];
        if ([cell.DownLabel.textColor isEqual:[UIColor whiteColor]])
        {
            [self setDislikeAsUnmarked:cell];
            [self decrementDislike:cell];
        }
    }
    else
    {
        [self setLikeAsUnmarked:cell];
        [self decrementLike:cell];
    }
    
    __block NSData *reply = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages/"];
    url = [url stringByAppendingString:getMessageID];
    url = [url stringByAppendingString:@"/like"];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];

    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         reply = (NSData*)responseObject;
         [tableViewController fetchShouts];
         [tableViewController.tableView reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [badView setMessage:error.localizedDescription];
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/***
 Sends the dislike.  This updates the UI to show that user has disliked the message.  In addition it asynchronously sends a "dislike" to the server.
 ***/
+ (void)sendDown:(UIButton*)sender fromTableViewController:(JCCFeedTableViewController *) tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    if ([cell.DownLabel.textColor isEqual:[UIColor blackColor]])
    {
        cell.DownLabel.layer.cornerRadius = 8.0;
        cell.DownLabel.layer.masksToBounds = YES;

        [self setDislikeAsMarked:cell];
        [self incrementDislike:cell];
        
        if ([cell.UpLabel.textColor isEqual:[UIColor whiteColor]])
        {
            [self setLikeAsUnmarked:cell];
            [self decrementLike:cell];
        }
    }
    else
    {
        [self setDislikeAsUnmarked:cell];
        [self decrementDislike:cell];
    }
    
    __block NSData *reply = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages/"];
    url = [url stringByAppendingString:getMessageID];
    url = [url stringByAppendingString:@"/dislike"];
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];

    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         reply = (NSData*)responseObject;
         [tableViewController fetchShouts];
         [tableViewController.tableView reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [badView setMessage:error.localizedDescription];
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/*** 
 Sets default to clear background and black text for like/dislike labels.
 ***/
+(void)setDefaultLikeDislike:(JCCTableViewCell1*)cell
{
    [self setLikeAsUnmarked:cell];
    [self setDislikeAsUnmarked:cell];
}



/***
 Sets the like label to unmarked.
 ***/
+(void)setLikeAsUnmarked:(JCCTableViewCell1*)cell
{
    [cell.UpLabel setTextColor:[UIColor blackColor]];
    cell.UpLabel.backgroundColor = [UIColor clearColor];
}



/***
 Sets the dislike label to unmarked.
 ***/
+(void)setDislikeAsUnmarked:(JCCTableViewCell1*)cell
{
    [cell.DownLabel setTextColor:[UIColor blackColor]];
    cell.DownLabel.backgroundColor = [UIColor clearColor];
}



/***
 Sets the like label to marked.
 ***/
+(void)setLikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.UpLabel setTextColor:[UIColor whiteColor]];
    cell.UpLabel.backgroundColor = [UIColor blackColor];
}



/***
 Sets the dislike label to marked.
 ***/
+(void)setDislikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.DownLabel setTextColor:[UIColor whiteColor]];
    cell.DownLabel.backgroundColor = [UIColor blackColor];
}



/***
 Increases the number of likes by 1 in the NumberOfUpsLabel.
 ***/
+(void)incrementLike:(JCCTableViewCell1*)cell
{
    NSInteger numLikes = [cell.NumberOfUpsLabel.text integerValue];
    [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%d", numLikes + 1]];
}



/***
 Increases the number of dislikes by 1 in the NumberOfDownsLabel.
 ***/
+(void)incrementDislike:(JCCTableViewCell1*)cell
{
    NSInteger numDislikes = [cell.NumberOfDownsLabel.text integerValue];
    [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%d", numDislikes + 1]];
}



/***
 Reduces the number of likes by 1 in the NumberOfUpsLabel.
 ***/
+(void)decrementLike:(JCCTableViewCell1*)cell
{
    
    NSInteger numLikes = [cell.NumberOfUpsLabel.text integerValue];
    [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%d", numLikes - 1]];
}



/***
 Reduces the number of dislikes by 1 in the NumberOfDownsLabel.
 ***/
+(void)decrementDislike:(JCCTableViewCell1*)cell
{
    NSInteger numDislikes = [cell.NumberOfDownsLabel.text integerValue];
    [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%d", numDislikes - 1]];
}



@end
