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
    // Who the message is to
    NSString *to;
    
    // Who the message is from
    NSString *from;
    
    // The contents of the message
    NSString *message;
    
    // The Message ID
    NSString *messageID;
    
    // The Sender ID
    NSString *senderID;
    
    // array of dictionaries of shouts
    NSArray *jsonObjects;
    
    // An array where each element will be a dictionary holding a feature:value
    NSMutableArray *myObject;}
//This is the actual table view object that corresponds to this table view controller
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

// This happens whenever a user clicks the "UP" button
@implementation JCCFeedTableViewController
- (IBAction)sendUp:(id)sender {
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
    /*
    to = @"Recipient";
    from = @"Sender";
    message = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vol.";
    messageID = @"Please work";
    senderID = @"Yo mama";
     */
    
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages"]];
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
    
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    
    
    // Begin configuration of Cell
    [cell.toLabel setText:@""];
    [cell.fromLabel setText:@""];
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
    [self fetchShouts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchShouts];
    
    /*
     // For rounded corners
     self.upButton.layer.cornerRadius = 10;
     self.upButton.clipsToBounds = YES;
     */
    
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchShouts];
}



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