//
//  JCCAppDelegate.h
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface JCCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
extern CGFloat outerWindowHeight;  // 568 on 4 inch screen ----- 480 on 3.5 inch
extern CGFloat outerWindowWidth;  // 320 on 4 inch screen ----- 320 on 3.5 inch
extern int maxCharacters;
@end