//
//  JCCPostViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCAnnotation.h"
#import <GoogleMaps/GoogleMaps.h>

#define DEFAULT_SHOUT_RADIUS 40

@interface JCCPostViewController ()
{
    int size;
    
    // location manager
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIButton *shoutButton;


//  map shit

@end

@implementation JCCPostViewController
{
    GMSMapView *mapView;
    CLLocationCoordinate2D currentCenter;
    UISlider *radiusSlider;
    UITextView * postTextView;
}



// map stuff


// Action that changes the radius of the circle overlay whenever the the slider is changed
- (IBAction)sliderChanged:(UISlider*)sender {
    // Gets the size from the slider
    size = sender.value;
    
    [mapView clear];
    GMSCircle *circle = [GMSCircle circleWithPosition:currentCenter radius:size];
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapView;
    
}


//  other stuff

- (IBAction)postShout:(id)sender
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([self.postTextView.text isEqualToString:@"Let's hear it!"] && [self.postTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[self.postTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": self.postTextView.text, @"latitude": [NSNumber numberWithDouble:currentCenter.latitude], @"longitude": [NSNumber numberWithDouble:currentCenter.longitude], @"radius" : [NSNumber numberWithDouble:radiusSlider.value]};
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return textField.text.length + (string.length - range.length) <= 30;
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
    [mapview clear];
    GMSCircle *circle = [GMSCircle circleWithPosition:coordinate radius:40];
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapview;
    currentCenter = coordinate;
    
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
    [mapView animateToViewingAngle:45];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    
    GMSCircle *circle = [GMSCircle circleWithPosition:locationManager.location.coordinate radius:40];
    circle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.2];
    circle.strokeColor = [UIColor redColor];
    circle.strokeWidth = 1;
    circle.map = mapView;
    currentCenter = locationManager.location.coordinate;

    mapView.delegate = self;
    self.view = mapView;

    //  text view color and shape
    postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 75, 225, 75)];
    postTextView.layer.cornerRadius = 8.0;
    postTextView.layer.masksToBounds = YES;
    
    // Default text view
    postTextView.text = @"Let's hear it!";
    postTextView.textColor = [UIColor lightGrayColor];
    [postTextView setUserInteractionEnabled:YES];
    [postTextView setEditable:YES];
    postTextView.delegate = self;
    [self.view addSubview:postTextView];
    
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
    UIButton *shoutButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 490, 225, 50)];
    shoutButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    shoutButton.clipsToBounds = YES;
    [shoutButton setTitle:@"SHOUT IT!" forState:UIControlStateNormal];
    [shoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    shoutButton.backgroundColor = [UIColor whiteColor];
    [shoutButton addTarget:self action:@selector(postShout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoutButton];
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
