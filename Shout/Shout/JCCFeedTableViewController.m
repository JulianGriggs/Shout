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
    
    
    // A dictionary object to hold feature:value
    // ex. "to":"Cottage Club"
    NSDictionary *dictionary;
    // Define keys
    
    // An array where each element will be a dictionary holding a feature:value
    NSMutableArray *myObject;
}
//This is the actual table view object that corresponds to this table view controller
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation JCCFeedTableViewController

// This happens whenever a user clicks the "UP" button
- (IBAction)sendUp:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Gets the MessageID and the SenderID from the hidden fields in the table cell
    NSString *getMessageId = cell.messageIDLabel.text;
    NSString *getSenderID = cell.senderIDLabel.text;
    
    // FOR TESTING
    NSLog(@"Message ID: %@ \n SenderID: %@", getMessageId, getSenderID);
    
    /***** NEED TO SEND POST REQUEST SAYING THAT THIS MESSAGEID RECEIVED AN UP VOTE *****/
}

// This happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    JCCTableViewCell *cell = (JCCTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    // Gets the MessageID and the SenderID from the hidden fields in the table cell
    NSString *getMessageId = cell.messageIDLabel.text;
    NSString *getSenderID = cell.senderIDLabel.text;
    
    // FOR TESTING
    NSLog(@"Message ID: %@ \n SenderID: %@", getMessageId, getSenderID);
    
    /***** NEED TO SEND POST REQUEST SAYING THAT THIS MESSAGEID RECEIVED AN UP VOTE *****/

}

// Pops up an alert modal giving the option to Mute the user who wrote that message
- (IBAction)showMuteOption:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mute" message:@"Do you really want to mute this person?" delegate:self cancelButtonTitle:@"Nah" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

// This is the function that responds to what the user selected when the Alert modal was popped up
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // This is if the user said yes, they really want to mute the person
    if (buttonIndex == 1)
    {
        //FOR TESTING
        NSLog(@"The User chose 'Yes'");
        
        /***** SEND POST TO SERVER INDICATING A MUTE *****/
    }
    
}

- (void)fetchShouts
{
    // Hard coded data for testing
    to = @"Recipient";
    from = @"Sender";
    message = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vol.";
    messageID = @"Please work";
    senderID = @"Yo mama";
    
    
    // Creates myObject every time  this function is called
    myObject = [[NSMutableArray alloc] init];
    
    /*****
     Note: The details, in terms of the keys searched for will entirely depend on the data from the server.  This is dummy data.
     *****/
    
    
    // This is sends a get request to the URL and saves the response in an NSData object
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
    
    // This parses the response from the server as a JSON object
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                                 jsonSource options:kNilOptions error:nil];
    
    // Takes the section of the JSON object with the key 'loans'
    NSArray *latestShouts = [jsonObjects objectForKey:@"loans"];

    
    for (NSDictionary *dataDict in latestShouts) {
        NSString *to_data = [dataDict objectForKey:@"toField"];
        NSString *from_data = [dataDict objectForKey:@"fromField"];
        NSString *body_data = [dataDict objectForKey:@"bodyField"];
        NSString *messageID_data = [dataDict objectForKey:@"messageIDField"];
        NSString *userID_data = [dataDict objectForKey:@"userIDField"];
        
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      to_data, @"to",
                      from_data, @"from",
                      body_data, @"body",
                      messageID_data, @"messageID",
                      userID_data, @"userID",
                      nil];
        [myObject addObject:dictionary];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return myObject.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    
    JCCTableViewCell *cell = (JCCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // FOR TESTING
        [cell.toLabel setText:to];
        [cell.fromLabel setText:from];
        [cell.postTextView setText:message];
        [cell.messageIDLabel setText:@"Deez"];
        [cell.senderIDLabel setText:@"Nuts"];
    
    // In reality it will probably be
//    [cell.toLabel setText:[[myObject objectAtIndex:(NSUInteger)indexPath] objectForKey:@"to"]];
//    [cell.fromLabel setText:[[myObject objectAtIndex:(NSUInteger)indexPath] objectForKey:@"from"]];
//    [cell.postTextView setText:[[myObject objectAtIndex:(NSUInteger)indexPath] objectForKey:@"body"]];
//    [cell.messageIDLabel setText:[[myObject objectAtIndex:(NSUInteger)indexPath] objectForKey:@"messageID"]];
//    [cell.senderIDLabel setText:[[myObject objectAtIndex:(NSUInteger)indexPath] objectForKey:@"userID"]];;
    return cell;
}

// We will only have one section in the table view
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
