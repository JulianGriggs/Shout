//
//  JCCProfPicViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCProfPicViewController.h"
#import "JCCUserCredentials.h"
#import "JCCMakeRequests.h"

@interface JCCProfPicViewController ()

@end

@implementation JCCProfPicViewController
{
    UIImage* newProfImage;
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



/***
 Take a photo for use as a profile picture.
 ***/
- (IBAction)takePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}



/***
 Select a photo from camera roll for use as a profile picture.
 ***/
- (IBAction)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}



/***
 Sends the image to the server after the user decides they want to use the picture that they either took or selected.
 ***/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    newProfImage = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    // Object for error handling
    NSError* error;
    
    [JCCMakeRequests sendImageToServer:newProfImage withPotentialError:&error];
    if(error)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [badView setMessage:error.localizedDescription];
        [self.navigationController pushViewController:badView animated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



/***
 User cancels the image picker.
 ***/
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



/***
 Displays an alert if the user doesn't have a camera.  Sets the image to the current profile image.
 ***/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
    [self.imageView setImage:self.profPicture];
    self.takePhotoButton.layer.cornerRadius = 8.0;
    self.selectPhotoButton.layer.cornerRadius = 8.0;
}



@end
