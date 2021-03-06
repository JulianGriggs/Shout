//
//  JCCReplyTableViewCell.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCReplyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *MessageTextView;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *MoreButton;
@property (weak, nonatomic) IBOutlet UIView *InnerView;
@property (weak, nonatomic) IBOutlet UILabel *MessageIDLabel;
@property UITableViewController *parentTableViewController;
@property (weak, nonatomic) IBOutlet UIButton *ProfileImageButton;



/***
 Sets up the cell including the profile imafe, username label, time label, message text view, and more button.
 ***/
- (JCCReplyTableViewCell *)setUpCellWithDictionary:(NSDictionary *) dictShout;
@end
