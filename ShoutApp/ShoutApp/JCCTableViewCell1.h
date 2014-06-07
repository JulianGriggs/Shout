//
//  JCCTableViewCell1.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/9/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCFeedTableViewController.h"

@interface JCCTableViewCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *MessageTextView;
@property (weak, nonatomic) IBOutlet UILabel *SenderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *MessageIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *EchoButton;
@property (weak, nonatomic) IBOutlet UIButton *ReplyButton;
@property (weak, nonatomic) IBOutlet UILabel *UpLabel;
@property (weak, nonatomic) IBOutlet UILabel *DownLabel;
@property (weak, nonatomic) IBOutlet UIButton *UpButton;
@property (weak, nonatomic) IBOutlet UIButton *DownButton;
@property (weak, nonatomic) IBOutlet UIImageView *ReplyIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *EchoIconImage;
@property (weak, nonatomic) IBOutlet UIButton *MoreButton;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfUpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfDownsLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfRepliesLabel;
@property (weak, nonatomic) IBOutlet UIView *InnerView;
@property (weak, nonatomic) IBOutlet UIButton *ProfileImageButton;

@property UITableViewController *parentTableViewController;

/***
 Sets up the cell including the profile image, username label, time label, message text view, upLabel, downLabel, and more button.
 ***/
- (JCCTableViewCell1 *)setUpCellWithDictionary:(NSDictionary *) dictShout;
@end
