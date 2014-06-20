//
//  JCCUserViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/9/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "JCCProfPicViewController.h"
#import "JCCDismissViewController.h"

@interface JCCUserViewController : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, UITableViewDelegate, UIAlertViewDelegate, JCCDismissViewController>
@end
