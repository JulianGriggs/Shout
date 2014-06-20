//
//  JCCEditProfileViewController.h
//  ShoutApp
//
//  Created by Cole McCracken on 6/8/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissProfPic;

@interface JCCEditProfileViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, weak) id<DismissProfPic> delegate;

@end



@protocol DismissProfPic <NSObject>
@required
- (void)dismissProfPicViewController:(UIViewController *)viewController;
@end