//
//  JCCOtherUserShoutsTableViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JCCReplyViewController.h"
#import "JCCDismissViewControllerDelegate.h"

@interface JCCOtherUserShoutsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, JCCDismissViewControllerDelegate>
@property (nonatomic, strong) NSString *otherUsername;
@end