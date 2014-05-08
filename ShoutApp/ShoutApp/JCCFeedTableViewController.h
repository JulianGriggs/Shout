//
//  JCCFeedTableViewController.h
//  Shout
//
//  Created by Cameron Porter on 3/29/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JCCReplyViewController.h"

@interface JCCFeedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIAlertViewDelegate>
@end
