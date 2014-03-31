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

#define DEFAULT_SHOUT_RADIUS 40

@interface JCCPostViewController ()


@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UIButton *shoutButton;


//  map shit
@property (weak, nonatomic) IBOutlet MKMapView *mapViewController;
@property (strong, nonatomic) NSArray *annotationArray;
@property (strong, nonatomic) MKCircle *circleOverlay;


@end

@implementation JCCPostViewController



// map stuff
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    // get rid of the keyboard
    [self.postTextView resignFirstResponder];
    
    // remove the old annotation and old overlay
    [self.mapViewController removeAnnotations:self.annotationArray];
    [self.mapViewController removeOverlay:self.circleOverlay];
    
    
    
    //  make the new annotation
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapViewController];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapViewController convertPoint:touchPoint toCoordinateFromView:self.mapViewController];
    
    JCCAnnotation *annot = [[JCCAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    self.annotationArray = [[NSArray alloc] initWithObjects:annot, nil];
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:annot.coordinate radius:DEFAULT_SHOUT_RADIUS];
    [self.mapViewController addOverlay:self.circleOverlay];
    [self.mapViewController addAnnotation:annot];
}


//  customize the circle overlay
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *view = [[MKCircleView alloc] initWithCircle:overlay];
    view.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    return view;
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
        //  check if user has selected a location
        if (!self.circleOverlay)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You choose a location!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": self.postTextView.text, @"latitude": [NSNumber numberWithDouble:self.circleOverlay.coordinate.latitude], @"longitude": [NSNumber numberWithDouble:self.circleOverlay.coordinate.longitude], @"radius" : [NSNumber numberWithDouble:self.circleOverlay.radius]};
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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.postTextView.layer setBorderWidth: 1.0];
    [self.postTextView.layer setCornerRadius:8.0f];
    [self.postTextView.layer setMasksToBounds:YES];
    
    self.postTextView.delegate = self;
    self.postTextView.text = @"Let's hear it!";
    self.postTextView.textColor = [UIColor lightGrayColor];
    
    self.shoutButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.shoutButton.clipsToBounds = YES;
    
    
    
    //  more map stuff
    [self.mapViewController setDelegate:self];
    
    // round map corners
    //self.mapViewController.layer.cornerRadius = 10.0;

    
    
    // handle long press dropping pin
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.05; // seconds 
    [self.mapViewController addGestureRecognizer:lpgr];

}


-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    // do asynchronous coding on the location here or else it wont zoom
    MKUserLocation *myLocation = [self.mapViewController userLocation];
    CLLocationCoordinate2D coord = [[myLocation location] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 200, 200);
    [self.mapViewController setRegion:region animated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView commitAnimations];
    
    // remove the old annotation and old overlay
    [self.mapViewController removeAnnotations:self.annotationArray];
    [self.mapViewController removeOverlay:self.circleOverlay];
    
    
    
    //  make the new annotation

    JCCAnnotation *annot = [[JCCAnnotation alloc] init];
    annot.coordinate = coord;
    self.annotationArray = [[NSArray alloc] initWithObjects:annot, nil];
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:annot.coordinate radius:DEFAULT_SHOUT_RADIUS];
    [self.mapViewController addOverlay:self.circleOverlay];
    [self.mapViewController addAnnotation:annot];
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
