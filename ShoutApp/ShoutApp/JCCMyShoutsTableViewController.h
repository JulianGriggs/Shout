//
//  JCCMyShoutsTableViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JCCReplyViewController.h"
#import "JCCDismissViewControllerDelegate.h"

@interface JCCMyShoutsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, JCCDismissViewControllerDelegate>
@end

