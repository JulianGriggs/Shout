//
//  XYZFirstViewController.h
//  Shout_Interface
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZFirstViewController : UITableViewController
{
    NSArray *shouts;
}

- (void)fetchShouts;

@end
