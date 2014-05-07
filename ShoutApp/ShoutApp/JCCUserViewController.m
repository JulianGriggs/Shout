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
#import "JCCUserCredentials.h"
#import "JCCMyShoutsTableViewController.h"

@interface JCCUserViewController ()

@end

@implementation JCCUserViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    UIButton *myShoutsButton;
    UIButton *topShoutsButton;
    UIButton *myLocationsButton;
    UIButton *editProfPicButton;
    UIImage *myProfPicture;
    JCCMyShoutsTableViewController *tableViewController;
    
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

-(IBAction)pressedFeedButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCViewController *viewController = [[JCCViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        sharedUserName = @"";
        sharedUserToken = @"";
        NSLog(@"Token after logout button: %@", sharedUserToken);
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}




-(IBAction)pressedLogoutButton:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];

    
}




-(IBAction)swipeLeftHandler:(id)sender
{
    // This allocates a post view controller and pushes it on the navigation stack
    JCCViewController *viewController = [[JCCViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}



-(NSData*)getProfileImage:(NSDictionary*) dictShout
{
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/static/shout/images/"];
    NSString *url1 = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    [request setURL:[NSURL URLWithString:url1]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:jsonData];
    
    // check the response
    NSURLResponse *response;
    NSError *error = nil;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    return GETReply;
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
    
    // Add logout button
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pressedLogoutButton:)];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLogoutButton:)];
    [self.navigationItem setLeftBarButtonItem:logoutButton animated:YES];
    
    
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
    
    
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@", @"http://aeneas.princeton.edu:8000/api/v1/users/getMyProfile/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"theReply: %@", theReply);
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    
    NSData* profPicData = [self getProfileImage:userProfDict];
    
    
    NSLog(@"%@", userProfDict);
    
    //  add the users profile picture
    //  add profile picture
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [profilePicture setImage:[UIImage imageWithData:profPicData]];
    myProfPicture = profilePicture.image;
    [self.view addSubview:profilePicture];
    
    
    //  add an edit profile picture button
    editProfPicButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [editProfPicButton addTarget:self action:@selector(editProfPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editProfPicButton];
    
    
    //  add the navaigation buttons
    
    //add my shouts button
    myShoutsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 265, 320, 30)];
    myShoutsButton.backgroundColor = [UIColor darkGrayColor];
    myShoutsButton.alpha = 0.4;
    [myShoutsButton setTitle:@"My Shouts" forState:UIControlStateNormal];
    [self.view addSubview:myShoutsButton];
    
    tableViewController = [[JCCMyShoutsTableViewController alloc] init];
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,295,0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 296, 0);
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    
    
    
    myUsername = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [myUsername setText:[NSString stringWithFormat:@"%@ %@", @"Username: ", [userProfDict objectForKey:@"username"]]];
    [self.view addSubview:myUsername];
    
    myMaxRadius = [[UILabel alloc] initWithFrame:CGRectMake(100, 130, 200, 30)];
    [myMaxRadius setText:[NSString stringWithFormat:@"%@ %@ %@", @"Max Radius:", [userProfDict objectForKey:@"maxRadius"], @"meters"]];
    [self.view addSubview:myMaxRadius];

    myNumShouts = [[UILabel alloc] initWithFrame:CGRectMake(100, 160, 200, 30)];
    [myNumShouts setText:[NSString stringWithFormat:@"%@ %@",@"Number of Shouts:", [userProfDict objectForKey:@""]]];
    [self.view addSubview:myNumShouts];
    
    myNumLikesReceived = [[UILabel alloc] initWithFrame:CGRectMake(100, 190, 200, 30)];
    [myNumLikesReceived setText:[NSString stringWithFormat:@"%@ %@", @"Number of likes:", [userProfDict objectForKey:@"numLikes"]]];
    [self.view addSubview:myNumLikesReceived];

}

//  handle the edit profile picture button being pressed
-(IBAction)editProfPicButtonPressed:(id)sender
{
     JCCProfPicViewController *profPicView = [[JCCProfPicViewController alloc] init];
    profPicView.profPicture = myProfPicture;
    [self.navigationController pushViewController:profPicView animated:YES];
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
