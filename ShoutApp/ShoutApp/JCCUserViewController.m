//
//  JCCUserViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/9/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCUserViewController.h"
#import "JCCViewController.h"
#import "JCCLoginViewController.h"
#import "JCCUserCredentials.h"

@interface JCCUserViewController ()

@end

@implementation JCCUserViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    UIButton *myShoutsButton;
    UIButton *topShoutsButton;
    UIButton *myLocationsButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)pressedFeedButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCViewController *viewController = [[JCCViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)swipeLeftHandler:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCViewController *viewController = [[JCCViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create the button to transition to the feed screen
    UIBarButtonItem *feedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(pressedFeedButton:)];
    [self.navigationItem setRightBarButtonItem:feedButton animated:YES];
    
    // Remove back button in top navigation
    self.navigationItem.hidesBackButton = YES;
    
    
    //  build the view
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = [UIColor whiteColor];
    self.view = userView;
    
    
    
    // add map in the background
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
    mapView.settings.consumesGesturesInView = NO;
    self.view = mapView;
    
    
    //  add view to cover map
    UIView *mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];
    mapCoverView.layer.masksToBounds = YES;
    mapCoverView.backgroundColor = [UIColor whiteColor];
    mapCoverView.alpha = 0.7;
    [self.view addSubview:mapCoverView];
    
    //  swipe left
    UISwipeGestureRecognizer *gestureLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHandler:)];
    [gestureLeftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [mapCoverView addGestureRecognizer:gestureLeftRecognizer];
    
    
    //  add the users profile picture
    //  add profile picture
    UIImageView *profilePricture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [profilePricture setImage:[UIImage imageNamed:@"UserIcon.png"]];
    [self.view addSubview:profilePricture];
    
    
    //  add the navaigation buttons
    
    //add my shouts button
    myShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 265, 105, 30)];
    myShoutsButton.backgroundColor = [UIColor darkGrayColor];
    myShoutsButton.alpha = 0.4;
    [myShoutsButton setTitle:@"My Shouts" forState:UIControlStateNormal];
    [myShoutsButton addTarget:self action:@selector(myShoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myShoutsButton];
    
    //add top shouts button
    topShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(215, 265, 105, 30)];
    topShoutsButton.backgroundColor = [UIColor darkGrayColor];
    topShoutsButton.alpha = 0.4;
    [topShoutsButton setTitle:@"Top Shouts" forState:UIControlStateNormal];
    [topShoutsButton addTarget:self action:@selector(topShoutsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topShoutsButton];
    
    //add my locations button
    myLocationsButton = [[UIButton alloc] initWithFrame:CGRectMake(105, 265, 110, 30)];
    myLocationsButton.backgroundColor = [UIColor darkGrayColor];
    myLocationsButton.alpha = 0.8;
    [myLocationsButton setTitle:@"My Locations" forState:UIControlStateNormal];
    [myLocationsButton addTarget:self action:@selector(myLocationsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationsButton];
}

// handle the my shout button being pressed
-(IBAction)myShoutButtonPressed:(id)sender
{
    // adjust the alphas
    myShoutsButton.alpha = 0.8;
    topShoutsButton.alpha = 0.4;
    myLocationsButton.alpha = 0.4;
}

// handle the top shouts button being pressed
-(IBAction)topShoutsButtonPressed:(id)sender
{
    // adjust the alphas
    myShoutsButton.alpha = 0.4;
    topShoutsButton.alpha = 0.8;
    myLocationsButton.alpha = 0.4;
}

//  handle the my locations button being pressed
-(IBAction)myLocationsButtonPressed:(id)sender
{
    // adjust the alphas
    myShoutsButton.alpha = 0.4;
    topShoutsButton.alpha = 0.4;
    myLocationsButton.alpha = 0.8;
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
