//
//  JCCTableViewCell.h
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCTableViewCell : UITableViewCell
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




@end