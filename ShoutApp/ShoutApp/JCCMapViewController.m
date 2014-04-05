//
//  JCCMapViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/29/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCMapViewController.h"
#import "JCCAnnotation.h"

#define DEFAULT_SHOUT_RADIUS 30

@interface JCCMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapViewController;
@property (strong, nonatomic) NSArray *annotationArray;
@property (strong, nonatomic) MKCircle *circleOverlay;

@end

@implementation JCCMapViewController

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Setting up the map
    [self.mapViewController setDelegate:self];
    
    // handle long press dropping pin
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //user needs to press for 2 seconds
    [self.mapViewController addGestureRecognizer:lpgr];
    
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
