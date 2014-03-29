//
//  JCCPostViewController.m
//  Shout
//
//  Created by Cameron Porter on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCPostViewController.h"

@interface JCCPostViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dissapearButton;

@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;

@end

@implementation JCCPostViewController

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Let's hear it!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
