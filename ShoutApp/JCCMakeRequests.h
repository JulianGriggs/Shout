//
//  JCCMakeRequests.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCMakeRequests : NSObject

+(NSArray *) getShouts:(NSDictionary *) dictionaryData;

+(NSArray *) getMyShouts;

+(NSArray *) getReplies:(NSString *) ID;

+(NSDictionary *)getUserProfile;

+(NSData*)getProfileImage:(NSDictionary *) dictShout;

+(NSString *) postShout:(NSDictionary *) dictionaryData;

+(NSString *) postReply: (NSDictionary *) dictionaryData withID: (NSString *) ID;

+(int) getMaxRadiusSize:(NSDictionary *) userDict;

+(NSString *)postLike:(NSString *) messageID;

+(NSString *)postDislike:(NSString *) messageID;

+(NSDictionary *)getShoutWithID:(NSString *) messageID;

+ (NSString*)sendImageToServer:(UIImage *)newProfImage;

+(NSString *)postMute:(NSString *) username;

+(BOOL) attemptRegistration:(NSDictionary *) dictionaryData;

+(NSString *)attemptAuth:(NSDictionary *) dictionaryData;
@end
