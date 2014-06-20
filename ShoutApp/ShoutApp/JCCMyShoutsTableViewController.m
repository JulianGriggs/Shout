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
#import "JCCErrorHandler.h"
#import <QuartzCore/QuartzCore.h>

@interface JCCMyShoutsTableViewController ()

//This is the actual table view object that corresponds to this table view controller
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end


// Happens when a user clicks the "UP" button
@implementation JCCMyShoutsTableViewController
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
 Gets all of the shouts based off of the current location.
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
    
    // Object for error handling
    NSError* error;
    
    jsonObjects = [JCCMakeRequests getMyShoutsWithPotentialError:&error];
    if(error)
    {
        [JCCErrorHandler displayErrorView:self withError:error];
    }
    return jsonObjects;
}



/***
 Sets the number of rows to the number of shouts in the jsonObjects object.
 ***/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return jsonObjects.count;
}


/***
 The delegate method for dismissing the error view when the time comes.
 ***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


/***
 Loads each cell.
 ***/
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
    
    // Prevents from going too many layers into viewing profiles
    [cell.ProfileImageButton setHidden:YES];
    return cell;
}



/***
 Sets the height of each cell in the table.
 TODO: Make this dynamic.
 ***/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
 Refreshes the myshouts table view controller every time before the view appears.
 ***/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:FALSE];
    [self refresh];
}



/***
 Refreshes the data and then reloads the table.
 ***/
- (void)refresh
{
    // Do something...
    [self fetchShouts];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}



/***
 Creates the refresh object.  And sets the tableview separator style to none.
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