//
//  JCCViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCViewController.h"
#import "JCCPostViewController.h"

@interface JCCViewController ()

@end

@implementation JCCViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    JCCFeedTableViewController *tableViewController;
    UITableView *tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// This is the function that is called when the compose button is pressed
- (IBAction)pressedComposeButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCPostViewController *postViewController = [[JCCPostViewController alloc] init];
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  build the location manager
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
    //  add a map in the background
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:18];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    self.view = mapView;
    
    
    //  create the table view controller
    tableViewController = [[JCCFeedTableViewController alloc] init];
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [table setFrame:screenRect];
    
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    
    
    
    // Create the button to transition to the compose message screen
    UIBarButtonItem *composeShout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pressedComposeButton:)];
    [self.navigationItem setRightBarButtonItem:composeShout animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
