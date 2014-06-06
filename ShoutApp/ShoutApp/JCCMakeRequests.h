//
//  JCCMakeRequests.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCBadConnectionViewController.h"


@interface JCCMakeRequests : NSObject

/***
 Returns the list of all shouts.
 ***/
+(NSArray *) getShouts:(NSDictionary *) dictionaryData;



/***
 Returns the list of all shouts sent by the user.
 ***/
+(NSArray *) getMyShouts;



/***
 Returns the list of all shouts sent by a different user.
 ***/
+(NSArray *) getOtherUsersShouts:(NSString *) otherUsername;



/***
 Returns all replies to a given shout.
 ***/
+(NSArray *) getReplies:(NSString *) ID;



/***
 Returns an NSDictionary with the user's profile information.
 ***/
+(NSDictionary *)getUserProfile;



/***
 Get the profile of another user.
 ***/
+(NSDictionary *)getOtherUserProfile:(NSString *)otherUsername;



/***
 Returns an NSData object with the user's profile image.
 ***/
+(NSData*)getProfileImage:(NSDictionary *) dictShout;



/***
 Synchronously posts a shout message.
 ***/
+(NSString *) postShout:(NSDictionary *) dictionaryData;



/***
 Synchronously posts a Reply.
 ***/
+(NSString *) postReply: (NSDictionary *) dictionaryData withID: (NSString *) ID;



/***
 Obtains the max radius from the provided dictionary of user information.
 ***/
+(int) getMaxRadiusSize:(NSDictionary *) userDict;



/***
 Get a particular shout using its ID.
 ***/
+(NSDictionary *)getShoutWithID:(NSString *) messageID;



/***
 Uploads a profile picture to the server.
 ***/
+ (NSString*)sendImageToServer:(UIImage *)newProfImage;



/***
 Synchronously post the mute.
 ***/
+(NSString *)postMute:(NSString *) username;



/***
 Synchronously attempts the registration.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) attemptRegistration:(NSDictionary *) dictionaryData;



/***
 Synchronously attempts the login.  Upon success the token is returned.  Upon failure, nil is returned.
 ***/
+(NSString *)attemptAuth:(NSDictionary *) dictionaryData;




@end
