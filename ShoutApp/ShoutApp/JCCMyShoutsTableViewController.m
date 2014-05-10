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



- (IBAction)sendUp:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageID = cell.MessageIDLabel.text;
    
    // If black set to blue, else set to black
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
        
        // post the like
        [JCCMakeRequests postLike:getMessageID];
        
//        // This parses the response from the server as a JSON object
//        NSDictionary *messageDict = [JCCMakeRequests getShoutWithID:getMessageID];
//        
//        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
//        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        [self fetchShouts];
        [self.tableView reloadData];
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor blackColor]];
        cell.UpLabel.backgroundColor = [UIColor whiteColor];
        
        
        // post the like
        [JCCMakeRequests postLike:getMessageID];
        
//        // This parses the response from the server as a JSON object
//        NSDictionary *messageDict = [JCCMakeRequests getShoutWithID:getMessageID];
//        
//        
//        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
//        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        [self fetchShouts];
        [self.tableView reloadData];
    }
    
}





// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    
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
        
        // post the dislike
        [JCCMakeRequests postDislike:getMessageID];
        
//        // This parses the response from the server as a JSON object
//        NSDictionary *messageDict = [JCCMakeRequests getShoutWithID:getMessageID];
//        
//        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
//        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        [self fetchShouts];
        [self.tableView reloadData];
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor blackColor]];
        cell.DownLabel.backgroundColor = [UIColor whiteColor];
        
        // post the dislike
        [JCCMakeRequests postDislike:getMessageID];
        
//        //  update the labels
//        NSDictionary *messageDict = [JCCMakeRequests getShoutWithID:getMessageID];
//        
//        [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
//        [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        [self fetchShouts];
        [self.tableView reloadData];
    }
}





// Happens when a user touches the reply button
- (IBAction)sendReply:(UIButton*)sender
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCReplyViewController *replyViewController = [[JCCReplyViewController alloc] init];
    [self.navigationController pushViewController:replyViewController animated:YES];
    
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // set the text
    [replyViewController passMessageId:cell.MessageIDLabel.text];
}





// Happens when user touches the echo button
- (IBAction)sendEcho:(UIButton*)sender
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCEchoViewController *echoViewController = [[JCCEchoViewController alloc] init];
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell1 *cell = (JCCTableViewCell1*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:echoViewController animated:YES];
    
    // set the text
    [echoViewController setTextField:cell.MessageTextView.text];
}





- (IBAction)showMuteOption:(UIButton*)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mute" message:@"Do you really want to mute this person?" delegate:self cancelButtonTitle:@"Nah" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}





- (void)fetchShouts
{
    
    //  handle setting up location updates
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
        
    jsonObjects = [JCCMakeRequests getMyShouts];
    
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

    // Hides the Reply and Echo button
    [cell.ReplyIconImage setHidden:YES];
    [cell.ReplyButton setHidden:YES];
    [cell.EchoIconImage setHidden:YES];
    [cell.EchoButton setHidden:YES];
    
    [cell.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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