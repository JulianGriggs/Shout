//
//  JCCReplyViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "JCCFeedTableViewController.h"

@interface JCCReplyViewController : UIViewController  <CLLocationManagerDelegate, UITextViewDelegate, UITableViewDelegate>

/***
 Sets the Id instance variable.
 ***/
-(void)passMessageId:(NSString *)messageId;

@end
