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
+(NSArray *) getShouts:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;



/***
 Returns the list of all shouts sent by the user.
 ***/
+(NSArray *) getMyShoutsWithPotentialError:(NSError*) error;



/***
 Returns the list of all shouts sent by a different user.
 ***/
+(NSArray *) getOtherUsersShouts:(NSString *) otherUsername withPotentialError:(NSError*) error;



/***
 Returns all replies to a given shout.
 ***/
+(NSArray *) getReplies:(NSString *) ID withPotentialError:(NSError*) error;



/***
 Returns an NSDictionary with the user's profile information.
 ***/
+(NSDictionary *)getUserProfileWithPotentialError:(NSError*) error;



/***
 Get the profile of another user.
 ***/
+(NSDictionary *)getOtherUserProfile:(NSString *)otherUsername withPotentialError:(NSError*) error;



/***
 Returns an NSData object with the user's profile image.
 ***/
+(NSData*)getProfileImage:(NSDictionary *) dictShout withPotentialError:(NSError*) error;



/***
 Synchronously posts a shout message.
 ***/
+(NSString *) postShout:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;



/***
 Synchronously posts a Reply.
 ***/
+(NSString *) postReply: (NSDictionary *) dictionaryData withID: (NSString *) ID withPotentialError:(NSError*) error;



/***
 Obtains the max radius from the provided dictionary of user information.
 ***/
+(int) getMaxRadiusSize:(NSDictionary *) userDict;



/***
 Get a particular shout using its ID.
 ***/
+(NSDictionary *)getShoutWithID:(NSString *) messageID withPotentialError:(NSError*) error;



/***
 Uploads a profile picture to the server.
 ***/
+ (NSString*)sendImageToServer:(UIImage *)newProfImage withPotentialError:(NSError*) error;



/***
 Synchronously post the mute.
 ***/
+(NSString *)postMute:(NSString *) username withPotentialError:(NSError*) error;



/***
 Synchronously attempts the registration.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) attemptRegistration:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;

/***
 Synchronously attempts editing profile information.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) editProfile:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;

/***
 Synchronously attempts to confirm a users password.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) confirmPassword:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;


/***
 Synchronously attempts the login.  Upon success the token is returned.  Upon failure, nil is returned.
 ***/
+(NSString *)attemptAuth:(NSDictionary *) dictionaryData withPotentialError:(NSError*) error;



/***
 Displays a modal informing the user about their own lack of internet connection.
 ***/
+(void) displayLackOfInternetAlert;



@end
