//
//  JCCReplyTableViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

//
//  JCCFeedTableViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCUserCredentials.h"
#import "JCCFeedTableViewController.h"
#import "JCCReplyTableViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCReplyTableViewCell.h"
#import "JCCPostViewController.h"
#import "JCCEchoViewController.h"
#import "JCCReplyViewController.h"
#import "JCCMakeRequests.h"
#import "JCCOtherUserViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JCCReplyTableViewController ()
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
@implementation JCCReplyTableViewController


//  handle switching to other users page on click of cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCCOtherUserViewController *otherViewController = [[JCCOtherUserViewController alloc] init];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    otherViewController.otherUsername = cell.UsernameLabel.text;
    [self.navigationController pushViewController:otherViewController animated:YES];
}


-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
}



- (IBAction)showMuteOption:(UIButton*)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    currentCell = cell;
    
    if ([currentCell.UsernameLabel.text isEqualToString:sharedUserName])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mute" message:@"You can't mute yourself!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mute" message:@"You will never be able to receive shouts from this person again.  Are you sure you want to mute this person?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert show];
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

    // This parses the response from the server as a JSON object
    jsonObjects = [JCCMakeRequests getReplies:Id];
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




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"replyCell1";
    
    JCCReplyTableViewCell *cell = (JCCReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCCReplyTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    
    NSData* profPicData = [JCCMakeRequests getProfileImage:dictShout];
    // If no internet
    if (profPicData == nil)
    {
        [JCCMakeRequests displayLackOfInternetAlert];
        return cell;
    }
    
    else
    {
    // Begin configuration of Cell
    [cell.ProfileImage setImage:[UIImage imageWithData:profPicData]];
    cell.ProfileImage.layer.cornerRadius = 8.0;
    cell.ProfileImage.layer.masksToBounds = YES;
    
    [cell.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [cell.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
    [cell.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    cell.InnerView.layer.cornerRadius = 8.0;
    cell.InnerView.layer.masksToBounds = YES;
    
    
    [cell.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    }
    
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        if([JCCMakeRequests postMute:[currentCell.UsernameLabel text]] == nil || [self fetchShouts] == nil)
        {
            [JCCMakeRequests displayLackOfInternetAlert];
        }
        [self.tableView reloadData];
        
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}





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





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
}


- (void)refresh
{
    // Do something...
    [self fetchShouts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}





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





//- (void)viewDidAppear:(BOOL)animated
//{
//}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end