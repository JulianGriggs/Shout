//
//  JCCEchoViewController.h
//  ShoutApp
//
//  Created by Cameron Porter on 4/10/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface JCCEchoViewController : UIViewController <UITextViewDelegate, NSURLConnectionDelegate, GMSMapViewDelegate, CLLocationManagerDelegate>


/***
 Format the text field and add it to the view.
 ***/
-(void)setTextField:(NSString *)text;

@end

