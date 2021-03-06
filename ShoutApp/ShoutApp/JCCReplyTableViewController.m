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
#import "JCCErrorHandler.h"

#import <QuartzCore/QuartzCore.h>

@interface JCCReplyTableViewController ()

@end


// Happens when a user clicks the "UP" button
@implementation JCCReplyTableViewController
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

/***
 Sets the Id instance variable.
 ***/
-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
}



/***
 Gets all of the replies to the current shout in question.
 ***/
- (NSArray*)fetchShouts
{
    
    //  handle setting up location updates
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
    //Object for error handling
    NSError* error;
    // This parses the response from the server as a JSON object
    
    jsonObjects = [JCCMakeRequests getReplies:Id withPotentialError:&error];
    if(error)
    {
        // Pass off error handling to calling function
        return nil;
    }
    return jsonObjects;
}



/***
 Sets the number of rows to the number of replies.
 ***/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return jsonObjects.count;
}



/***
 Loads each cell.
 ***/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"replyCell1";
    JCCReplyTableViewCell *cell = (JCCReplyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"JCCReplyTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.parentTableViewController = (UITableViewController *)self;
    }
    NSDictionary *dictShout = [jsonObjects objectAtIndex:indexPath.row];
    [cell setUpCellWithDictionary:dictShout];
    return cell;
}



/***
 Registers which button in the alert view was clicked and responds appropriately by either muting the user and reloading the table or by doing nothing.
 ***/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        //Object for error handling
        NSError* error;
        [JCCMakeRequests postMute:[currentCell.UsernameLabel text] withPotentialError:&error];
        if(error)
        {
            [JCCErrorHandler displayErrorView:self withError:error];
        }
        [self fetchShouts];
        [self.tableView reloadData];
    }
}



/***
 Sets the height for each table cell.
 TODO: Make this dynamic.
 ***/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
 This is called to set the long refresh back to normal after waiting
 ***/
- (void)quitRefresh
{
    [self.refreshControl endRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


/***
 Fetches shouts and then reloads the table.
 ***/
- (void)refresh
{
    
    if ([self fetchShouts])
    {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
    // There was an error
    else
    {
        [self.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
        [self performSelector:@selector(quitRefresh) withObject:nil afterDelay:5.0];
    }
}

/***
 The delegate method for dismissing the error view when the time comes.
 ***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

/***
 Creates the refresh control and sets the separator style on the table to none.
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
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end