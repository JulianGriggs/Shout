//
//  JCCPostViewController.h
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "JCCDismissViewControllerDelegate.h"

@interface JCCPostViewController : UIViewController <UITextViewDelegate, NSURLConnectionDelegate, GMSMapViewDelegate, CLLocationManagerDelegate, JCCDismissViewControllerDelegate>
@end
