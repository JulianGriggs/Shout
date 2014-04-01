//
//  JCCFeedTableViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCFeedTableViewController.h"
#import "JCCTableViewCell.h"
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
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

// This happens whenever a user clicks the "UP" button
@implementation JCCFeedTableViewController
- (IBAction)sendUp:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSString *getMessageId = cell.messageIDLabel.text;
    NSString *getSenderID = cell.senderIDLabel.text;
    NSLog(@"Message ID: %@ \n SenderID: %@", getMessageId, getSenderID);
}

// This happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSString *getMessageId = cell.messageIDLabel.text;
    NSString *getSenderID = cell.senderIDLabel.text;
    NSLog(@"Message ID: %@ \n SenderID: %@", getMessageId, getSenderID);
    
}

- (IBAction)showMuteOption:(id)sender {
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
    
    /*
    // This is sends a get request to the URL and saves the response in an NSData object
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
     */
    
    
    // This parses the response from the server as a JSON object
    jsonObjects = [NSJSONSerialization JSONObjectWithData:
                                 GETReply options:kNilOptions error:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    
    JCCTableViewCell *cell = (JCCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //  format the post surroundings
//    [cell.postTextView.layer setBorderWidth: 1.0];
//    [cell.postTextView.layer setCornerRadius:8.0f];
//    [cell.postTextView.layer setMasksToBounds:YES];
    
    //  format buttons
//    [cell.upButton.layer setBorderWidth: 1.0];
//    [cell.upButton.layer setCornerRadius:8.0f];
//    [cell.upButton.layer setMasksToBounds:YES];
//    
//    [cell.downButton.layer setBorderWidth: 1.0];
//    [cell.downButton.layer setCornerRadius:8.0f];
//    [cell.downButton.layer setMasksToBounds:YES];
//    
//    [cell.moreButton.layer setBorderWidth: 1.0];
//    [cell.moreButton.layer setCornerRadius:8.0f];
//    [cell.moreButton.layer setMasksToBounds:YES];
    
    // format picture
//    [cell.profileImage.layer setBorderWidth: 1.0];
//    [cell.profileImage.layer setCornerRadius:8.0f];
//    [cell.profileImage.layer setMasksToBounds:YES];
    
    
    
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    
    
    // Begin configuration of Cell
    [cell.postTextView setText:[dictShout objectForKey:@"bodyField"]];
    [cell.messageIDLabel setText:@""];
    [cell.senderIDLabel setText:@""];
        
    return cell;
    
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
    [self fetchShouts];
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
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
//    [self fetchShouts];
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

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