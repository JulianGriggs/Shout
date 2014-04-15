//
//  JCCReplyTableViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JCCReplyViewController.h"

@interface JCCReplyTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate>

-(void)passMessageId:(NSString *)messageId;

@end