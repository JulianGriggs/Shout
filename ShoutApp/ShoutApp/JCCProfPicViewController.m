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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}



- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    newProfImage = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [JCCMakeRequests sendImageToServer:newProfImage];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    //  set the background image to the current profile picture
    NSDictionary *userProfile = [JCCMakeRequests getUserProfile];
    if (userProfile == nil)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        return;
    }
    NSData *profileImage = [JCCMakeRequests getProfileImage:userProfile];
    
    if (profileImage)
    {
        JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
        [self.navigationController pushViewController:badView animated:NO];
        return;
    }
    UIImage *actualPhoto = [[UIImage alloc] initWithData:profileImage];
    [self.imageView setImage:actualPhoto];
    self.takePhotoButton.layer.cornerRadius = 8.0;
    self.selectPhotoButton.layer.cornerRadius = 8.0;
}



@end
