//
//  JCCAnnotation.m
//  Shout
//
//  Created by Cameron Porter on 3/29/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCAnnotation.h"

@implementation JCCAnnotation

- initWithPosition:(CLLocationCoordinate2D)coords
{
    if (self = [super init])
    {
        self.coordinate = coords;
    }
    return self;
}


@end
