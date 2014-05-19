//
//  JCCEchoHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCEchoHandler : NSObject
+ (void)sendEcho:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController;
@end
