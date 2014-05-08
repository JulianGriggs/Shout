//
//  JCCReplyViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 4/14/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCReplyViewController.h"
#import "JCCPostViewController.h"
#import "JCCUserViewController.h"
#import "JCCReplyTableViewController.h"
#import "JCCUserCredentials.h"

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





//  set the message id
-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
    
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





////  reply pressed button handler
//-(IBAction)replyComposeButtonPressed:(id)sender
//{
//    //  text view color and shape
//    composeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];
//    composeView.layer.masksToBounds = YES;
//    composeView.backgroundColor = [UIColor whiteColor];
//    composeView.alpha = 0.5;
//    [self.view addSubview:composeView];
//    
//    // add the cancel button 
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
//    [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
//    
//    //  add the reply field
//    //  text view color and shape
//    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 125, 225, 75)];
//    replyTextView.layer.cornerRadius = 8.0;
//    replyTextView.layer.masksToBounds = YES;
//    
//    // Default text view
//    replyTextView.text = @"Reply here!";
//    replyTextView.textColor = [UIColor lightGrayColor];
//    replyTextView.userInteractionEnabled = YES;
//    replyTextView.editable = YES;
//    replyTextView.delegate = self;
//    [self.view addSubview:replyTextView];
//    
//    
//    //  add reply button
//    replyButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 207, 175, 50)];
//    replyButton.layer.cornerRadius = 8.0; // this value vary as per your desire
//    replyButton.clipsToBounds = YES;
//    [replyButton setTitle:@"REPLY!" forState:UIControlStateNormal];
//    [replyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    replyButton.backgroundColor = [UIColor whiteColor];
//    [replyButton addTarget:self action:@selector(postReply:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:replyButton];
//    
//}


- (void) resetAfterReply
{
    [self textViewDidEndEditing:replyTextView];
    replyTextView.text = @"Reply here!";
    replyTextView.textColor =[UIColor lightGrayColor];
}


//  handle posting a reply
-(IBAction)postReply:(id)sender
{
    // post the reply
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([replyTextView.text isEqualToString:@"Reply here!"] && [replyTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[replyTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": replyTextView.text};
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *authStr = sharedUserToken;
                
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        NSLog(@"%@", authValue);
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        //  build the appropriate URL
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://aeneas.princeton.edu:8000/api/v1/replies?message_id=", Id];
        
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        //  refresh the table of replies after posting
        [tableViewController refresh];
        
        // reset the screen
        [self resetAfterReply];
        
        //  add the reply compose button
        UIBarButtonItem *replyComposeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(replyComposeButtonPressed:)];
        [self.navigationItem setRightBarButtonItem:replyComposeButton animated:YES];
        
    }
}





// handle the number of cahracters in the text field
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [textView becomeFirstResponder];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 140;
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [replyTextView resignFirstResponder];
}





// handle text in text view
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"In text view did begin editing");
    if ([textView.text isEqualToString:@"Reply here!"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [outerReplyView setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - keyboardSize - 60 , [UIScreen mainScreen].bounds.size.width, 60)];
        [replyTextView setFrame:CGRectMake(50,[UIScreen mainScreen].bounds.size.height - keyboardSize - 55 , 225, 50)];
        replyTextView.layer.cornerRadius=8.0f;
        replyTextView.layer.masksToBounds = YES;
        [replyButton setFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-keyboardSize - 45, 35, 35)];
      
        
    }];
    [textView becomeFirstResponder];
}





// handle text in text view
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Reply here!";
        textView.textColor = [UIColor lightGrayColor];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [outerReplyView setFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
        [replyTextView setFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height-55, 225, 50)];
        [replyButton setFrame:CGRectMake(280, [UIScreen mainScreen].bounds.size.height-45, 35, 35)];
        replyTextView.layer.cornerRadius=8.0f;
        replyTextView.layer.masksToBounds = YES;
        
    }];

    [textView resignFirstResponder];
}





//  cancel button is pressed handler
-(IBAction)cancelButtonPressed:(id)sender
{
    //  delete the compose view
    [composeView removeFromSuperview];
    [replyTextView removeFromSuperview];
    [replyButton removeFromSuperview];
    
    //  add the reply compose button
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(replyComposeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:replyButton animated:YES];
}


// converts a UTC string to a date object
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
    
    
    //  years
    if ((timeInterval) / 31536000 >= 1)
    {
        return [NSString stringWithFormat:@"%d years ago", (int)(timeInterval) / 31536000];
    }
    
    //  days
    else if ((timeInterval) / 86400 >= 1)
    {
        return [NSString stringWithFormat:@"%d days ago", (int)(timeInterval) / 86400];
    }
    
    //  hours
    else if ((timeInterval) / 3600 >= 1)
    {
        return [NSString stringWithFormat:@"%d hours ago", (int)(timeInterval) / 3600];
    }
    
    //  minutes
    else if ((timeInterval) / 60 >= 1)
    {
        return [NSString stringWithFormat:@"%d mins ago", (int)(timeInterval) / 60];
    }
    
    if (timeInterval < 1)
        return [NSString stringWithFormat:@"right now"];
    
    //  seconds
    return [NSString stringWithFormat:@"%d secs ago", (int)timeInterval];
    
}



- (IBAction)sendUp:(UIButton*)sender
{
    
    // If black set to white, else set to black
    if ([likeButton.titleLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "down" button to black
        [self setDefaultLikeDislike:dislikeButton];
        
//        [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        dislikeButton.backgroundColor = [UIColor clearColor];
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [self setLikeAsMarked:likeButton];
//        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        likeButton.backgroundColor = [UIColor blackColor];
//        likeButton.layer.cornerRadius = 20.0;
//        likeButton.layer.masksToBounds = YES;
        
        // post the like
        // make the url with query variables
        NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
        NSString *url1 = [url stringByAppendingString:Id];
        NSString *url2 = [url1 stringByAppendingString:@"/like"];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *authStr = sharedUserToken;
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:url2]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        
        //  update the labels
        // send the get request
        url = [NSString stringWithFormat:@"%@%@", @"http://aeneas.princeton.edu:8000/api/v1/messages/", Id];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // check the response
        GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        // This parses the response from the server as a JSON object
        NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
        
        [likeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
        [dislikeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        //[likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //likeButton.backgroundColor = [UIColor clearColor];
        [self setDefaultLikeDislike:likeButton];
        
        
        // post the like
        // make the url with query variables
        NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
        NSString *url1 = [url stringByAppendingString:Id];
        NSString *url2 = [url1 stringByAppendingString:@"/like"];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *authStr = sharedUserToken;
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:url2]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        
        //  update the labels
        // send the get request
        url = [NSString stringWithFormat:@"%@%@", @"http://aeneas.princeton.edu:8000/api/v1/messages/", Id];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // check the response
        GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        // This parses the response from the server as a JSON object
        NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
        
        [likeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
        [dislikeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
    }
    
}





// Happens whenever a user clicks the "DOWN" button
- (IBAction)sendDown:(UIButton*)sender
{
    
    // If black set to red, else set to black
    if ([dislikeButton.titleLabel.textColor isEqual:[UIColor blackColor]])
    {
        // Resets the color of the "up" button to black
        [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        likeButton.backgroundColor = [UIColor clearColor];
        // Sets the color of the "down" button to blue when its highlighted and after being clicked
        [dislikeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dislikeButton.backgroundColor = [UIColor blackColor];
        dislikeButton.layer.cornerRadius = 20.0;
        dislikeButton.layer.masksToBounds = YES;
        
        // post the dislike
        // make the url with query variables
        NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
        NSString *url1 = [url stringByAppendingString:Id];
        NSString *url2 = [url1 stringByAppendingString:@"/dislike"];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *authStr = sharedUserToken;
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:url2]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        
        //  update the labels
        // send the get request
        url = [NSString stringWithFormat:@"%@%@", @"http://aeneas.princeton.edu:8000/api/v1/messages/", Id];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // check the response
        GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        // This parses the response from the server as a JSON object
        NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
        
        [likeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
        [dislikeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
        
        
    }
    else
    {
        // Sets the color of the "up" button to blue when its highlighted and after being clicked
        [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dislikeButton.backgroundColor = [UIColor clearColor];
        
        // post the dislike
        // make the url with query variables
        NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
        NSString *url1 = [url stringByAppendingString:Id];
        NSString *url2 = [url1 stringByAppendingString:@"/dislike"];
        
        
        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString *authStr = sharedUserToken;
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [request setURL:[NSURL URLWithString:url2]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        
        //  update the labels
        // send the get request
        url = [NSString stringWithFormat:@"%@%@", @"http://aeneas.princeton.edu:8000/api/v1/messages/", Id];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // check the response
        GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        
        // This parses the response from the server as a JSON object
        NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
        
        [likeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"likes"]]];
        [dislikeLabel setText:[NSString stringWithFormat:@"%@", [messageDict objectForKey:@"dislikes"]]];
    }
}




// Sets default to white background and black text for like/dislike labels
-(void)setDefaultLikeDislike:(UIButton*)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.layer.cornerRadius = 20.0;
    button.layer.masksToBounds = YES;
    
}





// if the user is found in the list for having liked, then highlight the like label
-(void)setLikeAsMarked:(UIButton*)button
{
//    [button setTitle:@"⋀" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
}





// if the user is found in the list for having disliked, then highlight the like label
-(void)setDislikeAsMarked:(UIButton*)button
{
//    [button setTitle:@"⋁" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    
}







- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    
    //  get the message being viewed
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
    NSString *url1 = [url stringByAppendingString:[NSString stringWithFormat:@"%@", Id]];
    
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url1]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    // This parses the response from the server as a JSON object
    NSDictionary *tempJsonObjects = [NSJSONSerialization JSONObjectWithData:
                                GETReply options:kNilOptions error:nil];
    
    
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    keyboardSize = 216;
    //  text view color and shape
    UITextView *postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 145, 225, 75)];

    
    // Default text view
    postTextView.text = [tempJsonObjects objectForKey:@"bodyField"];
    postTextView.textColor = [UIColor blackColor];
    postTextView.userInteractionEnabled = NO;
    postTextView.editable = NO;
    postTextView.layer.cornerRadius = 8.0;
    postTextView.clipsToBounds = YES;
    [self.view addSubview:postTextView];
    
    // username label
    UIFont* boldFont = [UIFont boldSystemFontOfSize:16.0];
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 85, 100, 30)];
    [usernameLabel setText:[tempJsonObjects objectForKey:@"owner"]];
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [usernameLabel setFont:boldFont];
    [self.view addSubview:usernameLabel];
    
    // time label
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 85, 100, 30)];
    [timeLabel setText:[self formatTime:[tempJsonObjects objectForKey:@"timestamp"]]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    UIFont* font = [UIFont systemFontOfSize:12.0];
    [timeLabel setFont:font];
    [timeLabel setTextColor:[UIColor blueColor]];
    [self.view addSubview:timeLabel];
    
    //  like label
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 197, 40, 40)];
    [likeLabel setText:[NSString stringWithFormat:@"%@", [tempJsonObjects objectForKey:@"likes"]]];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:likeLabel];
    
    //  dislike label
    dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 197, 40, 40)];
    [dislikeLabel setText:[NSString stringWithFormat:@"%@", [tempJsonObjects objectForKey:@"dislikes"]]];
    dislikeLabel.textAlignment = NSTextAlignmentCenter;
    [dislikeButton targetForAction:@selector(sendDown:) withSender:self];
    [self.view addSubview:dislikeLabel];
    
    // like button
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 227, 40, 40)];
    [likeButton setTitle:@"⋀" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(sendUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    
    // dislike button
    dislikeButton = [[UIButton alloc] initWithFrame:CGRectMake(277, 227, 40, 40)];
    [dislikeButton setTitle:@"⋁" forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dislikeButton addTarget:self action:@selector(sendDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dislikeButton];
    
    [self setDefaultLikeDislike:likeButton];
    [self setDefaultLikeDislike:dislikeButton];
    NSArray *usersLiked = [tempJsonObjects objectForKey:@"usersLiked"];
    NSArray *usersDisliked = [tempJsonObjects objectForKey:@"usersDisliked"];
    // Check to see if like or dislike should be highlighted
    for (NSString* person in usersLiked)
    {
        if ([person isEqualToString:sharedUserName])
            [self setLikeAsMarked:likeButton];
    }
    
    for (NSString* person in usersDisliked)
    {
        if ([person isEqualToString:sharedUserName])
            [self setDislikeAsMarked:dislikeButton];
    }

    
    //  create the table view controller
    tableViewController = [[JCCReplyTableViewController alloc] init];
    [tableViewController passMessageId:Id];
    
    // The table view controller's view
    table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 227, 0, 0)];
    table.contentInset = UIEdgeInsetsMake(0, 0, 350, 0);

    
    tableView.delegate = self;
    
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    
    // Adds the View of the table view controller as a subview
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

    
    
    //  add profile picture
    UIImageView *profilePricture = [[UIImageView alloc] initWithFrame:CGRectMake(7, 75, 60, 60)];
    [profilePricture setImage:[UIImage imageNamed:@"UserIcon.png"]];
    [self.view addSubview:profilePricture];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end