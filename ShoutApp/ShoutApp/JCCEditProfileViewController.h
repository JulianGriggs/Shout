//
//  JCCEditProfileViewController.h
//  ShoutApp
//
//  Created by Cole McCracken on 6/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCDismissViewControllerDelegate.h"

@interface JCCEditProfileViewController : UIViewController<UITextFieldDelegate, JCCDismissViewControllerDelegate>

@property (nonatomic, weak) id<JCCDismissViewControllerDelegate> delegate;

@end
