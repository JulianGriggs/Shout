//
//  JCCLikeDislikeHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCTableViewCell1.h"

@interface JCCLikeDislikeHandler : NSObject
+ (void)sendUp:(UIButton*)sender fromTableViewController: (UITableViewController *)tableViewController;
+ (void)sendDown:(UIButton*)sender fromTableViewController:(UITableViewController *) tableViewController;
+(void)setDefaultLikeDislike:(JCCTableViewCell1*)cell;
+(void)setLikeAsMarked:(JCCTableViewCell1*)cell;
+(void)setDislikeAsMarked:(JCCTableViewCell1*)cell;

@end
