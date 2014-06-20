//
//  JCCDismissViewControllerDelegate.h
//  ShoutApp
//
//  Created by Julian Griggs on 6/20/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCCDismissViewControllerDelegate <NSObject>
@required
- (void)dismissViewController:(UIViewController *)viewController;
@end

