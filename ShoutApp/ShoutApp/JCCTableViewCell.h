//
//  JCCTableViewCell.h
//  ShoutApp
//
//  Created by Cole McCracken on 6/11/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *MessageTextView;
@property (strong, nonatomic) IBOutlet UILabel *SenderIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *MessageIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (strong, nonatomic) IBOutlet UIButton *EchoButton;
@property (strong, nonatomic) IBOutlet UIButton *ReplyButton;
@property (strong, nonatomic) IBOutlet UILabel *UpLabel;
@property (strong, nonatomic) IBOutlet UILabel *DownLabel;
@property (strong, nonatomic) IBOutlet UIButton *UpButton;
@property (strong, nonatomic) IBOutlet UIButton *DownButton;
@property (strong, nonatomic) IBOutlet UIImageView *ReplyIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *EchoIconImage;
@property (strong, nonatomic) IBOutlet UIButton *MoreButton;
@property (strong, nonatomic) IBOutlet UILabel *NumberOfUpsLabel;
@property (strong, nonatomic) IBOutlet UILabel *NumberOfDownsLabel;
@property (strong, nonatomic) IBOutlet UILabel *NumberOfRepliesLabel;
@property (strong, nonatomic) IBOutlet UIView *InnerView;
@property (strong, nonatomic) IBOutlet UIButton *ProfileImageButton;

@property (strong, nonatomic)UITableViewController *parentTableViewController;

- (JCCTableViewCell *)setUpCellWithDictionary:(NSDictionary *) dictShout;

@end
