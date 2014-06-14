//
//  JCCTableViewCell.m
//  ShoutApp
//
//  Created by Cole McCracken on 6/11/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCTableViewCell.h"
#import "JCCLikeDislikeHandler.h"
#import "JCCReplyHandler.h"
#import "JCCEchoHandler.h"
#import "JCCMuteHandler.h"
#import "JCCMakeRequests.h"
#import "JCCUserCredentials.h"
#import "AFNetworking.h"
#import "JCCOtherUserViewController.h"


@implementation JCCTableViewCell
{
    int width;
    int height;
    int emptySpaceFromTop;
    int emptySpaceFromBottom;
    int emptySpaceFromLeftRight;
    int profileSideLength;
    int singleLineLabelHeight;
    int bottomButtonWidth;
    int bottomButtonHeight;
    int messageXValue;
    int messageYValue;
    int messageWidth;
    int messageHeight;
    int usernameXValue;
    int usernameWidth;
    int timeXValue;
    int timeWidth;
    int iconLabelWidth;
    int numberLabelWidth;
    int spaceingOnBottomLayer;
}
@synthesize MessageTextView;
@synthesize SenderIDLabel;
@synthesize MessageIDLabel;
@synthesize UsernameLabel;
@synthesize TimeLabel;
@synthesize ProfileImage;
@synthesize EchoButton;
@synthesize ReplyButton;
@synthesize UpLabel;
@synthesize DownLabel;
@synthesize UpButton;
@synthesize DownButton;
@synthesize ReplyIconImage;
@synthesize EchoIconImage;
@synthesize MoreButton;
@synthesize NumberOfUpsLabel;
@synthesize NumberOfDownsLabel;
@synthesize NumberOfRepliesLabel;
@synthesize InnerView;
@synthesize ProfileImageButton;
@synthesize parentTableViewController;


/***
 Send the like.
 ***/
- (IBAction)sendUp:(UIButton*)sender
{
    // post the like
    [JCCLikeDislikeHandler sendUp:sender fromTableViewController:self.parentTableViewController];
}



/***
 Send the dislike.
 ***/
- (IBAction)sendDown:(UIButton*)sender
{
    // post the dislike
    [JCCLikeDislikeHandler sendDown:sender fromTableViewController:self.parentTableViewController];
}



/***
 Send the reply.
 ***/
- (IBAction)sendReply:(UIButton*)sender
{
    [JCCReplyHandler sendReply:sender fromTableViewController:self.parentTableViewController];
}



/***
 Send the echo.
 ***/
- (IBAction)sendEcho:(UIButton*)sender
{
    [JCCEchoHandler sendEcho:sender fromTableViewController:self.parentTableViewController];
}



/***
 Displayes the mute option.
 ***/
- (IBAction)showMuteOption:(UIButton*)sender
{
    [JCCMuteHandler sendMute:sender fromTableViewController:self.parentTableViewController];
#warning FUCK THIS BULLSHIT  this threw compile error when i switched to dynamic and i couldnt fix it
  /*  if([self.parentTableViewController fetchShouts] == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
    }
    else
    { */
        [self.parentTableViewController.tableView reloadData];
    //}
}



/***
 Converts a UTC string to a date object.
 ***/
- (NSString *) formatTime:(NSString *) timeString
{
    NSString* input = timeString;
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *now = [NSDate date];
    
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:input];
    double timeInterval = [now timeIntervalSinceDate:utcDate];
    timeInterval = timeInterval + 37;
    
    // years
    if ((timeInterval) / 31536000 >= 1)
    {
        if ((int)(timeInterval) / 31536000 == 1)
        {
            return @"1 year ago";
        }
        else
            return [NSString stringWithFormat:@"%d years ago", (int)(timeInterval) / 31536000];
    }
    
    // days
    else if ((timeInterval) / 86400 >= 1)
    {
        if ((int)(timeInterval) / 86400 == 1)
            return @"1 day ago";
        else
            return [NSString stringWithFormat:@"%d days ago", (int)(timeInterval) / 86400];
    }
    
    // hours
    else if ((timeInterval) / 3600 >= 1)
    {
        if ((int)(timeInterval) / 3600 == 1)
            return @"1 hour ago";
        else
            return [NSString stringWithFormat:@"%d hours ago", (int)(timeInterval) / 3600];
    }
    
    // minutes
    else if ((timeInterval) / 60 >= 1)
    {
        if ((int)(timeInterval) / 60 == 1)
            return @"1 min ago";
        else
            return [NSString stringWithFormat:@"%d mins ago", (int)(timeInterval) / 60];
    }
    
    // Moments
    else if (timeInterval < 1)
        return [NSString stringWithFormat:@"right now"];
    
    // seconds
    else
        return [NSString stringWithFormat:@"%d secs ago", (int)timeInterval];
}



/***
 Asynchronously loads the profile image in the cell.
 ***/
- (void) loadProfileImageUsingDictionary:(NSDictionary *) dictShout
{
    __block NSData *profPicData = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/static/shout/images/"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         profPicData = (NSData*)responseObject;
         [self.ProfileImage setImage:[UIImage imageWithData:profPicData]];
         self.ProfileImage.layer.cornerRadius = 8.0;
         self.ProfileImage.layer.masksToBounds = YES;
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/***
 Transitions to the other user page.
 ***/
- (IBAction)transitionToUserPage:(id)sender
{
    JCCOtherUserViewController *otherViewController = [[JCCOtherUserViewController alloc] init];
    otherViewController.otherUsername = self.UsernameLabel.text;
    
    NSDictionary *profileAttempt = [JCCMakeRequests getUserProfile];
    if (profileAttempt == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.parentTableViewController.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.parentTableViewController.navigationController pushViewController:otherViewController animated:YES];
    }
}



/***
 Sets up the cell including the profile image, username label, time label, message text view, upLabel, downLabel, and more button.
 ***/
- (JCCTableViewCell *)setUpCellWithDictionary:(NSDictionary *) dictShout
{
    NSLog(@"here");
    // Asynchronously loads the profile image in the cell
    [self loadProfileImageUsingDictionary:dictShout];
    
    height = messageHeight + 70;
    [self.MessageTextView setText:[dictShout objectForKey:@"bodyField"]];
    [self.MessageTextView setBackgroundColor:[UIColor lightTextColor]];
    [self.UsernameLabel setText:[dictShout objectForKey:@"owner"]];
    
    
    [self.TimeLabel setText:[self formatTime:[dictShout objectForKey:@"timestamp"]]];
    [self.NumberOfUpsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"likes"]]];
    self.UpLabel.layer.cornerRadius = 8.0;
    self.UpLabel.layer.masksToBounds = NO;
    
    [self.NumberOfDownsLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"dislikes"]]];
    self.DownLabel.layer.cornerRadius = 8.0;
    self.DownLabel.layer.masksToBounds = NO;
    
    [self.NumberOfRepliesLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"numReplies"]]];
    
    
    [self.MessageIDLabel setText:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"id"]]];
    [self.SenderIDLabel setText:@""];
    
    self.InnerView.layer.cornerRadius = 8.0;
    self.InnerView.layer.masksToBounds = YES;
    
    // Set current like/dislike
    NSArray *usersLiked = [dictShout objectForKey:@"usersLiked"];
    NSArray *usersDisliked = [dictShout objectForKey:@"usersDisliked"];
    
    // Default colors for likes/dislikes
    [JCCLikeDislikeHandler setDefaultLikeDislike:self];
    
    // Check to see if like or dislike should be highlighted
    for (NSString* person in usersLiked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setLikeAsMarked:self];
    }
    
    for (NSString* person in usersDisliked)
    {
        if ([person isEqualToString:sharedUserName])
            [JCCLikeDislikeHandler setDislikeAsMarked:self];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        width = 320;
        height = frame.size.height;
        emptySpaceFromTop = 13;
        emptySpaceFromBottom = 10;
        emptySpaceFromLeftRight = 5;
        profileSideLength = 55;
        singleLineLabelHeight = 21;
        bottomButtonWidth = 55;
        bottomButtonHeight = 28;
        messageXValue = 68;
        messageYValue = 31;
        messageWidth = 225;
        messageHeight = height - 70;
        usernameXValue = 72;
        usernameWidth = 112;
        timeXValue = 200;
        timeWidth = 93;
        iconLabelWidth = 20;
        numberLabelWidth = 35;
        spaceingOnBottomLayer = 10;
        
        ProfileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight, emptySpaceFromTop, profileSideLength, profileSideLength)];
        [self addSubview:ProfileImageButton];
        
        ProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight, emptySpaceFromTop, profileSideLength, profileSideLength)];
        [self addSubview:ProfileImage];
        [self bringSubviewToFront:ProfileImage];
        
        UsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(usernameXValue, emptySpaceFromTop, usernameWidth, singleLineLabelHeight)];
        [self addSubview:UsernameLabel];
        [self bringSubviewToFront:UsernameLabel];
        
        TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeXValue, emptySpaceFromTop, timeWidth, singleLineLabelHeight)];
        [self addSubview:TimeLabel];
        [self bringSubviewToFront:TimeLabel];
        
        UpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height - emptySpaceFromBottom - bottomButtonHeight, bottomButtonWidth, bottomButtonHeight)];
        [self addSubview:UpButton];
        [self bringSubviewToFront:UpButton];
        
        DownButton = [[UIButton alloc] initWithFrame:CGRectMake(bottomButtonWidth + emptySpaceFromBottom, height - emptySpaceFromBottom - bottomButtonHeight, bottomButtonWidth, bottomButtonHeight)];
        [self addSubview:DownButton];
        [self bringSubviewToFront:DownButton];

        ReplyButton = [[UIButton alloc] initWithFrame:CGRectMake(2*(bottomButtonWidth + emptySpaceFromBottom), height - emptySpaceFromBottom - bottomButtonHeight, bottomButtonWidth, bottomButtonHeight)];
        [self addSubview:ReplyButton];
        [self bringSubviewToFront:ReplyButton];
        
        EchoButton = [[UIButton alloc] initWithFrame:CGRectMake(3*(bottomButtonWidth + emptySpaceFromBottom), height - emptySpaceFromBottom - bottomButtonHeight, bottomButtonWidth, bottomButtonHeight)];
        [self addSubview:EchoButton];
        [self bringSubviewToFront:EchoButton];
        
        MoreButton = [[UIButton alloc] initWithFrame:CGRectMake(4.6*(bottomButtonWidth), height - emptySpaceFromBottom - bottomButtonHeight, bottomButtonWidth, bottomButtonHeight)];
        [MoreButton setTitle:@"..." forState:UIControlStateNormal];
        [MoreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:MoreButton];
        [self bringSubviewToFront:MoreButton];
        
        UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        UpLabel.text = @"⋀";
        [self addSubview:UpLabel];
        [self bringSubviewToFront:UpLabel];
        
        NumberOfUpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + iconLabelWidth + spaceingOnBottomLayer, height - emptySpaceFromBottom - singleLineLabelHeight, numberLabelWidth, singleLineLabelHeight)];
        [self addSubview:NumberOfUpsLabel];
        [self bringSubviewToFront:NumberOfUpsLabel];
        
        DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + iconLabelWidth + 2*spaceingOnBottomLayer + numberLabelWidth, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        DownLabel.text = @"⋀";
        [self addSubview:DownLabel];
        [self bringSubviewToFront:DownLabel];
        
        NumberOfDownsLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + 2*iconLabelWidth + 3*spaceingOnBottomLayer + numberLabelWidth, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        [self addSubview:NumberOfDownsLabel];
        [self bringSubviewToFront:NumberOfDownsLabel];
        
        ReplyIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + 2*iconLabelWidth + 4*spaceingOnBottomLayer + 2*numberLabelWidth, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        [self addSubview:ReplyIconImage];
        [self bringSubviewToFront:ReplyIconImage];

        NumberOfRepliesLabel = [[UILabel alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + 3*iconLabelWidth + 5*spaceingOnBottomLayer + 2*numberLabelWidth, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        [self addSubview:NumberOfRepliesLabel];
        [self bringSubviewToFront:NumberOfRepliesLabel];
        
        EchoIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(emptySpaceFromLeftRight + 3*iconLabelWidth + 6*spaceingOnBottomLayer + 3*numberLabelWidth, height - emptySpaceFromBottom - singleLineLabelHeight, iconLabelWidth, singleLineLabelHeight)];
        //[ReplyIconImage setImage:@"ReplyIcon"];
        [self addSubview:EchoIconImage];
        [self bringSubviewToFront:EchoIconImage];


        
        MessageTextView = [[UITextView alloc] initWithFrame:CGRectMake(messageXValue, messageYValue, messageWidth, messageHeight)];
        [self addSubview:MessageTextView];
        [self bringSubviewToFront:MessageTextView];
        
        
        // Connects the buttons to their respective actions
        [self.UpButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.DownButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.ReplyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
        [self.EchoButton addTarget:self action:@selector(sendEcho:) forControlEvents:UIControlEventTouchUpInside];
        [self.MoreButton addTarget:self action:@selector(showMuteOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.ProfileImageButton addTarget:self action:@selector(transitionToUserPage:) forControlEvents:UIControlEventTouchUpInside];
        /*
        [UsernameLabel addTarget:self action:@selector(postLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton]; */
    }
    return self;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
