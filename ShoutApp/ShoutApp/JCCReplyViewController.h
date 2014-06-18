//
//  JCCReplyViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "JCCFeedTableViewController.h"

@interface JCCReplyViewController : UIViewController  <CLLocationManagerDelegate, UITextViewDelegate, UITableViewDelegate>

/***
 Sets the Id instance variable.
 ***/
-(void)passMessageId:(NSString *)messageId;
@property (weak, nonatomic) UIImageView *profileImage;
@property (weak, nonatomic) UITextView *messageTextView;
@property NSInteger numberLikes;
@property NSInteger numberDislikes;
@property BOOL userLiked;
@property BOOL userDisliked;
@property (weak, nonatomic) NSString* messageId;
@property (weak, nonatomic) NSString* userName;
@property (weak, nonatomic) NSString* time;

@end
