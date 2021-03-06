//
//  JCCOtherUserViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "JCCDismissViewControllerDelegate.h"

@interface JCCOtherUserViewController : UIViewController <CLLocationManagerDelegate, UITextViewDelegate, UITableViewDelegate, UIAlertViewDelegate, JCCDismissViewControllerDelegate>
@property (nonatomic, strong) NSString *otherUsername;
@end
