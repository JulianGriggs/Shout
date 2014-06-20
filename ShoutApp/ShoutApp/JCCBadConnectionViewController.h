//
//  JCCBadConnectionViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/13/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCDismissViewControllerDelegate.h"

@interface JCCBadConnectionViewController : UIViewController

@property (weak, nonatomic) NSString* message;
@property (nonatomic, weak) id<JCCDismissViewControllerDelegate> delegate;

@end

