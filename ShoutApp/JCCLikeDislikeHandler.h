//
//  JCCLikeDislikeHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCLikeDislikeHandler : NSObject
+ (void)sendUp:(UIButton*)sender fromTableViewController: (UITableViewController *)tableViewController;
+ (void)sendDown:(UIButton*)sender fromTableViewController:(UITableViewController *) tableViewController;
@end
