//
//  JCCErrorHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 6/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCErrorHandler : NSObject
+(void) displayErrorView:(UIViewController*) parent withError:(NSError*) error;

@end
