//
//  JCCMakeRequests.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCMakeRequests.h"
#import "JCCUserCredentials.h"
#import "AFNetworking.h"

@implementation JCCMakeRequests

+(NSData*)sendGenericRequestWithURL:(NSString *)url withType:(NSString*)HTTPMethod withData:(NSData*) jsonData withCustomRequest:(NSMutableURLRequest *) customRequest
{
    NSMutableURLRequest *request;
    if (customRequest == nil)
    {
        request = [[NSMutableURLRequest alloc] init];
        
        //  10 second timeout interval
        request.timeoutInterval = 10;
        
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:HTTPMethod];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    }
    else
    {
        request = customRequest;
    }
    
    // check the response
    NSURLResponse *response;
    NSError *error;
    NSData *reply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //  return nil if the internet connection is poor
    if (error.code == -1009)
        return nil;
    return reply;
    
}




// Experimenting with AFNetworking
+(NSData*)sendAsynchronousRequestWithURL:(NSString *)url withType:(NSString*)HTTPMethod withData:(NSData*) jsonData withCustomRequest:(NSMutableURLRequest *) customRequest
{
    __block NSData *reply = nil;
    
    if ([HTTPMethod isEqualToString:@"GET"])
    {
    
        NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameters = @{@"foo": @"bar"};
        [manager GET:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"JSON: %@", responseObject);
                reply = (NSData*)responseObject;
            }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    
    }
    
    else if ([HTTPMethod isEqualToString:@"POST"])
    {
        
        NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:
                                                                 jsonData options:kNilOptions error:nil];
        [manager POST:url parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             reply = (NSData*)responseObject;
         }
             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
    }
    
    NSLog(@"cunt %@", reply);
    return reply;
}




// Returns an NSDictionary with the user's profile information
+(NSDictionary *)getUserProfile
{
    NSString *url = [NSString stringWithFormat:@"%@", @"http://shout.princeton.edu:8000/api/v1/users/getMyProfile/"];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getUserProfile, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    return userProfDict;
    
}





// Get the profile of another user
+(NSDictionary *)getOtherUserProfile:(NSString *)otherUsername
{
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://shout.princeton.edu:8000/api/v1/users/getOtherProfile?username=", otherUsername];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getUserProfile, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    return userProfDict;
}





// Returns an NSData object with the user's profile image
+(NSData*)getProfileImage:(NSDictionary *) dictShout
{
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/static/shout/images/"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getProfileImage, var: theReply = %@", theReply);
#endif
    
    return GETReply;
}




// Post a Reply
+(NSString *) postReply: (NSDictionary *) dictionaryData withID: (NSString *) ID
{
    // Encode dictionary data in json
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    //  build the appropriate URL
    NSString *url = [NSString stringWithFormat:@"%@",@"http://shout.princeton.edu:8000/api/v1/replies"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: postReply, var: theReply = %@", theReply);
#endif
    
    return theReply;
    
}





// Post a shout message
+(NSString *) postShout:(NSDictionary *) dictionaryData
{
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@", @"http://shout.princeton.edu:8000/api/v1/messages"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: postShout, var: theReply = %@", theReply);
#endif
    return theReply;
}





// Returns the list of replies
+(NSArray *) getReplies:(NSString *) ID
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/replies?"];
    url = [url stringByAppendingString:@"message_id="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", ID]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
#ifdef DEBUG
    NSLog(@"function: getReplies, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}





// Returns the list of shouts
+(NSArray *) getShouts:(NSDictionary *) dictionaryData
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/messages?"];
    url = [url stringByAppendingString:@"latitude="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"latitude"]]];
    url = [url stringByAppendingString:@"&"];
    url = [url stringByAppendingString:@"longitude="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"longitude"]]];
    
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];

    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getShouts, var: theReply = %@", theReply);
#endif
    
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}





// Returns the list of shouts
+(NSArray *) getMyShouts
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/users/getMyShouts/"];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getMyShouts, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}





//  Returns a list of a given users shouts
+(NSArray *) getOtherUsersShouts:(NSString *) otherUsername
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@", @"http://shout.princeton.edu:8000/api/v1/users/getOtherShouts?username=", otherUsername]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: getMyShouts, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}





// post the dislike
+(NSString *)postDislike:(NSString *) messageID
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/messages/"];
    url = [url stringByAppendingString:messageID];
    url = [url stringByAppendingString:@"/dislike"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: postDislike, var: theReply = %@", theReply);
#endif
    return theReply;
}





// post the like
+(NSString *)postLike:(NSString *) messageID
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/messages/"];
    url = [url stringByAppendingString:messageID];
    url = [url stringByAppendingString:@"/like"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: postLike, var: theReply = %@", theReply);
#endif
    return theReply;
}





// Get a particular shout ising its ID
+(NSDictionary *)getShoutWithID:(NSString *)messageID
{
    // make the url with query variables
    NSString *url = [NSString stringWithFormat:@"%@%@/", @"http://shout.princeton.edu:8000/api/v1/messages/", messageID];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (GETReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
#ifdef DEBUG
    NSLog(@"function: getShoutsWithID, var: theReply = %@", theReply);
#endif
    // This parses the response from the server as a JSON object
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
    return messageDict;
}



// Create the request for uploading a photo
+(NSMutableURLRequest*) buildUploadPhotoRequest:(UIImage *)newProfImage
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shout.princeton.edu:8000/api/v1/userProfiles/%@/", sharedUserID]]];
    
    
    //  10 second timeout interval
    request.timeoutInterval = 10;
    
    NSString *authStr = sharedUserToken;
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSData *imageData = UIImageJPEGRepresentation(newProfImage, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPMethod:@"PUT"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@.jpg\r\n", @"profilePic", sharedUserName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    return request;
}




// uploads a profile picture to the server
+(NSString*)sendImageToServer:(UIImage *)newProfImage
{
    NSMutableURLRequest *request = [self buildUploadPhotoRequest:newProfImage];
    
    // send the PUT request
    NSData *PUTReply = [self sendGenericRequestWithURL:nil withType:@"PUT" withData:nil withCustomRequest:request];
    
    //  return nil if the internet connection is poor
    if (PUTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[PUTReply bytes] length:[PUTReply length] encoding: NSASCIIStringEncoding];
    
#ifdef DEBUG
    NSLog(@"function: sendImageToServer, var: theReply = %@", theReply);
#endif
    return theReply;
    
}





// post the dislike
+(NSString *)postMute:(NSString *) username
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/users/mute?username="];
    url = [url stringByAppendingString:username];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:nil withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    
#ifdef DEBUG
    NSLog(@"function: postMute, var: theReply = %@", theReply);
#endif
    return theReply;
}





// Attempts the the registration.  Upon success YES is returned.  Upon failure, NO is returned.
+(BOOL) attemptRegistration:(NSDictionary *) dictionaryData
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/users/register/"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil];
    
    //  return nil if the internet connection is poor
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
#ifdef DEBUG
    NSLog(@"function: attemptRegistration, var: theReply = %@", theReply);
#endif
    
    if ([theReply isEqualToString:@"error"])
        return NO;  // Failure (Username probably already exists)
    
    else
        return YES; // Success
}





// Attempts the login.  Upon success the token is returned.  Upon failure, nil is returned.
+(NSString *)attemptAuth: (NSDictionary *) dictionaryData
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://shout.princeton.edu:8000/api/v1/api-token-auth/"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil];
    
    //  return nil if the internet connection is poor or didn't give a valid username/password
    if (POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    
#ifdef DEBUG
    NSLog(@"function: attemptAuth, var: theReply = %@", theReply);
#endif
    
    // This parses the response from the server as a JSON object
    NSDictionary *loginToken = [NSJSONSerialization JSONObjectWithData: POSTReply options:kNilOptions error:nil];
    
    // This can also be nil if an error occurs where the json doesn't have a token key
    NSString *token = [loginToken objectForKey:@"token"];
    
    return token;
}





// Gets the max radius size
+(int) getMaxRadiusSize:(NSDictionary *) userDict
{
    NSNumber *maxRadius = [userDict objectForKey:@"maxRadius"];
    NSLog(@"MaxRadius: %@", maxRadius);
    return [maxRadius intValue];
}




+(void) displayLackOfInternetAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Poor Connection" message:@"It's possible that your internet connection is poor.  In order for this app to run properly you need a better connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
