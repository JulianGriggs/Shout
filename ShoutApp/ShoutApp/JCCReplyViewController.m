//
//  JCCReplyViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCAppDelegate.h"
#import "JCCReplyViewController.h"
#import "JCCPostViewController.h"
#import "JCCUserViewController.h"
#import "JCCReplyTableViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"
#import "AFNetworking.h"

@interface JCCReplyViewController ()

@end

@implementation JCCReplyViewController
{
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    JCCReplyTableViewController *tableViewController;
    UITableView *tableView;
    NSString *Id;
    UILabel *usernameLabel;
    UILabel *timeLabel;
    UIView *mapCoverView;
    UITableView *table;
    UIImageView *profilePicture;
    UITextView *postTextView;
    UIButton *repliesButton;
    
    
    //  like label
    UILabel *likeLabel;
    //  dislike label
    UILabel *dislikeLabel;
    // like button
    UIButton *likeButton;
    // dislike button
    UIButton *dislikeButton;
    
    UIView *composeView;
    UIView *outerReplyView;
    UITextView *replyTextView;
    UIButton *replyButton;
    CGFloat keyboardSize;
    CGFloat screenWidth;
    CGFloat screenHeight;
}



/***
 Sets the Id instance variable.
 ***/
-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
}



/***
 Resets the reply screen to display the default message.
 ***/
- (void) resetAfterReply
{
    [self textViewDidEndEditing:replyTextView];
    replyTextView.text = @"Reply here!";
    replyTextView.textColor =[UIColor lightGrayColor];
}



/***
 Validates that there is actually a message to post.  If there is, then it posts the reply.
 ***/
-(IBAction)postReply:(id)sender
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([replyTextView.text isEqualToString:@"Reply here!"] && [replyTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[replyTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //Object for error handling
        NSError* error;
        
        NSDictionary *dictionaryData = @{@"bodyField": replyTextView.text, @"messageID": self.messageId};
        [JCCMakeRequests postReply:dictionaryData withID:self.messageId withPotentialError:&error];
        if(error)
        {
            JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
            [badView setMessage:error.localizedDescription];
            [self.navigationController pushViewController:badView animated:NO];
        }
        [tableViewController refresh];
        [self resetAfterReply];
    }
}



/***
 Validates the text in the reply to make sure that it doesn't contain any newline characters and to make sure that it isn't too long.
 ***/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView becomeFirstResponder];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= maxCharacters;
}



/***
 Makes the replyTextView the first responder upon a touch event.
 ***/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [replyTextView resignFirstResponder];
}



/***
 Clears the text view and animates up the replyTextView upon beginning editing.
 ***/
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Reply here!"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    // If 3.5 inch screen
    if (outerWindowHeight == 480)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [usernameLabel setFrame:CGRectMake(75, 70, 100, 30)];
            [timeLabel setFrame:CGRectMake(200, 70, 100, 30)];
            [profilePicture setFrame:CGRectMake(7, 75, 40, 40)];
            [postTextView setFrame:CGRectMake(50, 100, 225, 75)];
            
            [likeButton setFrame:CGRectMake(7, 127, 40, 40)];
            [likeLabel setFrame:CGRectMake(7, 107, 40, 40)];
            [dislikeButton setFrame:CGRectMake(277, 127, 40, 40)];
            [dislikeLabel setFrame:CGRectMake(275, 107, 40, 40)];
            [repliesButton setFrame:CGRectMake(0, 180, 320, 25)];
            
            [outerReplyView setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - keyboardSize - 60 , [UIScreen mainScreen].bounds.size.width, 60)];
            [replyTextView setFrame:CGRectMake(50,[UIScreen mainScreen].bounds.size.height - keyboardSize - 55 , 225, 50)];
            replyTextView.layer.cornerRadius=8.0f;
            replyTextView.layer.masksToBounds = YES;
            [replyButton setFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-keyboardSize - 45, 35, 35)];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [outerReplyView setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - keyboardSize - 60 , [UIScreen mainScreen].bounds.size.width, 60)];
            [replyTextView setFrame:CGRectMake(50,[UIScreen mainScreen].bounds.size.height - keyboardSize - 55 , 225, 50)];
            replyTextView.layer.cornerRadius=8.0f;
            replyTextView.layer.masksToBounds = YES;
            [replyButton setFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-keyboardSize - 45, 35, 35)];
            
        }];
    }
    [textView becomeFirstResponder];
}



/***
 Animates down the replyTextView
 ***/
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Reply here!";
        textView.textColor = [UIColor lightGrayColor];
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        [usernameLabel setFrame:CGRectMake(75, 85, 100, 30)];
        [timeLabel setFrame:CGRectMake(200, 85, 100, 30)];
        [profilePicture setFrame:CGRectMake(7, 75, 55, 55)];
        [postTextView setFrame:CGRectMake(50, 145, 225, 75)];
        
        [likeButton setFrame:CGRectMake(7, 207, 40, 40)];
        [likeLabel setFrame:CGRectMake(7, 177, 40, 40)];
        [dislikeButton setFrame:CGRectMake(277, 207, 40, 40)];
        [dislikeLabel setFrame:CGRectMake(275, 177, 40, 40)];
        [repliesButton setFrame:CGRectMake(0, 265, 320, 30)];
        
        
        [outerReplyView setFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
        [replyTextView setFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-55, 225, 50)];
        [replyButton setFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-45, 35, 35)];
        replyTextView.layer.cornerRadius=8.0f;
        replyTextView.layer.masksToBounds = YES;
    }];
    [textView resignFirstResponder];
}



/***
 Cancel button is pressed handler.
 ***/
-(IBAction)cancelButtonPressed:(id)sender
{
    //  delete the compose view
    [composeView removeFromSuperview];
    [replyTextView removeFromSuperview];
    [replyButton removeFromSuperview];
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
 Updates the UI appropriately to display that the user has either liked or removed thier own like.  Sends the actual "like" POST asynchronously.
 ***/
- (IBAction)sendUp:(UIButton*)sender
{
    NSString *getMessageID = self.messageId;
    
    // If black set to white, else set to black
    if ([likeButton.titleLabel.textColor isEqual:[UIColor blackColor]] && [likeButton.backgroundColor isEqual:[UIColor clearColor]])
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor blackColor];
        likeButton.layer.cornerRadius = 20.0;
        likeButton.layer.masksToBounds = YES;
        NSInteger numLikes = [likeLabel.text integerValue];
        [likeLabel setText:[NSString stringWithFormat:@"%d", numLikes + 1]];
        if ([dislikeButton.titleLabel.textColor isEqual:[UIColor whiteColor]])
        {
            // Resets the color of the "down" button to default
            [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            dislikeButton.backgroundColor = [UIColor clearColor];
            
            NSInteger numDislikes = [dislikeLabel.text integerValue];
            [dislikeLabel setText:[NSString stringWithFormat:@"%d", numDislikes - 1]];
        }
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor clearColor];
        NSInteger numLikes = [likeLabel.text integerValue];
        [likeLabel setText:[NSString stringWithFormat:@"%d", numLikes - 1]];
    }
    
    __block NSData *reply = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages/"];
    url = [url stringByAppendingString:getMessageID];
    url = [url stringByAppendingString:@"/like"];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         reply = (NSData*)responseObject;
//         [tableViewController fetchShouts];
//         [tableViewController.tableView reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [badView setMessage:error.localizedDescription];
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/***
 Updates the UI appropriately to display that the user has either disliked or removed thier own dislike.  Sends the actual "dislike" POST asynchronously.
 ***/
- (IBAction)sendDown:(UIButton*)sender
{
    NSString *getMessageID = self.messageId;
    
    // If black set to white, else set to black
    if ([dislikeButton.titleLabel.textColor isEqual:[UIColor blackColor]] && [dislikeButton.backgroundColor isEqual:[UIColor clearColor]])
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [dislikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dislikeButton.backgroundColor = [UIColor blackColor];
        dislikeButton.layer.cornerRadius = 20.0;
        dislikeButton.layer.masksToBounds = YES;
        NSInteger numDislikes = [dislikeLabel.text integerValue];
        [dislikeLabel setText:[NSString stringWithFormat:@"%d", numDislikes + 1]];
        if ([likeButton.titleLabel.textColor isEqual:[UIColor whiteColor]])
        {
            // Resets the color of the "down" button to default
            [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            likeButton.backgroundColor = [UIColor clearColor];
            NSInteger numLikes = [likeLabel.text integerValue];
            [likeLabel setText:[NSString stringWithFormat:@"%d", numLikes - 1]];
        }
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dislikeButton.backgroundColor = [UIColor clearColor];
        NSInteger numDislikes = [dislikeLabel.text integerValue];
        [dislikeLabel setText:[NSString stringWithFormat:@"%d", numDislikes - 1]];
    }
    
    __block NSData *reply = nil;
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages/"];
    url = [url stringByAppendingString:getMessageID];
    url = [url stringByAppendingString:@"/dislike"];
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
    //        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
    //                                    nil options:kNilOptions error:nil];
    [manager POST:url parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         reply = (NSData*)responseObject;
//         [tableViewController fetchShouts];
//         [tableViewController.tableView reloadData];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
         [tableViewController.navigationController pushViewController:badView animated:NO];
     }];
}



/***
 Sets the default to clear background and black text for like/dislike labels.
 ***/
-(void)setDefaultLikeDislike:(UIButton*)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.layer.cornerRadius = 20.0;
    button.layer.masksToBounds = YES;
    
}



/***
 Sets the like button to white text and a black background.
 ***/
-(void)setLikeAsMarked:(UIButton*)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
}



/***
 Sets the dislike button to white text and a black background.
 ***/
-(void)setDislikeAsMarked:(UIButton*)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Reply"];
    
    
    //  build the location manager
    if (!locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    [locationManager startUpdatingLocation];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
    //  add a map in the background
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:17];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    mapView.settings.consumesGesturesInView = NO;
    self.view = mapView;
    
    
    //  add view to cover map
    mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    mapCoverView.layer.masksToBounds = YES;
    mapCoverView.backgroundColor = [UIColor whiteColor];
    mapCoverView.alpha = 0.7;
    [self.view addSubview:mapCoverView];
    
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    keyboardSize = 216;
    
    // Default text view
    postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 145, 225, 75)];
    postTextView.text = self.messageTextView.text;
    postTextView.textColor = [UIColor blackColor];
    postTextView.userInteractionEnabled = NO;
    postTextView.editable = NO;
    postTextView.layer.cornerRadius = 8.0;
    postTextView.clipsToBounds = YES;
    [self.view addSubview:postTextView];
    
    // username label
    UIFont* boldFont = [UIFont boldSystemFontOfSize:16.0];
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 85, 100, 30)];
    [usernameLabel setText:self.userName];
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [usernameLabel setFont:boldFont];
    [self.view addSubview:usernameLabel];
    
    // time label
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 85, 100, 30)];
    [timeLabel setText:[self formatTime:self.time]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    [timeLabel setFont:font];
    
    UIColor *prettyBlue = [[UIColor alloc] initWithRed:74.0/255.0f green:127.0/255.0f blue:255.0/255.0f alpha:1.0f];
    [timeLabel setTextColor:prettyBlue];
    [self.view addSubview:timeLabel];
    
    //  like label
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 177, 40, 40)];
    [likeLabel setText:[NSString stringWithFormat:@"%ld", (long)self.numberLikes]];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:likeLabel];
    
    //  dislike label
    dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 177, 40, 40)];
    [dislikeLabel setText:[NSString stringWithFormat:@"%ld", (long)self.numberDislikes]];
    dislikeLabel.textAlignment = NSTextAlignmentCenter;
    [dislikeButton targetForAction:@selector(sendDown:) withSender:self];
    [self.view addSubview:dislikeLabel];
    
    // like button
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 207, 40, 40)];
    [likeButton setTitle:@"⋀" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    
    // dislike button
    dislikeButton = [[UIButton alloc] initWithFrame:CGRectMake(277, 207, 40, 40)];
    [dislikeButton setTitle:@"⋁" forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dislikeButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dislikeButton];
    
    [self setDefaultLikeDislike:likeButton];
    [self setDefaultLikeDislike:dislikeButton];

    if (self.userLiked) [self setLikeAsMarked:likeButton];
    if (self.userDisliked) [self setDislikeAsMarked:dislikeButton];
    
    //  create the table view controller
    tableViewController = [[JCCReplyTableViewController alloc] init];
    [tableViewController passMessageId:self.messageId];
    
    // The table view controller's view
    table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 227, 0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 350, 0);
    tableView.delegate = self;
    [self addChildViewController:tableViewController];
    [self.view addSubview:table];
    
    // Make gray background
    outerReplyView = [[UITextView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
    outerReplyView.layer.backgroundColor=[[UIColor blackColor]CGColor];
    [outerReplyView setUserInteractionEnabled:NO];
    [self.view addSubview:outerReplyView];
    
    // Make replyTextView
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-55, 225, 50)];
    replyTextView.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    replyTextView.userInteractionEnabled = YES;
    replyTextView.layer.cornerRadius=8.0f;
    replyTextView.layer.masksToBounds = YES;
    replyTextView.editable = YES;
    replyTextView.text = @"Reply here!";
    replyTextView.textColor = [UIColor lightGrayColor];
    replyTextView.delegate = self;
    [self.view addSubview:replyTextView];
    
    //  add reply button
    replyButton = [[UIButton alloc] initWithFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-45, 35, 35)];
    replyButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    replyButton.clipsToBounds = YES;
    [replyButton setBackgroundColor:[UIColor whiteColor]];
    [replyButton setBackgroundImage:[UIImage imageNamed:@"ClearReplyIcon.png"] forState:UIControlStateNormal];
    [replyButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [replyButton addTarget:self action:@selector(postReply:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replyButton];
    
    //add my shouts button
    repliesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 265, 320, 30)];
    repliesButton.backgroundColor = [UIColor blackColor];
    [repliesButton setTitle:@"Replies" forState:UIControlStateNormal];
    [self.view addSubview:repliesButton];
    
    //  add profile picture
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(7, 75, 55, 55)];
    profilePicture.layer.cornerRadius = 8.0;
    profilePicture.layer.masksToBounds = YES;

    [profilePicture setImage:self.profileImage.image];
    [self.view addSubview:profilePicture];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end