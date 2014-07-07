//
//  JCCViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCViewController.h"
#import "JCCPostViewController.h"
#import "JCCUserViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import "JCCNoShoutsViewController.h"
#import "JCCErrorHandler.h"
#import "JCCFeedTableViewController.h"


@interface JCCViewController ()

@end

@implementation JCCViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    JCCFeedTableViewController *tableViewController;
    UITableView *tableView;
    UIBarButtonItem *toggleFriends;
}

/***
 Transitions to the compose page.
 ***/
- (IBAction)pressedToggleFriendsButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    
    if (tableViewController.isFriends) {
        [toggleFriends setTitle:@"Everyone"];
        tableViewController.isFriends = NO;
    } else {
        [toggleFriends setTitle:@"Friends"];
        tableViewController.isFriends = YES;
    }
}



/***
 Transitions to the compose page.
 ***/
- (IBAction)pressedComposeButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCPostViewController *postViewController = [[JCCPostViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];

}




/***
 Transitions to the User page upon a swipe to the right.
 ***/
//-(IBAction)swipeRightHandler:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}



/***
 Transition to the compose view upon a swipe to the left.
 ***/
-(IBAction)swipeLeftHandler:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCPostViewController *postViewController = [[JCCPostViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];
}



/***
 Reloads the shouts when they exist, otherwise displays the "No Shouts Message".
 ***/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    // Displays "No Shouts Message" if there are no shouts in the area.
    if ([self containsShouts])
    {
        [self.view.subviews.lastObject setHidden:YES];
    }
    else
    {
        [tableView setHidden:YES];
    }
}


/***
 If there are any shouts in the area then return "Yes", else return "No".
 ***/
-(BOOL) containsShouts
{
    //  get the current location
    NSDictionary *dictionaryData = @{@"latitude": [NSNumber numberWithDouble:locationManager.location.coordinate.latitude], @"longitude": [NSNumber numberWithDouble:locationManager.location.coordinate.longitude]};

    NSError* error;
    NSArray *jsonObjects = [JCCMakeRequests getShouts:dictionaryData withPotentialError:&error];
    
    if(error)
    {
        [JCCErrorHandler displayErrorView:self withError:error];
    }
    
    if ([jsonObjects count] == 0)
    {
        return NO;
    }
    else return YES;
}

/***
The delegate method for dismissing the error view when the time comes.
***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self.navigationItem setTitle:@"Feed"];
    
    //  build the location manager
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    //  add a map in the background
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:18];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    mapView.settings.consumesGesturesInView = NO;
    self.view = mapView;
    
    tableViewController = [[JCCFeedTableViewController alloc] init];
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height),0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 112, 0);
    
    [self addChildViewController:tableViewController];
    [self.view addSubview:table];
    
    JCCNoShoutsViewController *noShoutsViewController = [[JCCNoShoutsViewController alloc] init];
    [self addChildViewController:noShoutsViewController];
    [self.view addSubview:noShoutsViewController.view];
    
    
    // Create the button to transition to the compose message screen
    toggleFriends = [[UIBarButtonItem alloc] initWithTitle:@"Everyone" style:UIBarButtonItemStylePlain target:self action:@selector(pressedToggleFriendsButton:)];
    [self.navigationItem setLeftBarButtonItem:toggleFriends animated:YES];
    
    // Create the button to transition to the compose message screen
    UIBarButtonItem *composeShout = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(pressedComposeButton:)];
    [self.navigationItem setRightBarButtonItem:composeShout animated:YES];
    
//    UISwipeGestureRecognizer *gestureRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
//    [gestureRightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.view addGestureRecognizer:gestureRightRecognizer];
    
    UISwipeGestureRecognizer *gestureLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [gestureLeftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:gestureLeftRecognizer];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
