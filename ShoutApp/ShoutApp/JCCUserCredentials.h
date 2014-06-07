//
//  JCCUserCredentials.h
//  ShoutApp
//
//  Created by Julian Griggs on 4/21/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCUserCredentials : NSObject

/***
 Global variable that stores the token of the logged in user.
 ***/
extern NSString* sharedUserToken;



/***
 Global variable that stores the userName of the logged in user.
 ***/
extern NSString* sharedUserName;



/***
 Global variable that stores the userID of the logged in user.
 ***/
extern NSString* sharedUserID;

@end
