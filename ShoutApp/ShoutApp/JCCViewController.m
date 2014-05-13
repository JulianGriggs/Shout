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
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        // This allocates a post view controller and pushes it on the navigation stack
        JCCPostViewController *postViewController = [[JCCPostViewController alloc] init];
        [self.navigationController pushViewController:postViewController animated:YES];
    }
}





-(IBAction)pressedUserButton:(id)sender
{
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}





-(IBAction)swipeRightHandler:(id)sender
{
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}





-(IBAction)swipeLeftHandler:(id)sender
{
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        // This allocates a post view controller and pushes it on the navigation stack
        JCCPostViewController *postViewController = [[JCCPostViewController alloc] init];
        [self.navigationController pushViewController:postViewController animated:YES];
    }
    

}





-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  customize the navigation back button
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(pressedUserButton:)];
    [self.navigationItem setLeftBarButtonItem:userButton animated:YES];

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
    
    
    //  create the table view controller
    tableViewController = [[JCCFeedTableViewController alloc] init];
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height),0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    

    
    
    // Create the button to transition to the compose message screen
    UIBarButtonItem *composeShout = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(pressedComposeButton:)];
    [self.navigationItem setRightBarButtonItem:composeShout animated:YES];
    
    UISwipeGestureRecognizer *gestureRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightHandler:)];
    [gestureRightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRightRecognizer];
    
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
