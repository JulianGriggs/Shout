//
//  JCCPostViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCPostViewController.h"
#import "JCCLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCAnnotation.h"
#import <GoogleMaps/GoogleMaps.h>

#define DEFAULT_SHOUT_RADIUS 40

@interface JCCPostViewController ()
{
    
    // location manager
    CLLocationManager *locationManager;
}


//@property (weak, nonatomic) IBOutlet UITextView *postTextView;
//@property (weak, nonatomic) IBOutlet UIButton *shoutButton;


//  map shit

@end

@implementation JCCPostViewController
{
    GMSMapView *mapView;
    CLLocationCoordinate2D myCurrentLocation;
    CLLocationCoordinate2D destinationLocation;
    UISlider *radiusSlider;
    UITextView *postTextView;
    UIButton *shoutButton;
    UIButton *textButton;
    GMSMarker *currentLocationMarker;
    GMSMarker *destinationLocationMarker;
    GMSCircle *circle;
    int radiusSize;
}



// map stuff


// Action that changes the radius of the circle overlay whenever the the slider is changed
- (IBAction)sliderChanged:(UISlider*)sender
{
    // Gets the size from the slider
    radiusSize = sender.value;
    
    [mapView clear];
    circle = [GMSCircle circleWithPosition:destinationLocation radius:radiusSize];
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapView;
    
    // Creates a marker at current position.
    [self addLocationMarker:currentLocationMarker withPostion:myCurrentLocation withTitle:@"Me" withSnippet:@"My Location" withColor:[UIColor blueColor]];
    [self addLocationMarker:destinationLocationMarker withPostion:destinationLocation withTitle:@"Destination" withSnippet:nil withColor:[UIColor redColor]];

    
}

// Method that will add a location marker
- (void) addLocationMarker:(GMSMarker*)marker withPostion:(CLLocationCoordinate2D)markerPosition withTitle:(NSString *)title withSnippet:(NSString *)snippet withColor:(UIColor*)color
{
    // If the current location is the same as the destination location, make marker purple.
    if (myCurrentLocation.latitude == destinationLocation.latitude && myCurrentLocation.longitude == destinationLocation.longitude)
        color = [UIColor purpleColor];
        
    
    // Creates a marker at the location given.
    marker.position = CLLocationCoordinate2DMake(markerPosition.latitude, markerPosition.longitude);
    marker.title = title;
    marker.snippet = snippet;
    marker.icon = [GMSMarker markerImageWithColor:color];
    marker.map = mapView;
}


//  other stuff

- (IBAction)postShout:(id)sender
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([postTextView.text isEqualToString:@"Let's hear it!"] && [postTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[postTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": postTextView.text, @"latitude": [NSNumber numberWithDouble:myCurrentLocation.latitude], @"longitude": [NSNumber numberWithDouble:myCurrentLocation.longitude], @"radius" : [NSNumber numberWithDouble:radiusSlider.value]};
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        
        // authentication
        NSString *authStr = self.token;
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSError *error = nil;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        NSLog(@"Response: %@", error);
        
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return textField.text.length + (string.length - range.length) <= 30;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Let's hear it!"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [textView becomeFirstResponder];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 140;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Let's hear it!";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}


-(void) mapView:(GMSMapView *)mapview didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    circle.map = nil;
    // Creates a marker at current position.
    destinationLocation = coordinate;
    circle.position = coordinate;
    circle.radius = radiusSize;
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapview;
    [self addLocationMarker:currentLocationMarker withPostion:myCurrentLocation withTitle:@"Me" withSnippet:@"My Location" withColor:[UIColor blueColor]];
    [self addLocationMarker:destinationLocationMarker withPostion:coordinate withTitle:@"Destination" withSnippet:nil withColor:[UIColor redColor]];
    
}

-(IBAction)editText:(id)sender
{
    [postTextView becomeFirstResponder];
}

- (IBAction)jumpToLocation:(id)sender
{
    [mapView animateToLocation:myCurrentLocation];
}

-(void)mapView:(GMSMapView *)mapview willMove:(BOOL)gesture
{
    [postTextView resignFirstResponder];
}

-(void)mapView:(GMSMapView *)mapview didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [postTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //  handle setting up location updates
    
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:18];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    
    
   // mapView.settings.myLocationButton = YES;
    // Adds compass
//    mapView.settings.compassButton = YES;
    
    radiusSize = 40;
    circle = [GMSCircle circleWithPosition:locationManager.location.coordinate radius:radiusSize];
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapView;
    // Gets the current location
    myCurrentLocation = locationManager.location.coordinate;
    
    // Sets default destination location to the current location
    destinationLocation = locationManager.location.coordinate;
    
    mapView.delegate = self;
    self.view = mapView;
    
    // Creates a marker at current position.
    currentLocationMarker = [[GMSMarker alloc] init];
    destinationLocationMarker =[[GMSMarker alloc] init];
    
    // Creates a marker at current position.
    [self addLocationMarker:destinationLocationMarker withPostion:destinationLocation withTitle:@"Destination" withSnippet:@"My Location" withColor:[UIColor redColor]];

    //  text view color and shape
    postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 75, 225, 75)];
    postTextView.layer.cornerRadius = 8.0;
    postTextView.layer.masksToBounds = YES;
    
    // Default text view
    postTextView.text = @"Let's hear it!";
    postTextView.textColor = [UIColor lightGrayColor];
    postTextView.userInteractionEnabled = YES;
    postTextView.editable = YES;
    postTextView.delegate = self;
    

    
    [self.view addSubview:postTextView];
    
    
    // Recreating myLocation Button
    UIImage* myLocationIcon = [UIImage imageNamed:@"MyLocation.png"];
    // Adds button that jumps back to current location
    UIButton *myLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(272, 497, 35, 35)];
    myLocationButton.layer.cornerRadius = 8.0;
    [myLocationButton setBackgroundColor:[UIColor whiteColor]];
    [myLocationButton setBackgroundImage:myLocationIcon forState:UIControlStateNormal];
    [myLocationButton addTarget:self action:@selector(jumpToLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationButton];
    
    // Prevents the scroll bar from automatically scrolling down
    self.automaticallyAdjustsScrollViewInsets = NO;


    
    //  add slider
    radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 450, 225, 20)];
    
    //  set the max and min value for the radius
    radiusSlider.minimumValue = 40;
    radiusSlider.maximumValue = 100;
    
    [self.view addSubview:radiusSlider];
    [radiusSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

    
    //  add shoutbutton
    shoutButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 490, 175, 50)];
    shoutButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    shoutButton.clipsToBounds = YES;
    [shoutButton setTitle:@"SHOUT IT!" forState:UIControlStateNormal];
    [shoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    shoutButton.backgroundColor = [UIColor whiteColor];
    [shoutButton addTarget:self action:@selector(postShout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoutButton];
    
    

    // button to allow editing of text
    textButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 75, 225, 75)];
    textButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    textButton.clipsToBounds = YES;
    [textButton addTarget:self action:@selector(editText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
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
