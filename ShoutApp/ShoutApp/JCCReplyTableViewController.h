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
#import "JCCDismissViewControllerDelegate.h"

@interface JCCReplyTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate, JCCDismissViewControllerDelegate>

/***
 Sets the Id instance variable.
 ***/
-(void)passMessageId:(NSString *)messageId;



/***
 Fetches shouts and then reloads the table.
 ***/
- (void)refresh;



/***
 Gets all of the replies to the current shout in question.
 ***/
- (NSArray*)fetchShouts;

@end