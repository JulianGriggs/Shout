//
//  JCCMuteHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCMuteHandler : NSObject
+ (void)sendMute:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController;
//typedef void (^UIAlertViewBlock) (UIAlertView *alertView);
//typedef void (^UIAlertViewCompletionBlock) (UIAlertView *alertView, NSInteger buttonIndex);
//
//@property (copy, nonatomic) UIAlertViewCompletionBlock tapBlock;
//@property (copy, nonatomic) UIAlertViewCompletionBlock willDismissBlock;
//@property (copy, nonatomic) UIAlertViewCompletionBlock didDismissBlock;
//
//@property (copy, nonatomic) UIAlertViewBlock willPresentBlock;
//@property (copy, nonatomic) UIAlertViewBlock didPresentBlock;
//@property (copy, nonatomic) UIAlertViewBlock cancelBlock;
//
//@property (copy, nonatomic) BOOL(^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView);
@end
