//
//  JCCOtherUserViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCOtherUserViewController.h"
#import "JCCOtherProfPicViewController.h"
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
    UIButton *theirShoutsButton;
    UIButton *topShoutsButton;
    UIButton *theirLocationsButton;
    UIButton *editProfPicButton;
    UIImage *theirProfPicture;
    UIImageView *profilePicture;
    JCCOtherUserShoutsTableViewController *tableViewController;
    UILabel *theirUsername;
    UILabel *theirMaxRadius;
    UILabel *theirNumShouts;
    UILabel *theirNumLikesReceived;
}



/***
 Populates all of the data when the view appears.
 ***/
-(void)viewWillAppear:(BOOL)animated
{
    // Object for error handling
    NSError* error;
    
    NSDictionary *userProfDict = [JCCMakeRequests getOtherUserProfile:self.otherUsername withPotentialError:&error];
    NSData* profPicData = [JCCMakeRequests getProfileImage:userProfDict withPotentialError:&error];
    
    [profilePicture setImage:[UIImage imageWithData:profPicData]];
    profilePicture.layer.cornerRadius = 8.0;
    profilePicture.layer.masksToBounds = YES;
    theirProfPicture = profilePicture.image;
    
    [theirUsername setText:[NSString stringWithFormat:@"%@ %@", @"Username: ", [userProfDict objectForKey:@"username"]]];
    [theirMaxRadius setText:[NSString stringWithFormat:@"%@ %@ %@", @"Max Radius:", [userProfDict objectForKey:@"maxRadius"], @"meters"]];
    [theirNumShouts setText:[NSString stringWithFormat:@"%@ %@",@"Number of Shouts:", [userProfDict objectForKey:@""]]];
    [theirNumLikesReceived setText:[NSString stringWithFormat:@"%@ %@", @"Number of likes:", [userProfDict objectForKey:@"numLikes"]]];
    
    [theirShoutsButton setTitle:[NSString stringWithFormat:@"Shouts by %@", [userProfDict objectForKey:@"username"]] forState:UIControlStateNormal];
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
    
    
    //    // This parses the response from the server as a JSON object
    //    NSDictionary *userProfDict = [JCCMakeRequests getUserProfile];
    //
    //    // Stores our userID
    //    sharedUserID = [userProfDict objectForKey:@"id"];
    
    //  add the users profile picture
    //  add profile picture
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [self.view addSubview:profilePicture];
    
    //  add an edit profile picture button
    editProfPicButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [editProfPicButton addTarget:self action:@selector(editProfPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editProfPicButton];
    
    
    //add my shouts button
    theirShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, 320, 30)];
    //    myShoutsButton.backgroundColor = [UIColor darkGrayColor];
    //    myShoutsButton.alpha = 0.4;
    theirShoutsButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:theirShoutsButton];
    
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
    
    theirUsername = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 200, 30)];
    [self.view addSubview:theirUsername];
    
    theirMaxRadius = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [self.view addSubview:theirMaxRadius];
    
    theirNumLikesReceived = [[UILabel alloc] initWithFrame:CGRectMake(100, 130, 200, 30)];
    [self.view addSubview:theirNumLikesReceived];
}



/***
 Adjusts the alpha levels when the "My Shouts" button is being pressed.
 ***/
-(IBAction)myShoutButtonPressed:(id)sender
{
    // adjust the alphas
    theirShoutsButton.alpha = 0.8;
    topShoutsButton.alpha = 0.4;
    theirLocationsButton.alpha = 0.4;
}



/***
 Adjusts the alpha levels when the "Top Shouts" button is being pressed.
 ***/
-(IBAction)topShoutsButtonPressed:(id)sender
{
    // adjust the alphas
    theirShoutsButton.alpha = 0.4;
    topShoutsButton.alpha = 0.8;
    theirLocationsButton.alpha = 0.4;
}



/***
 Adjusts the alpha levels when the "My Locations" button is being pressed.
 ***/
-(IBAction)myLocationsButtonPressed:(id)sender
{
    // adjust the alphas
    theirShoutsButton.alpha = 0.4;
    topShoutsButton.alpha = 0.4;
    theirLocationsButton.alpha = 0.8;
}



/***
 When the user clicks on their profile image, the screen for editing the profile image comes up.
 ***/
-(IBAction)editProfPicButtonPressed:(id)sender
{
    JCCOtherProfPicViewController *profPicView = [[JCCOtherProfPicViewController alloc] init];
    profPicView.profPicture = theirProfPicture;
    [self.navigationController pushViewController:profPicView animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
