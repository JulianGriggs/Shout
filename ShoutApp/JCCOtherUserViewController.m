//
//  JCCOtherUserViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCOtherUserViewController.h"
#import "JCCViewController.h"
#import "JCCLoginViewController.h"
#import "JCCUserCredentials.h"
#import "JCCUserCredentials.h"
#import "JCCOtherUserShoutsTableViewController.h"
#import "JCCMakeRequests.h"

@interface JCCOtherUserViewController ()

@end

@implementation JCCOtherUserViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    UIButton *myShoutsButton;
    UIButton *topShoutsButton;
    UIButton *myLocationsButton;
    UIImage *myProfPicture;
    UIImageView *profilePicture;
    JCCOtherUserShoutsTableViewController *tableViewController;
    
    
    UILabel *myUsername;
    UILabel *myMaxRadius;
    UILabel *myNumShouts;
    UILabel *myNumLikesReceived;
    
    
}






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}







// Populates all of the data
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *userProfDict = [JCCMakeRequests getOtherUserProfile:self.otherUsername];
    NSData* profPicData = [JCCMakeRequests getProfileImage:userProfDict];
    [profilePicture setImage:[UIImage imageWithData:profPicData]];
    profilePicture.layer.cornerRadius = 8.0;
    profilePicture.layer.masksToBounds = YES;
    myProfPicture = profilePicture.image;
    
    [myUsername setText:[NSString stringWithFormat:@"%@ %@", @"Username: ", [userProfDict objectForKey:@"username"]]];
    [myMaxRadius setText:[NSString stringWithFormat:@"%@ %@ %@", @"Max Radius:", [userProfDict objectForKey:@"maxRadius"], @"meters"]];
    [myNumShouts setText:[NSString stringWithFormat:@"%@ %@",@"Number of Shouts:", [userProfDict objectForKey:@""]]];
    [myNumLikesReceived setText:[NSString stringWithFormat:@"%@ %@", @"Number of likes:", [userProfDict objectForKey:@"numLikes"]]];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [JCCMakeRequests getUserProfile];
    
    // Stores our userID
    sharedUserID = [userProfDict objectForKey:@"id"];
    
    //  add the users profile picture
    //  add profile picture
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [self.view addSubview:profilePicture];
    
    
    
    //add my shouts button
    myShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, 320, 30)];
    //    myShoutsButton.backgroundColor = [UIColor darkGrayColor];
    //    myShoutsButton.alpha = 0.4;
    myShoutsButton.backgroundColor = [UIColor blackColor];
    [myShoutsButton setTitle:@"My Shouts" forState:UIControlStateNormal];
    [self.view addSubview:myShoutsButton];
    
    tableViewController = [[JCCOtherUserShoutsTableViewController alloc] init];
    tableViewController.otherUsername = self.otherUsername;
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,195,0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 194, 0);
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    
    
    
    myUsername = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 200, 30)];
    [self.view addSubview:myUsername];
    
    myMaxRadius = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [self.view addSubview:myMaxRadius];
    
    //    myNumShouts = [[UILabel alloc] initWithFrame:CGRectMake(100, 160, 200, 30)];
    //    [self.view addSubview:myNumShouts];
    
    myNumLikesReceived = [[UILabel alloc] initWithFrame:CGRectMake(100, 130, 200, 30)];
    [self.view addSubview:myNumLikesReceived];
    
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
