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
#import "JCCErrorHandler.h"

#import <QuartzCore/QuartzCore.h>

@interface JCCFeedTableViewController ()

@end

@implementation JCCFeedTableViewController
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
    
    int nonMessageHeight;
    
    
}


/***
 Updates the location.
 ***/
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = (CLLocation *) locations.lastObject;
    myCurrentLocation = CLLocationCoordinate2DMake(mostRecentLocation.coordinate.latitude, mostRecentLocation.coordinate.longitude);
}



/***
 Registers which button in the alert view was clicked and responds appropriately by either muting the user and reloading the table or by doing nothing.
 ***/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Object for error checking
    NSError* error;
    
    if (buttonIndex != 0)
    {
        [JCCMakeRequests postMute:[currentCell.UsernameLabel text] withPotentialError:&error];
        if(error)
        {
            [JCCErrorHandler displayErrorView:self withError:error];
        }
        else
        {
            [self fetchShouts];
            [self.tableView reloadData];
        }
    }
}



/***
 Gets all of the shouts from the users location.
 ***/
- (NSArray*)fetchShouts
{
    //Object for error checking
    NSError* error;
    
    //  get the current location
    NSDictionary *dictionaryData = @{@"latitude": [NSNumber numberWithDouble:myCurrentLocation.latitude], @"longitude": [NSNumber numberWithDouble:myCurrentLocation.longitude]};
    
    jsonObjects = [JCCMakeRequests getShouts:dictionaryData withPotentialError:&error];
    if(error)
    {
        [JCCErrorHandler displayErrorView:self withError:error];
    }
    return jsonObjects;
}



/***
 Sets the number of rows to the number of shouts.
 ***/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
}



/***
 Loads each cell.
 ***/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"messageCell1";
    JCCTableViewCell1 *cell = (JCCTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    /*    NSAttributedString *bodyField = [[NSAttributedString alloc] initWithString:[dictShout objectForKey:@"bodyField"]];
     CGFloat messageHeight = [self textViewHeightForAttributedText:bodyField andWidth:225];
     */
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCCTableViewCell1" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setFrame:CGRectMake(0, 0, 320, 480)];// messageHeight + nonMessageHeight)];
        cell.parentTableViewController = (UITableViewController *)self;
    }
    /*   else
     {
     [cell setFrame:CGRectMake(0, 0, 320, messageHeight + nonMessageHeight)];
     }
     */
    [cell setUpCellWithDictionary:dictShout];
    return cell;
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

/***
 Sets the height for each table cell.
 TODO: Make this dynamic.
 ***/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
     NSAttributedString *bodyField = [[NSAttributedString alloc] initWithString:[dictShout objectForKey:@"bodyField"]];
     CGFloat messageHeight = [self textViewHeightForAttributedText:bodyField andWidth:225];
     return messageHeight + nonMessageHeight;
     */
    return 140;
}



/***
 Sets the number of sections in the table to 1.
 ***/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



/***
 Refreshes whenever the view appears.
 ***/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
}



/***
 Fetches shouts and then reloads the table.
 ***/
- (void)refresh
{
    [self fetchShouts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}



/***
 Creates the refresh control and sets the separator style on the table to none.  Also creates the location manager.
 ***/
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
    nonMessageHeight = 70;
    
}


/***
The delegate method for dismissing the error view when the time comes.
***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end