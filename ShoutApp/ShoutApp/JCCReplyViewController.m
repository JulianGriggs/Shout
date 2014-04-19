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
        
        NSString *authStr = self.token;
                
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
        textView.textColor = [UIColor blackColor]; //optional
    }
    [UIView animateWithDuration:0.3 animations:^{
        [outerReplyView setFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - keyboardSize - 60 , [UIScreen mainScreen].bounds.size.width, 60)];
        [replyTextView setFrame:CGRectMake(25,[UIScreen mainScreen].bounds.size.height - keyboardSize - 55 , 225, 50)];
        [replyButton setFrame:CGRectMake(255, [UIScreen mainScreen].bounds.size.height-keyboardSize - 55, 50, 50)];
        [likeLabel setFrame:CGRectMake(7, 137, 40, 40)];
        [dislikeLabel setFrame:CGRectMake(277, 137, 40, 40)];
        [likeButton setFrame:CGRectMake(7, 157, 40, 40)];
        [dislikeButton setFrame:CGRectMake(277, 157, 40, 40)];
      
//        [mapView setFrame:CGRectMake(0, 0, 320, 215)];
//        [mapCoverView setFrame:CGRectMake(0, 0, 320, 215)];
//        [tableViewController.tableView setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 150,0, 0)];
//        [tableViewController passMessageId:Id];
        
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
    [UIView animateWithDuration:0.3 animations:^{
        [outerReplyView setFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
        [replyTextView setFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height-55, 225, 50)];
        [replyButton setFrame:CGRectMake(255, [UIScreen mainScreen].bounds.size.height-55, 50, 50)];
        [likeLabel setFrame:CGRectMake(7, 187, 40, 40)];
        [dislikeLabel setFrame:CGRectMake(275, 187, 40, 40)];
        [likeButton setFrame:CGRectMake(7, 207, 40, 40)];
        [dislikeButton setFrame:CGRectMake(277, 207, 40, 40)];
//        [mapView setFrame:CGRectMake(0, 0, 320, 265)];
//        [mapCoverView setFrame:CGRectMake(0, 0, 320, 265)];
//        [tableViewController.tableView setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 200,0, 0)];
//        [tableViewController passMessageId:Id];
        
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
                                                                 zoom:18];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [mapView animateToViewingAngle:45];
    mapView.settings.consumesGesturesInView = NO;
    self.view = mapView;
    
    
    //  add view to cover map
    mapCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];
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
    UITextView *postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 125, 225, 75)];

    
    // Default text view
    postTextView.text = [tempJsonObjects objectForKey:@"bodyField"];
    postTextView.textColor = [UIColor blackColor];
    postTextView.userInteractionEnabled = NO;
    postTextView.editable = NO;
    [self.view addSubview:postTextView];
    
    // username label
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 85, 100, 30)];
    [usernameLabel setText:[tempJsonObjects objectForKey:@"owner"]];
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:usernameLabel];
    
    // time label
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 85, 100, 30)];
    [timeLabel setText:[tempJsonObjects objectForKey:@"timestamp"]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:timeLabel];
    
    //  like label
    likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 187, 40, 40)];
    [likeLabel setText:[NSString stringWithFormat:@"%@", [tempJsonObjects objectForKey:@"likes"]]];
    likeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:likeLabel];
    
    //  dislike label
    dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 187, 40, 40)];
    [dislikeLabel setText:[NSString stringWithFormat:@"%@", [tempJsonObjects objectForKey:@"dislikes"]]];
    dislikeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dislikeLabel];
    
    // like button
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 207, 40, 40)];
    [likeButton setTitle:@"⋀" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:likeButton];
    
    // dislike button
    dislikeButton = [[UIButton alloc] initWithFrame:CGRectMake(277, 207, 40, 40)];
    [dislikeButton setTitle:@"⋁" forState:UIControlStateNormal];
    [dislikeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:dislikeButton];
    
    
    //  create the table view controller
    tableViewController = [[JCCReplyTableViewController alloc] init];
    [tableViewController passMessageId:Id];
    
    // The table view controller's view
    table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 200,0, 0)];
    
    tableView.delegate = self;
    
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
    
    // Make gray background
    outerReplyView = [[UITextView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width, 60)];
    outerReplyView.layer.backgroundColor=[[UIColor lightGrayColor]CGColor];
    [self.view addSubview:outerReplyView];
    
    // Make replyTextView
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height-55, 225, 50)];
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
    replyButton = [[UIButton alloc] initWithFrame:CGRectMake(255, [UIScreen mainScreen].bounds.size.height-55, 50, 50)];
    replyButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    replyButton.clipsToBounds = YES;
    [replyButton setTitle:@"REPLY!" forState:UIControlStateNormal];
    [replyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [replyButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [replyButton addTarget:self action:@selector(postReply:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replyButton];

    
    
    // add a compose reply button
//    UIBarButtonItem *replyComposeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(replyComposeButtonPressed:)];
//    [self.navigationItem setRightBarButtonItem:replyComposeButton animated:YES];
    
    
    //  add profile picture
    UIImageView *profilePricture = [[UIImageView alloc] initWithFrame:CGRectMake(7, 75, 40, 40)];
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