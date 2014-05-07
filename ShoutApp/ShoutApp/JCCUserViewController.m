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




-(void)viewWillAppear:(BOOL)animated
{
    //    // Remove back button in top navigation
    self.navigationItem.hidesBackButton = YES;
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
    
    // Add logout button
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(pressedLogoutButton:)];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLogoutButton:)];
    [self.navigationItem setLeftBarButtonItem:logoutButton animated:YES];
    
    
    //  build the view
    UIView *userView = [[UIView alloc] init];
    userView.backgroundColor = [UIColor whiteColor];
    self.view = userView;

    NSLog(@"In User 1...");
    
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
    
    NSLog(@"In User 2...");
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
    
    
    NSLog(@"In User 3...");
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@", @"http://aeneas.princeton.edu:8000/api/v1/userProfiles/1/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"In User 4...");
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"In User 5...");
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"theReply: %@", theReply);
    NSLog(@"In User 6...");
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    
    NSLog(@"%@", userProfDict);
    
    NSLog(@"In User 7...");
    //  add the users profile picture
    //  add profile picture
    UIImageView *profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
    [profilePicture setImage:[UIImage imageNamed:@"UserIcon.png"]];
    myProfPicture = profilePicture.image;
    [self.view addSubview:profilePicture];
    
    NSLog(@"In User 8...");
    
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
