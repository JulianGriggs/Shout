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
    UIView *composeView;
    UITextView *replyTextView;
    UIButton *replyButton;
}

//  set the message id
-(void)passMessageId:(NSString *)messageId
{
    Id = messageId;
    
    //  create the table view controller
    tableViewController = [[JCCReplyTableViewController alloc] init];
    [tableViewController passMessageId:Id];
    
    // The table view controller's view
    UITableView *table = tableViewController.tableView;
    [table setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [table setFrame:CGRectMake(0,-1 *(self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) + 200,0, 0)];
    
    // Adds the table view controller as a child view controller
    [self addChildViewController:tableViewController];
    // Adds the View of the table view controller as a subview
    [self.view addSubview:table];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



//  reply pressed button handler
-(IBAction)replyComposeButtonPressed:(id)sender
{
    //  text view color and shape
    composeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 265)];
    composeView.layer.masksToBounds = YES;
    composeView.backgroundColor = [UIColor whiteColor];
    composeView.alpha = 0.5;
    [self.view addSubview:composeView];
    
    // add the cancel button 
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
    
    //  add the reply field
    //  text view color and shape
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 125, 225, 75)];
    replyTextView.layer.cornerRadius = 8.0;
    replyTextView.layer.masksToBounds = YES;
    
    // Default text view
    replyTextView.text = @"Reply here!";
    replyTextView.textColor = [UIColor lightGrayColor];
    replyTextView.userInteractionEnabled = YES;
    replyTextView.editable = YES;
    replyTextView.delegate = self;
    [self.view addSubview:replyTextView];
    
    
    //  add reply button
    replyButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 210, 175, 50)];
    replyButton.layer.cornerRadius = 8.0; // this value vary as per your desire
    replyButton.clipsToBounds = YES;
    [replyButton setTitle:@"REPLY!" forState:UIControlStateNormal];
    [replyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    replyButton.backgroundColor = [UIColor whiteColor];
    [replyButton addTarget:self action:@selector(postReply:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replyButton];
    
}

//  handle posting a reply
-(IBAction)postReply:(id)sender
{
    // post the reply
    
    //  refresh the table of replies after posting
    [tableViewController refresh];
    
    // clear the screen
    //  delete the compose view
    [composeView removeFromSuperview];
    [replyTextView removeFromSuperview];
    [replyButton removeFromSuperview];
    
    //  add the reply compose button
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(replyComposeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:replyButton animated:YES];
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

// handle lets hear it text
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Reply here!";
        textView.textColor = [UIColor lightGrayColor];
    }
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
    
    
    //  text view color and shape
    UITextView *postTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, 125, 225, 75)];
    postTextView.layer.cornerRadius = 8.0;
    postTextView.layer.masksToBounds = YES;
    
    // Default text view
    postTextView.text = [tempJsonObjects objectForKey:@"bodyField"];
    postTextView.textColor = [UIColor blackColor];
    postTextView.userInteractionEnabled = NO;
    postTextView.editable = NO;
    [self.view addSubview:postTextView];
    

    // add a compose reply button
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(replyComposeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:replyButton animated:YES];
    
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