//
//  JCCPostViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCAppDelegate.h"
#import "JCCPostViewController.h"
#import "JCCLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCAnnotation.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JCCErrorHandler.h"

#define DEFAULT_MIN_RADIUS 100

@interface JCCPostViewController ()


@end

@implementation JCCPostViewController
{
    // location manager
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    CLLocationCoordinate2D myCurrentLocation;
    CLLocationCoordinate2D destinationLocation;
    UISlider *radiusSlider;
    UITextView *postTextView;
    UIButton *shoutPrivateButton;
    UIButton *shoutPublicButton;
    UIButton *textButton;
    GMSMarker *currentLocationMarker;
    GMSMarker *destinationLocationMarker;
    GMSCircle *circle;
    int maxRadiusSize;
    int radiusSize;
}





/***
 Changes the radius of the circle overlay whenever the the slider is changed.
 ***/
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



/***
 Adds a location marker at the current position.
 ***/
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

/***
 Sends the POST shout request.  If the shout message is empty then it alerts the user through a pop up modal.
 ***/
- (IBAction)postPublicShout:(id)sender
{
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([postTextView.text isEqualToString:@"Let's hear it!"] && [postTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[postTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Object for error handling
        NSError* error;
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": postTextView.text, @"latitude": [NSNumber numberWithDouble:destinationLocation.latitude], @"longitude": [NSNumber numberWithDouble:destinationLocation.longitude], @"isPrivate": @NO, @"radius" : [NSNumber numberWithDouble:radiusSlider.value]};
        
        NSString *response = [JCCMakeRequests postShout:dictionaryData withPotentialError:&error];
        if(error)
        {
            [JCCErrorHandler displayErrorView:self withError:error];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        
    }
}

/***
 Sends the POST shout request.  If the shout message is empty then it alerts the user through a pop up modal.
 ***/
- (IBAction)postPrivateShout:(id)sender
{
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([postTextView.text isEqualToString:@"Let's hear it!"] && [postTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[postTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Object for error handling
        NSError* error;
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": postTextView.text, @"latitude": [NSNumber numberWithDouble:destinationLocation.latitude], @"longitude": [NSNumber numberWithDouble:destinationLocation.longitude], @"isPrivate": @YES, @"radius" : [NSNumber numberWithDouble:radiusSlider.value]};
        
        NSString *response = [JCCMakeRequests postShout:dictionaryData withPotentialError:&error];
        if(error)
        {
            [JCCErrorHandler displayErrorView:self withError:error];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        
    }
}



/***
 Makes it so that the text view does begin editing.
 ***/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}



/***
 Called when the textview does begin editing.
 ***/
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Let's hear it!"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}



/***
 Validates the text input for a shout.  Newlines are disallowed and shouts aren't allowed to be longer than maxCharacters in length.
 ***/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [textView becomeFirstResponder];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= maxCharacters;
}



/***
 Called when the text view is finished editing.
 ***/
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Let's hear it!";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}



/***
 Drops a pin at the location of a long press.
 ***/
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



/***
 Resigns the first responder status of the postTextView.
 ***/
-(IBAction)editText:(id)sender
{
    [postTextView becomeFirstResponder];
}



/***
 Animates the user back to the current location.
 ***/
- (IBAction)jumpToLocation:(id)sender
{
    [mapView animateToLocation:myCurrentLocation];
}



/***
 Resigns the first responder status of the text view when the map gets dragged.
 ***/
-(void)mapView:(GMSMapView *)mapview willMove:(BOOL)gesture
{
    [postTextView resignFirstResponder];
}



/***
 Resigns the first responder status of the text view when the map gets touched.
 ***/
-(void)mapView:(GMSMapView *)mapview didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [postTextView resignFirstResponder];
}



/***
 Updates the current user location.
 ***/
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *mostRecentLocation = (CLLocation *) locations.lastObject;
    myCurrentLocation = CLLocationCoordinate2DMake(mostRecentLocation.coordinate.latitude, mostRecentLocation.coordinate.longitude);
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //  handle setting up location updates
    
    
    // put title on navbar
    [self.navigationItem setTitle:@"Compose"];
    
    if (!locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //        locationManager.distanceFilter=kCLDistanceFilterNone;
        locationManager.distanceFilter=10;
        
        [locationManager startUpdatingLocation];
    }
    
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:17];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    
    // Object for error handling
    NSError* error;
    
    NSDictionary* userDict = [JCCMakeRequests getUserProfileWithPotentialError:&error];
    maxRadiusSize = [JCCMakeRequests getMaxRadiusSize:userDict];
    
    radiusSize = DEFAULT_MIN_RADIUS;
    
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
    UIButton *myLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(272, (outerWindowHeight-tabBarHeight) * 0.875, 35, 35)];
    myLocationButton.layer.cornerRadius = 8.0;
    [myLocationButton setBackgroundColor:[UIColor blackColor]];
    [myLocationButton setBackgroundImage:myLocationIcon forState:UIControlStateNormal];
    [myLocationButton addTarget:self action:@selector(jumpToLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationButton];
    
    // Prevents the scroll bar from automatically scrolling down
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    //  add slider
    //    radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 450, 225, 20)];
    radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, (outerWindowHeight-tabBarHeight) * 0.7923, 225, 20)];
    [radiusSlider setTintColor:[UIColor blackColor]];
    [radiusSlider setThumbTintColor:[UIColor blackColor]];
    //  set the max and min value for the radius
    radiusSlider.minimumValue = DEFAULT_MIN_RADIUS;
    radiusSlider.maximumValue = maxRadiusSize;
    
    [self.view addSubview:radiusSlider];
    [radiusSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    //  add shoutPublicButton
    //    shoutPublicButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 490, 175, 50)];
    shoutPublicButton = [[UIButton alloc] initWithFrame:CGRectMake(150, (outerWindowHeight-tabBarHeight) * 0.8627, 130 , 50)];
    shoutPublicButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    shoutPublicButton.clipsToBounds = YES;
    [shoutPublicButton setTitle:@"TO EVERYONE!" forState:UIControlStateNormal];
    [shoutPublicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shoutPublicButton.backgroundColor = [UIColor blackColor];
    [shoutPublicButton addTarget:self action:@selector(postPublicShout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoutPublicButton];
    
    //  add shoutPrivateButton
    //    shoutPrivateButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 490, 175, 50)];
    shoutPrivateButton = [[UIButton alloc] initWithFrame:CGRectMake(15, (outerWindowHeight-tabBarHeight) * 0.8627, 130, 50)];
    shoutPrivateButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    shoutPrivateButton.clipsToBounds = YES;
    [shoutPrivateButton setTitle:@"TO FRIENDS!" forState:UIControlStateNormal];
    [shoutPrivateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shoutPrivateButton.backgroundColor = [UIColor blackColor];
    [shoutPrivateButton addTarget:self action:@selector(postPrivateShout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoutPrivateButton];
    
    
    
    // button to allow editing of text
    textButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 75, 225, 75)];
    textButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    textButton.clipsToBounds = YES;
    [textButton addTarget:self action:@selector(editText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
}

/***
 The delegate method for dismissing the error view when the time comes.
 ***/
- (void)dismissViewController:(UIViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
