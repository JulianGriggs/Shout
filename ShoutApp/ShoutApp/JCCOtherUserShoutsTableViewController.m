//
//  JCCOtherUserShoutsTableViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCEchoViewController.h"
#import "JCCReplyViewController.h"
#import "JCCTableViewCell1.h"
#import "JCCOtherUserShoutsTableViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import "JCCLikeDislikeHandler.h"
#import "JCCReplyHandler.h"
#import "JCCEchoHandler.h"
#import "JCCMuteHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface JCCOtherUserShoutsTableViewController ()
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
@implementation JCCOtherUserShoutsTableViewController



-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
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
    
    jsonObjects = [JCCMakeRequests getOtherUsersShouts:self.otherUsername];
    return jsonObjects;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
}





// Called every time a new cell needs to be loaded
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell1";
    
    JCCTableViewCell1 *cell = (JCCTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCCTableViewCell1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.parentTableViewController = (UITableViewController *)self;
    }
    
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    [cell setUpCellWithDictionary:dictShout];
    return cell;
}





// Height of cells in table
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





// Called every time the view is about to appear
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
}




// Refreshes the data and reloads the table
- (void)refresh
{
    // Do something...
    [self fetchShouts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}




// Called once when the view initially loads
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