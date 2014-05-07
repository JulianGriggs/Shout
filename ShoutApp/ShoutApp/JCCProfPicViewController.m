//
//  JCCProfPicViewController.m
//  ShoutApp
//
//  Created by Cameron Porter on 5/6/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//


#import "JCCProfPicViewController.h"
#import "JCCUserCredentials.h"

@interface JCCProfPicViewController ()

@end

@implementation JCCProfPicViewController
{
    UIImage* newProfImage;
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
        
        
        
        //  set the background image to the current profile picture 
        [self.imageView setImage:self.profPicture];
        
    }
    
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
//    [self sendImageToServer:@"test"];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//- (void)sendImageToServer:(NSString *) filename{
//    
//    // Change 3 to userID
//    NSURL *url = [NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/userProfiles/1/"];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    
//    NSData* paramData = UIImagePNGRepresentation(newProfImage);
//    
//    // create request
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:30];
//    [request setHTTPMethod:@"POST"];
//    
//    // set Content-Type in HTTP header
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    // post body
//    NSMutableData *body = [NSMutableData data];
//    
//    // add params (all params are strings)
//    for (NSString *param in _params) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    // add image data
//    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
//    if (imageData) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:imageData];
//        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // setting the body of the post to the reqeust
//    [request setHTTPBody:body];
//    
//    // set URL
//    [request setURL:requestURL];
//    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
//    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
//    
//    
//    // check the response
//    NSURLResponse *response;
//    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
//    NSLog(@"GETReply: %@", GETReply);
//    NSLog(@"theReply: %@", theReply);
//
//}

@end
