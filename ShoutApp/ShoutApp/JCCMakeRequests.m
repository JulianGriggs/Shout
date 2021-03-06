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


/***
 Creates and sends a generic synchronous request using the provided URL, HTTPMethod, and Data.  If the custom request parameter is not nil then it will use the custom request parameter.
 ***/
+(NSData*)sendGenericRequestWithURL:(NSString *)url withType:(NSString*)HTTPMethod withData:(NSData*) jsonData withCustomRequest:(NSMutableURLRequest *) customRequest withPotentialError:(NSError**)p_error
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
    NSData *reply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:p_error];
    return reply;
}



/***
 Returns an NSDictionary with the user's profile information.
 ***/
+(NSDictionary *)getUserProfileWithPotentialError:(NSError**) p_error
{
    NSString *url = [NSString stringWithFormat:@"%@", @"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/getMyProfile/"];
    
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || GETReply == nil)
        return nil;
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getUserProfile, var: theReply = %@", theReply);
    //#endif
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    return userProfDict;
}



/***
 Get the profile of another user.
 ***/
+(NSDictionary *)getOtherUserProfile:(NSString *)otherUsername withPotentialError:(NSError**) p_error
{
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/getOtherProfile?username=", otherUsername];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || GETReply == nil)
        return nil;
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getUserProfile, var: theReply = %@", theReply);
    //#endif
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    return userProfDict;
}



/***
 Returns an NSData object with the user's profile image.
 ***/
+(NSData*)getProfileImage:(NSDictionary *) dictShout withPotentialError:(NSError**) p_error
{
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/static/shout/images/"];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || GETReply == nil)
        return nil;
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getProfileImage, var: theReply = %@", theReply);
    //#endif
    return GETReply;
}



/***
 Synchronously posts a Reply.
 ***/
+(NSString *) postReply: (NSDictionary *) dictionaryData withID: (NSString *) ID withPotentialError:(NSError**) p_error
{
    // Encode dictionary data in json
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    //  build the appropriate URL
    NSString *url = [NSString stringWithFormat:@"%@",@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/replies"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: postReply, var: theReply = %@", theReply);
    //#endif
    
    return theReply;
}



/***
 Synchronously posts a shout message.
 ***/
+(NSString *) postShout:(NSDictionary *) dictionaryData withPotentialError:(NSError**) p_error
{
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@", @"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || POSTReply == nil)
        return nil;
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: postShout, var: theReply = %@", theReply);
    //#endif
    return theReply;
}



/***
 Returns all replies to a given shout.
 ***/
+(NSArray *) getReplies:(NSString *) ID withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/replies?"];
    url = [url stringByAppendingString:@"message_id="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", ID]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //  return nil if the internet connection is poor
    if (*p_error || GETReply == nil)
        return nil;
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //
    //#ifdef DEBUG
    //    NSLog(@"function: getReplies, var: theReply = %@", theReply);
    //#endif
    //
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}



/***
 Returns the list of all shouts.
 ***/
+(NSArray *) getShouts:(NSDictionary *) dictionaryData withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages?"];
    url = [url stringByAppendingString:@"latitude="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"latitude"]]];
    url = [url stringByAppendingString:@"&"];
    url = [url stringByAppendingString:@"longitude="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"longitude"]]];
    url = [url stringByAppendingString:@"&"];
    url = [url stringByAppendingString:@"friendsOnly="];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"friendsOnly"]]];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getShouts, var: theReply = %@", theReply);
    //#endif
    
    NSArray *jsonObjects;
    if (GETReply)
    {
        // This parses the response from the server as a JSON object
        jsonObjects = [NSJSONSerialization JSONObjectWithData:
                       GETReply options:kNilOptions error:nil];
    }
    return jsonObjects;
}



/***
 Returns the list of all shouts sent by the user.
 ***/
+(NSArray *) getMyShoutsWithPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/getMyShouts/"];
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getMyShouts, var: theReply = %@", theReply);
    //#endif
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}



/***
 Returns the list of all shouts sent by a different user.
 ***/
+(NSArray *) getOtherUsersShouts:(NSString *) otherUsername withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@%@", @"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/getOtherShouts?username=", otherUsername]];
    
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getMyShouts, var: theReply = %@", theReply);
    //#endif
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}



/***
 Get a particular shout using its ID.
 ***/
+(NSDictionary *)getShoutWithID:(NSString *)messageID withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [NSString stringWithFormat:@"%@%@/", @"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/messages/", messageID];
    
    
    // send the GET request
    NSData *GETReply = [self sendGenericRequestWithURL:url withType:@"GET" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: getShoutsWithID, var: theReply = %@", theReply);
    //#endif
    // This parses the response from the server as a JSON object
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
    return messageDict;
}



/***
 Create and return the request for uploading a photo.
 ***/
+(NSMutableURLRequest*) buildUploadPhotoRequest:(UIImage *)newProfImage
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/userProfiles/%@/", sharedUserID]]];
    
    
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
    NSString *postLength = [NSString stringWithFormat:@"%d", (int) [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    return request;
}



/***
 Uploads a profile picture to the server.
 ***/
+(NSString*)sendImageToServer:(UIImage *)newProfImage  withPotentialError:(NSError**) p_error
{
    NSMutableURLRequest *request = [self buildUploadPhotoRequest:newProfImage];
    
    
    // send the PUT request
    NSData *PUTReply = [self sendGenericRequestWithURL:nil withType:@"PUT" withData:nil withCustomRequest:request withPotentialError:p_error];
    
    
    NSString *theReply = [[NSString alloc] initWithBytes:[PUTReply bytes] length:[PUTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: sendImageToServer, var: theReply = %@", theReply);
    //#endif
    return theReply;
    
}



/***
 Synchronously post the mute.
 ***/
+(NSString *)postMute:(NSString *) username withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/mute?username="];
    url = [url stringByAppendingString:username];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:nil withCustomRequest:nil withPotentialError:p_error];
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: postMute, var: theReply = %@", theReply);
    //#endif
    return theReply;
}



/***
 Synchronously attempts the registration.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) attemptRegistration:(NSDictionary *) dictionaryData  withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/register/"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: attemptRegistration, var: theReply = %@", theReply);
    //#endif
    if ([theReply isEqualToString:@"error"])
        return NO;  // Failure (Username probably already exists)
    
    else
        return YES; // Success
}

/***
 Synchronously attempts to confirm a users password.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) confirmPassword:(NSDictionary *) dictionaryData  withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/confirmPassword/"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: attemptRegistration, var: theReply = %@", theReply);
    //#endif
    if ([theReply isEqualToString:@"wrong password"])
        return NO;  // Failure
    
    else
        return YES; // Success
    
}

/***
 Synchronously attempts editing profile information.  Upon success YES is returned.  Upon failure, NO is returned.
 ***/
+(BOOL) editProfile:(NSDictionary *) dictionaryData  withPotentialError:(NSError**) p_error
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/editProfile/"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: attemptRegistration, var: theReply = %@", theReply);
    //#endif
    if ([theReply isEqualToString:@"that username is already taken"])
        return NO;  // Failure (Username probably already exists)
    
    else
        return YES; // Success
}



/***
 Synchronously attempts the login.  Upon success the token is returned.  Upon failure, nil is returned.
 ***/
+(NSString *)attemptAuth: (NSDictionary *) dictionaryData withPotentialError:(NSError**) p_error
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/api-token-auth/"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //
    //#ifdef DEBUG
    //    NSLog(@"function: attemptAuth, var: theReply = %@", theReply);
    //#endif
    
    if (*p_error)
    {
        return nil;
    }
    
    else
    {
        // This parses the response from the server as a JSON object
        NSDictionary *loginToken = [NSJSONSerialization JSONObjectWithData: POSTReply options:kNilOptions error:nil];
        
        // This can also be nil if an error occurs where the json doesn't have a token key
        NSString *token = [loginToken objectForKey:@"token"];
        
        return token;
    }
}

/***
  Attempts to reset password.  Returns boolean indicating success
 ***/
+(BOOL)attemptResetPassword:(NSDictionary *) dictionaryData withPotentialError:(NSError**) p_error
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://ec2-54-200-82-59.us-west-2.compute.amazonaws.com:8080/api/v1/users/forgotPassword"];
    
    // send the POST request
    NSData *POSTReply = [self sendGenericRequestWithURL:url withType:@"POST" withData:jsonData withCustomRequest:nil withPotentialError:p_error];
    
    
    //    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //
    //#ifdef DEBUG
    //    NSLog(@"function: attemptAuth, var: theReply = %@", theReply);
    //#endif
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //#ifdef DEBUG
    //    NSLog(@"function: attemptRegistration, var: theReply = %@", theReply);
    //#endif
    if ([theReply isEqualToString:@"OK"])
        return YES;  // success
    
    else
        return NO; // failure

    
}

/***
 Obtains the max radius from the provided dictionary of user information.
 ***/
+(int) getMaxRadiusSize:(NSDictionary *) userDict
{
    NSNumber *maxRadius = [userDict objectForKey:@"maxRadius"];
    return [maxRadius intValue];
}



/***
 Displays a modal informing the user about their own lack of internet connection.
 ***/
+(void) displayLackOfInternetAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Poor Connection" message:@"It's possible that your internet connection is poor.  In order for this app to run properly you need a better connection." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

@end
