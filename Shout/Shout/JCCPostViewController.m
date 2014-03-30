//
//  JCCPostViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCPostViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JCCPostViewController ()


@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@property (weak, nonatomic) IBOutlet UITextField *toTextField;

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

@property (weak, nonatomic) IBOutlet UIButton *shoutButton;

@end

@implementation JCCPostViewController




- (IBAction)postShout:(id)sender
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    if (([self.postTextView.text isEqualToString:@"Let's hear it!"] && [self.postTextView.textColor isEqual:[UIColor lightGrayColor]]) || ([[self.postTextView.text stringByTrimmingCharactersInSet: set] length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"You have to say something!" delegate:self cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //  format the data
        NSDictionary *dictionaryData = @{@"bodyField": self.postTextView.text, @"latitude": @"0", @"longitude": @"0"};
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];


        // send the post request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // check the response
        NSURLResponse *response;
        NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    }
}





-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.toTextField])
    {
        [self.toTextField resignFirstResponder];
        [self.fromTextField becomeFirstResponder];
    }
    
    if ([textField isEqual:self.fromTextField])
    {
        [self.fromTextField resignFirstResponder];
        [self.postTextView becomeFirstResponder];
    }
    
    return NO;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return textField.text.length + (string.length - range.length) <= 30;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"Let's hear it!"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

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


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Let's hear it!";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

- (void)viewDidLoad
{
    self.toTextField.delegate = self;
    self.fromTextField.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.postTextView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.postTextView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.postTextView.layer setBorderWidth: 1.0];
    [self.postTextView.layer setCornerRadius:8.0f];
    [self.postTextView.layer setMasksToBounds:YES];
    
    self.postTextView.delegate = self;
    self.postTextView.text = @"Let's hear it!";
    self.postTextView.textColor = [UIColor lightGrayColor];
    
    self.shoutButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.shoutButton.clipsToBounds = YES;
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
