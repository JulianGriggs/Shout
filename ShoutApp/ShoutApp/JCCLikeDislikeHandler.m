//
//  JCCLikeDislikeHandler.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCLikeDislikeHandler.h"
#import "JCCMakeRequests.h"
#import "JCCBadConnectionViewController.h"
#import "JCCUserCredentials.h"
#import "AFNetworking.h"
#import "JCCFeedTableViewController.h"

@implementation JCCLikeDislikeHandler


// Send the like
+ (void)sendUp:(UIButton*)sender fromTableViewController: (JCCFeedTableViewController *)tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    // If black set to white, else set to black
    if ([cell.UpLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor whiteColor]];
        cell.UpLabel.backgroundColor = [UIColor blackColor];
        cell.UpLabel.layer.cornerRadius = 8.0;
        cell.UpLabel.layer.masksToBounds = YES;
        int numLikes = [cell.NumberOfUpsLabel.text integerValue];
        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%d", numLikes + 1]];
        if ([cell.DownLabel.textColor isEqual:[UIColor whiteColor]])
        {
            // Resets the color of the "down" button to default
            [cell.DownLabel setTextColor:[UIColor blackColor]];
            cell.DownLabel.backgroundColor = [UIColor whiteColor];
            
            int numDislikes = [cell.NumberOfDownsLabel.text integerValue];
            [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%d", numDislikes - 1]];
        }
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor blackColor]];
        cell.UpLabel.backgroundColor = [UIColor whiteColor];
        int numLikes = [cell.NumberOfUpsLabel.text integerValue];
        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%d", numLikes - 1]];
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
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
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
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
    
}




// Happens whenever a user clicks the "DOWN" button
+ (void)sendDown:(UIButton*)sender fromTableViewController:(JCCFeedTableViewController *) tableViewController
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableViewController.tableView];
    NSIndexPath *indexPath = [tableViewController.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[tableViewController.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    // If black set to white, else set to black
    if ([cell.DownLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Sets the color of the "down" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor whiteColor]];
        cell.DownLabel.backgroundColor = [UIColor blackColor];
        cell.DownLabel.layer.cornerRadius = 8.0;
        cell.DownLabel.layer.masksToBounds = YES;
        int numDislikes = [cell.NumberOfDownsLabel.text integerValue];
        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%d", numDislikes + 1]];
        if ([cell.UpLabel.textColor isEqual:[UIColor whiteColor]])
        {
            // Resets the color of the "down" button to default
            [cell.UpLabel setTextColor:[UIColor blackColor]];
            cell.UpLabel.backgroundColor = [UIColor whiteColor];
            
            int numLikes = [cell.NumberOfUpsLabel.text integerValue];
            [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%d", numLikes - 1]];
        }
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor blackColor]];
        cell.DownLabel.backgroundColor = [UIColor whiteColor];
        int numDislikes = [cell.NumberOfDownsLabel.text integerValue];
        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%d", numDislikes - 1]];
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
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
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
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
    
}


// Sets default to white background and black text for like/dislike labels
+(void)setDefaultLikeDislike:(JCCTableViewCell1*)cell
{
    [cell.UpLabel setTextColor:[UIColor blackColor]];
    cell.UpLabel.backgroundColor = [UIColor whiteColor];
    cell.UpLabel.layer.cornerRadius = 8.0;
    cell.UpLabel.layer.masksToBounds = YES;
    
    [cell.DownLabel setTextColor:[UIColor blackColor]];
    cell.DownLabel.backgroundColor = [UIColor whiteColor];
    cell.DownLabel.layer.cornerRadius = 8.0;
    cell.DownLabel.layer.masksToBounds = YES;
}





// if the user is found in the list for having liked, then highlight the like label
+(void)setLikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.UpLabel setTextColor:[UIColor whiteColor]];
    cell.UpLabel.backgroundColor = [UIColor blackColor];
    cell.UpLabel.layer.cornerRadius = 8.0;
    cell.UpLabel.layer.masksToBounds = YES;
}





// if the user is found in the list for having disliked, then highlight the like label
+(void)setDislikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.DownLabel setTextColor:[UIColor whiteColor]];
    cell.DownLabel.backgroundColor = [UIColor blackColor];
    cell.DownLabel.layer.cornerRadius = 8.0;
    cell.DownLabel.layer.masksToBounds = YES;
}


@end
