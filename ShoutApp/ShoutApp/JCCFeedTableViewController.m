//
//  JCCFeedTableViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCFeedTableViewController.h"
#import "JCCTableViewCell.h"
#import "JCCPostViewController.h"
#import "JCCEchoViewController.h"
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
    
}
//This is the actual table view object that corresponds to this table view controller
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end


// Happens when a user clicks the "UP" button
@implementation JCCFeedTableViewController

/********************************************************************
 * Actions
 *******************************************************************/

- (IBAction)sendUp:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageId = cell.MessageIDLabel.text;
    NSString *getSenderID = cell.SenderIDLabel.text;
    
    // If black set to blue, else set to black
    if ([cell.UpLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "down" button to black
        [cell.DownLabel setTextColor:[UIColor blackColor]];
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor blueColor]];
        
        
        
        
        // post the like
        // make the url with query variables
        NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
        NSString *url1 = [url stringByAppendingString:getMessageId];
        NSString *url2 = [url1 stringByAppendingString:@"/like"];

        
        // send the get request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url2]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.UpLabel setTextColor:[UIColor blackColor]];
    }

}

// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *getMessageId = cell.MessageIDLabel.text;
    NSString *getSenderID = cell.SenderIDLabel.text;
    
    // If black set to red, else set to black
    if ([cell.DownLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "down" button to black
        [cell.UpLabel setTextColor:[UIColor blackColor]];
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [cell.DownLabel setTextColor:[UIColor blackColor]];
    }
}



// Happens when a user touches the reply button
- (IBAction)sendReply:(UIButton*)sender
{
    // This allocates a echo view controller and pushes it on the navigation stack
    JCCReplyViewController *replyViewController = [[JCCReplyViewController alloc] init];
    
    // get the text
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:replyViewController animated:YES];
    
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
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
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


/*******************************************************************/

- (void)fetchShouts
{
    //  handle setting up location updates
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    //  get the current location
    NSDictionary *dictionaryData = @{@"latitude": [NSNumber numberWithDouble:locationManager.location.coordinate.latitude], @"longitude": [NSNumber numberWithDouble:locationManager.location.coordinate.longitude]};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages?"];
    NSString *url1 = [url stringByAppendingString:@"latitude="];
    NSString *url2 = [url1 stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"latitude"]]];
    NSString *url3 = [url2 stringByAppendingString:@"&"];
    NSString *url4 = [url3 stringByAppendingString:@"longitude="];
    NSString *url5 = [url4 stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"longitude"]]];
    
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url5]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    
    // Creates myObject every time  this function is called
    myObject = [[NSMutableArray alloc] init];
    
    
    // This parses the response from the server as a JSON object
    jsonObjects = [NSJSONSerialization JSONObjectWithData:
                                 GETReply options:kNilOptions error:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
}

// converts a UTC string to a date object
- (NSString *) formatTime:(NSString *) timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'s'Z'";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSLog(@"%@", [dateFormatter dateFromString:timeString]);
    dateFormatter = nil;
//    
//    NSString *currentTime = [dateFormatter stringFromDate:timeStamp];
//    return currentTime;
    return timeString;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    
    JCCTableViewCell *cell = (JCCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
//        cell = [[JCCTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:(CellIdentifier)];
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    
    
    // Begin configuration of Cell
    
    [cell.ProfileImage setImage:[UIImage imageNamed:@"UserIcon.png"]];
    [cell.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [cell.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
   
   // NSLog(@"%@", [dictShout objectForKey:@"timestamp"]);
    
    [cell.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    //[cell.TimeLabel setText:[dictShout objectForKey:@"timestamp"]];
    [cell.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"likes"]]];
    [cell.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"dislikes"]]];
    
//    CGRect frame = cell.MessageTextView.frame;
//    frame.size.height = cell.MessageTextView.contentSize.height;
//    cell.MessageTextView.frame = frame;
    
    [cell.MessageIDLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"id"]]];
    [cell.SenderIDLabel setText:@""];
    
    // Connects the buttons to their respective actions
    [cell.UpButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DownButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
    [cell.ReplyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.EchoButton addTarget:self action:@selector(sendEcho:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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




/*******************************************************************/



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This creates the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
//    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'s'Z'";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




/*******************************************************************/





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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