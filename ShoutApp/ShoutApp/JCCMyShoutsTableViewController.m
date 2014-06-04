//
//  JCCMyShoutsTableViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCEchoViewController.h"
#import "JCCReplyViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCMyShoutsTableViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import "JCCLikeDislikeHandler.h"
#import "JCCReplyHandler.h"
#import "JCCEchoHandler.h"
#import "JCCMuteHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface JCCMyShoutsTableViewController ()
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
    
    NSString *Id;
    
    JCCTableViewCell1 *currentCell;
}
//This is the actual table view object that corresponds to this table view controller
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end


// Happens when a user clicks the "UP" button
@implementation JCCMyShoutsTableViewController


-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
}




// Send the like
- (IBAction)sendUp:(UIButton*)sender
{
    // post the like
    [JCCLikeDislikeHandler sendUp:sender fromTableViewController:self];
}





// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    // post the dislike
    [JCCLikeDislikeHandler sendDown:sender fromTableViewController:self];
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




// Handles the mute options
- (IBAction)showMuteOption:(UIButton*)sender {
    
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





- (NSArray*)fetchShouts
{
    
    //  handle setting up location updates
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
        
    jsonObjects = [JCCMakeRequests getMyShouts];
    return jsonObjects;
}





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
        return [NSString stringWithFormat:@"%d years ago", (int)(timeInterval) / 31536000];
    }
    
    //  days
    else if ((timeInterval) / 86400 >= 1)
    {
        return [NSString stringWithFormat:@"%d days ago", (int)(timeInterval) / 86400];
    }
    
    //  hours
    else if ((timeInterval) / 3600 >= 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", (int)(timeInterval) / 3600];
    }
    
    //  minutes
    else if ((timeInterval) / 60 >= 1)
    {
        return [NSString stringWithFormat:@"%d mins ago", (int)(timeInterval) / 60];
    }
    
    if (timeInterval < 1)
        return [NSString stringWithFormat:@"right now"];
    
    //  seconds
    return [NSString stringWithFormat:@"%d secs ago", (int)timeInterval];
    
}




// Called every time a cell is loaded into the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell1";
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //        cell = [[JCCTableViewCell1 alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:(CellIdentifier)];
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

    // Begin configuration of Cell
    [cell.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [cell.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
    [cell.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"likes"]]];
    [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"dislikes"]]];
    [cell.MessageIDLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"id"]]];
    [cell.SenderIDLabel setText:@""];
    
    // Connects the buttons to their respective actions
    [cell.UpButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DownButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
    [cell.ReplyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.EchoButton addTarget:self action:@selector(sendEcho:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.InnerView.layer.cornerRadius = 8.0;
    cell.InnerView.layer.masksToBounds = YES;
    
    // Set current like/dislike
    NSArray *usersLiked = [dictShout objectForKey:@"usersLiked"];
    NSArray *usersDisliked = [dictShout objectForKey:@"usersDisliked"];
    
    // Default colors for likes/dislikes
    [JCCLikeDislikeHandler setDefaultLikeDislike:cell];
    
    // Check to see if like or dislike should be highlighted
    for (NSString* person in usersLiked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setLikeAsMarked:cell];
    }
    
    for (NSString* person in usersDisliked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setDislikeAsMarked:cell];
    }

    
    [cell.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    }
}





// Height of each cell in the table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}





// Number of sections in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}





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





// Called every time before the view appears
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
}





// Refreshes the data and then reloads the table
- (void)refresh
{
    // Do something...
    [self fetchShouts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}





// Called the first time the view loads
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