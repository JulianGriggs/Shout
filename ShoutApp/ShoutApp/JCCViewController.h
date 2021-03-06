//
//  JCCViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCFeedTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JCCDismissViewControllerDelegate.h"

@interface JCCViewController : UIViewController <CLLocationManagerDelegate, JCCDismissViewControllerDelegate>

@end
