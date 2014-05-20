//
//  JCCFeedTableViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCFeedTableViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCPostViewController.h"
#import "JCCEchoViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import "JCCOtherUserViewController.h"
#import "JCCLikeDislikeHandler.h"
#import "JCCReplyHandler.h"
#import "JCCEchoHandler.h"
#import "JCCMuteHandler.h"

#import <QuartzCore/QuartzCore.h>

@interface JCCFeedTableViewController ()
{
    
    // location manager
    CLLocationManager *locationManager;
    
    
    // The contents of the message
    NSString *message;
    
    // The Message ID
    NSString *messageID;
    
    // The Sender ID
    NSString *senderID;
    
    // array of dictionaries of shouts
    NSArray *jsonObjects;
    
    // An array where each element will be a dictionary holding a feature:value
    NSMutableArray *myObject;
    
    // Current Location
    CLLocationCoordinate2D myCurrentLocation;
    
    JCCTableViewCell1 *currentCell;
    
}




@end


// Happens when a user clicks the "UP" button
@implementation JCCFeedTableViewController



// Send the like
- (IBAction)sendUp:(UIButton*)sender
{
    // post the like
    [JCCLikeDislikeHandler sendUp:sender fromTableViewController:self];
    if([self fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        return;
    }
    else
    {
        [self.tableView reloadData];
    }
}




// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    // post the dislike
    [JCCLikeDislikeHandler sendDown:sender fromTableViewController:self];
    if([self fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        return;
    }
    else
    {
        [self.tableView reloadData];
    }
}





// Happens when a user touches the reply button
- (IBAction)sendReply:(UIButton*)sender
{
    [JCCReplyHandler sendReply:sender fromTableViewController:self];
}





// Happens when user touches the echo button
- (IBAction)sendEcho:(UIButton*)sender
{
    [JCCEchoHandler sendEcho:sender fromTableViewController:self];
}





//  handle switching to other users page on click of cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCCOtherUserViewController *otherViewController = [[JCCOtherUserViewController alloc] init];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    otherViewController.otherUsername = cell.UsernameLabel.text;
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.navigationController pushViewController:otherViewController animated:YES];
    }
    
    
}




// handles the mute option
- (IBAction)showMuteOption:(UIButton*)sender
{
    // post the dislike
    [JCCMuteHandler sendMute:sender fromTableViewController:self];
    if([self fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        return;
    }
    else
    {
        [self.tableView reloadData];
    }
}





// updates the location
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = (CLLocation *) locations.lastObject;
    myCurrentLocation = CLLocationCoordinate2DMake(mostRecentLocation.coordinate.latitude, mostRecentLocation.coordinate.longitude);
}





// registers what button on the mute alert the user pressed and then responds appropriately
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        if([JCCMakeRequests postMute:[currentCell.UsernameLabel text]] == nil || [self fetchShouts] == nil)
        {
            JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
            [self.navigationController pushViewController:badView animated:NO];
        }
        [self.tableView reloadData];
    }
}





// fetch all of the shouts from the users location
- (NSArray*)fetchShouts
{
    
    //  get the current location
    NSDictionary *dictionaryData = @{@"latitude": [NSNumber numberWithDouble:myCurrentLocation.latitude], @"longitude": [NSNumber numberWithDouble:myCurrentLocation.longitude]};
    
    jsonObjects = [JCCMakeRequests getShouts:dictionaryData];
    return jsonObjects;
    
}




// Number of sections in the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
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





// Called every time to load each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"messageCell1";
    JCCTableViewCell1 *cell = (JCCTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCCTableViewCell1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    NSData* profPicData = [JCCMakeRequests getProfileImage:dictShout];
    // If no internet
    if (profPicData == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        
        return cell;
    }
    
    else
    {
        // Begin configuration of Cell
        [cell.ProfileImage setImage:[UIImage imageWithData:profPicData]];
        cell.ProfileImage.layer.cornerRadius = 8.0;
        cell.ProfileImage.layer.masksToBounds = YES;
        [cell.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
        [cell.MessageTextView setBackgroundColor:[UIColor lightTextColor]];
        [cell.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
        
        
        [cell.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"likes"]]];
        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"dislikes"]]];
        [cell.NumberOfRepliesLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"numReplies"]]];
        
        
        [cell.MessageIDLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"id"]]];
        [cell.SenderIDLabel setText:@""];
        
        // Connects the buttons to their respective actions
        [cell.UpButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.DownButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ReplyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
        [cell.EchoButton addTarget:self action:@selector(sendEcho:) forControlEvents:UIControlEventTouchUpInside];
        [cell.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
        cell.InnerView.layer.cornerRadius = 8.0;
        cell.InnerView.layer.masksToBounds = YES;
        
        
        // Set current like/dislike
        NSArray *usersLiked = [dictShout objectForKey:@"usersLiked"];
        NSArray *usersDisliked = [dictShout objectForKey:@"usersDisliked"];
        
        // Default colors for likes/dislikes
        [self setDefaultLikeDislike:cell];
        
        // Check to see if like or dislike should be highlighted
        for (NSString* person in usersLiked)
        {
            if ([person isEqualToString:sharedUserName])
                [self setLikeAsMarked:cell];
        }
        
        for (NSString* person in usersDisliked)
        {
            if ([person isEqualToString:sharedUserName])
                [self setDislikeAsMarked:cell];
        }
        return cell;
    }
    
}





// Sets default to white background and black text for like/dislike labels
-(void)setDefaultLikeDislike:(JCCTableViewCell1*)cell
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
-(void)setLikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.UpLabel setTextColor:[UIColor whiteColor]];
    cell.UpLabel.backgroundColor = [UIColor blackColor];
    cell.UpLabel.layer.cornerRadius = 8.0;
    cell.UpLabel.layer.masksToBounds = YES;
}





// if the user is found in the list for having disliked, then highlight the like label
-(void)setDislikeAsMarked:(JCCTableViewCell1*)cell
{
    [cell.DownLabel setTextColor:[UIColor whiteColor]];
    cell.DownLabel.backgroundColor = [UIColor blackColor];
    cell.DownLabel.layer.cornerRadius = 8.0;
    cell.DownLabel.layer.masksToBounds = YES;
}




// Returns the height of each table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}




// Makes it so that there is only one section in the tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




// Autogenerated init of the table view
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}





// Prevents the view from being turned to landscape mode
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




// Called before the view appears
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
    // put title on navbar
}





// Refreshes the feed and reload the data
- (void)refresh
{
    // Do something...
    
    if ([self fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    
    else
    {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
}




// Called before the view loads for the first time
- (void)viewDidLoad
{
    [super viewDidLoad];
    // This will remove extra separators from tableview
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // This creates the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //  handle setting up location updates
    if (!locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    // Gets the current location
    myCurrentLocation = locationManager.location.coordinate;
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}



@end