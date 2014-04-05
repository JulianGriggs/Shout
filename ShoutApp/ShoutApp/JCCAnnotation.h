//
//  JCCAnnotation.h
//  Shout
//
//  Created by Cameron Porter on 3/29/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JCCAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
