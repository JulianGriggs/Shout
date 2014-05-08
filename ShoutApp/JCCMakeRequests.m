//
//  JCCMakeRequests.m
//  ShoutApp
//
//  Created by Julian Griggs on 5/7/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCMakeRequests.h"
#import "JCCUserCredentials.h"

@implementation JCCMakeRequests


// Returns an NSDictionary with the user's profile information
-(NSDictionary *)getUserProfile
{
    //  get the the users information
    NSString *url = [NSString stringWithFormat:@"%@", @"http://aeneas.princeton.edu:8000/api/v1/users/getMyProfile/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", sharedUserToken];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"theReply: %@", theReply);
    
    // This parses the response from the server as a JSON object
    NSDictionary *userProfDict = [NSJSONSerialization JSONObjectWithData:
                                  GETReply options:kNilOptions error:nil];
    return userProfDict;
}




// Returns an NSData object with the user's profile image
-(NSData*)getProfileImage:(NSDictionary *) dictShout
{
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/static/shout/images/"];
    NSString *url1 = [url stringByAppendingString:[NSString stringWithFormat:@"%@", [dictShout objectForKey:@"profilePic"]]];
    
    [request setURL:[NSURL URLWithString:url1]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:jsonData];
    
    // check the response
    NSURLResponse *response;
    NSError *error = nil;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    return GETReply;
}





-(NSString *) postShout:(NSDictionary *) dictionaryData
{

    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];

    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    // authentication
    NSString *authStr = sharedUserToken;
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    [request setURL:[NSURL URLWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];

    // check the response
    NSURLResponse *response;
    NSError *error = nil;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    return theReply;
}



// Gets the max radius size
-(int) getMaxRadiusSize:(NSDictionary *) userDict
{
    NSNumber *maxRadius = [userDict objectForKey:@"maxRadius"];
    NSLog(@"MaxRadius: %@", maxRadius);
    return [maxRadius intValue];
}



// Returns the list of shouts
-(NSArray *) getShouts:(NSDictionary *) dictionaryData
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData options:0 error:nil];
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages?"];
    NSString *url1 = [url stringByAppendingString:@"latitude="];
    NSString *url2 = [url1 stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"latitude"]]];
    NSString *url3 = [url2 stringByAppendingString:@"&"];
    NSString *url4 = [url3 stringByAppendingString:@"longitude="];
    NSString *url5 = [url4 stringByAppendingString:[NSString stringWithFormat:@"%@", [dictionaryData objectForKey:@"longitude"]]];
    
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // authentication
    NSString *authStr = sharedUserToken;
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    [request setURL:[NSURL URLWithString:url5]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    
    // Creates myObject every time  this function is called
    NSMutableArray *myObject = [[NSMutableArray alloc] init];
    
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                   GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}




// Returns the list of shouts
-(NSArray *) getMyShouts
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/users/getMyShouts/"];
    
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // authentication
    NSString *authStr = sharedUserToken;
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    // This parses the response from the server as a JSON object
    NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                            GETReply options:kNilOptions error:nil];
    
    return jsonObjects;
}




// post the dislike
-(NSString *)postDislike:(NSString *) messageID
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
    NSString *url1 = [url stringByAppendingString:messageID];
    NSString *url2 = [url1 stringByAppendingString:@"/dislike"];


    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *authStr = sharedUserToken;

    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    [request setURL:[NSURL URLWithString:url2]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    return theReply;
}



// post the dislike
-(NSString *)postLike:(NSString *) messageID
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/messages/"];
    NSString *url1 = [url stringByAppendingString:messageID];
    NSString *url2 = [url1 stringByAppendingString:@"/like"];
    
    
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *authStr = sharedUserToken;
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:url2]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    return theReply;
}



// post the dislike
-(NSDictionary *)getShoutWithID:(NSString *) messageID
{
    // make the url with query variables
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://aeneas.princeton.edu:8000/api/v1/messages/", messageID];
    // send the get request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    // This parses the response from the server as a JSON object
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:GETReply options:kNilOptions error:nil];
    return messageDict;
}




- (NSString*)sendImageToServer:(UIImage *)newProfImage
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aeneas.princeton.edu:8000/api/v1/userProfiles/%@/", sharedUserID]]];
    
    
    NSString *authStr = sharedUserToken;
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSData *imageData = UIImageJPEGRepresentation(newProfImage, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
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
    
    
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //        if(data.length > 0)
    //        {
    //            //success
    //        }
    //    }];
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    return theReply;
    
}



// post the dislike
-(NSString *)postMute:(NSString *) username
{
    // make the url with query variables
    NSString *url = [[NSMutableString alloc] initWithString:@"http://aeneas.princeton.edu:8000/api/v1/users/mute?username="];
    NSString *url1 = [url stringByAppendingString:username];
    
    // send the post request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *authStr = sharedUserToken;
    
    NSString *authValue = [NSString stringWithFormat:@"Token %@", authStr];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [request setURL:[NSURL URLWithString:url1]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // check the response
    NSURLResponse *response;
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    return theReply;
}


@end
