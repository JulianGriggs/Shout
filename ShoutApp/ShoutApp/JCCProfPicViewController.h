//
//  JCCProfPicViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCProfPicViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end