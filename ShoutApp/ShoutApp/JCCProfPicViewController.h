//
//  JCCProfPicViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCProfPicViewController.h"
#import "JCCDismissViewController.h"


@interface JCCProfPicViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, JCCDismissViewController>

@property (nonatomic, weak) id<JCCDismissViewController> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/***
 Take a photo for use as a profile picture.
 ***/
- (IBAction)takePhoto:  (UIButton *)sender;


/***
 Select a photo from camera roll for use as a profile picture.
 ***/
- (IBAction)selectPhoto:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (strong, nonatomic) UIImage *profPicture;

@end
