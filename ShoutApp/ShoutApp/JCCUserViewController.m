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
#import "JCCProfPicViewController.h"
#import "JCCEditProfileViewController.h"
#import "JCCConfirmPasswordViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMyShoutsTableViewController.h"
#import "JCCMakeRequests.h"
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"
#import "JCCErrorHandler.h"

@interface JCCUserViewController ()

@end

@implementation JCCUserViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    UIButton *myShoutsButton;
    UIButton *editProfPicButton;
    UIImage *myProfPicture;
    UIImageView *profilePicture;
    JCCMyShoutsTableViewController *tableViewController;
    UILabel *myUsername;
    UILabel *myMaxRadius;
    UILabel *myNumShouts;
    UILabel *myNumLikesReceived;
    UIButton *editProfile;
}


/***
 Method implemented as part of the alertView delegate protocol.  If the user affirms the alert box, then this sets the userName and userToken globals to empty strings
 and moves the application back to the login view.  This is essentially the logout procedure.
 ***/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        sharedUserName = @"";
        sharedUserToken = @"";
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShoutLogin" accessGroup:nil];
        [keychainItem setObject:@"" forKey:(__bridge id)kSecAttrAccount];
        [keychainItem setObject:@"" forKey:(__bridge id)kSecValueData];
        
        JCCLoginViewController *loginViewController = [[JCCLoginViewController alloc]init];
        UINavigationController* loginRegisterController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        loginRegisterController.navigationBar.topItem.title = @"SHOUT!";

        UIWindow * mainWindow = [UIApplication sharedApplication].windows.firstObject;
        mainWindow.rootViewController = loginRegisterController;
    }
}



/***
 Displays an alert asking if the user really wants to logout.
 ***/
-(IBAction)pressedLogoutButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
}





/***
 Populates all of the data for the user page including the profile image, the username, max radius, number of shouts and number of likes.
 ***/
-(void)viewWillAppear:(BOOL)animated
{
    // Object for error handling
    NSError* error;
    
    NSDictionary *userProfDict = [JCCMakeRequests getUserProfileWithPotentialError:&error];
    if(error)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [badView setMessage:error.localizedDescription];
        badView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        badView.delegate = self;
        [self presentViewController:badView animated:YES completion:nil];
    }
    // Asynchronously loads the profile image in the cell
    [self loadProfileImageUsingDictionary:userProfDict];
    [myUsername setText:[NSString stringWithFormat:@"%@ %@", @"Username: ", [userProfDict objectForKey:@"username"]]];
    [myMaxRadius setText:[NSString stringWithFormat:@"%@ %@ %@", @"Max Radius:", [userProfDict objectForKey:@"maxRadius"], @"meters"]];
    [myNumShouts setText:[NSString stringWithFormat:@"%@ %@",@"Number of Shouts:", [userProfDict objectForKey:@""]]];
    [myNumLikesReceived setText:[NSString stringWithFormat:@"%@ %@", @"Number of likes:", [userProfDict objectForKey:@"numLikes"]]];
}



/***
 Asynchronously loads the profile image.
 ***/
- (void) loadProfileImageUsingDictionary:(NSDictionary *) dictShout
{
    __block NSData *profPicData = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/static/shout/images/"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         profPicData = (NSData*)responseObject;
         [profilePicture setImage:[UIImage imageWithData:profPicData]];
         profilePicture.layer.cornerRadius = 8.0;
         profilePicture.layer.masksToBounds = YES;
         myProfPicture = profilePicture.image;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [JCCErrorHandler displayErrorView:self withError:error];
     }];
}


/***
 Builds this view.
 ***/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //  build the view
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = [UIColor whiteColor];
    self.view = userView;
    
    
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
    UIView *mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 195)];
    mapCoverView.layer.masksToBounds = YES;
    mapCoverView.backgroundColor = [UIColor whiteColor];
    mapCoverView.alpha = 0.7;
    [self.view addSubview:mapCoverView];
    
    
    // Object for error handling
    NSError* error;
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [JCCMakeRequests getUserProfileWithPotentialError:
                                  &error];
    if(error)
    {
        [JCCErrorHandler displayErrorView:self withError:error];
    }
    
    // Stores our userID
    sharedUserID = [userProfDict objectForKey:@"id"];
    
    //  add the users profile picture
    //  add profile picture
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [self.view addSubview:profilePicture];
    
    
    //  add an edit profile picture button
    editProfPicButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [editProfPicButton addTarget:self action:@selector(editProfPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editProfPicButton];
    
    
    //add my shouts button
    myShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 165, 320, 30)];
    myShoutsButton.backgroundColor = [UIColor blackColor];
    [myShoutsButton setTitle:@"My Shouts" forState:UIControlStateNormal];
    [self.view addSubview:myShoutsButton];
    
    tableViewController = [[JCCMyShoutsTableViewController alloc] init];
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,195,0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 242, 0);
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    
    
    myUsername = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 200, 30)];
    [self.view addSubview:myUsername];
    
    myMaxRadius = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [self.view addSubview:myMaxRadius];
    
    //        myNumLikesReceived = [[UILabel alloc] initWithFrame:CGRectMake(100, 130, 200, 30)];
    //        [self.view addSubview:myNumLikesReceived];
    
    editProfile = [[UIButton alloc] initWithFrame:CGRectMake(100, 130, 80, 30)];
    [editProfile setTitle:@"Edit" forState:UIControlStateNormal];
    [editProfile setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [editProfile setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [editProfile addTarget:self action:@selector(editProfileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editProfile];
    
    // Add logout button
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 130, 80, 30)];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [logoutButton addTarget:self action:@selector(pressedLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
}


-(IBAction)editProfileButtonPressed:(id)sender
{
//    JCCConfirmPasswordViewController *confirmPasswordView = [[JCCConfirmPasswordViewController alloc] init];
    JCCEditProfileViewController *editProfileViewController = [[JCCEditProfileViewController alloc] init];
    editProfileViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    editProfileViewController.delegate = self;
    [self presentViewController:editProfileViewController animated:YES completion:nil];

}



/***
 Transitions to viewing the profile image by allocating the view controller and then pushing it onto the stack.
 ***/
-(IBAction)editProfPicButtonPressed:(id)sender
{
    JCCProfPicViewController *profPicView = [[JCCProfPicViewController alloc] init];
    profPicView.profPicture = myProfPicture;
    profPicView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    profPicView.delegate = self;
//    [self.navigationController pushViewController:profPicView animated:YES];
    [self presentViewController:profPicView animated:YES completion:nil];
}


/***
 The delegate method for dismissing the profile picture when the time comes.
 ***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


/***
 Shows the list of "My Shouts"
 ***/
-(IBAction)myShoutButtonPressed:(id)sender
{
    // adjust the alphas
    myShoutsButton.alpha = 0.8;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
