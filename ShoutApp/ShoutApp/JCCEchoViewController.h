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

-(void)setTextField:(NSString *)text;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *token;

@end

