//
//  JCCProfPicViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCCProfPicViewController.h"

@protocol DismissProfPic;


@interface JCCProfPicViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<DismissProfPic> delegate;

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

@protocol DismissProfPic <NSObject>
@required
- (void)dismissProfPicViewController:(UIViewController *)viewController;
@end