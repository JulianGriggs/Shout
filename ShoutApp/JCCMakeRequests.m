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


@end
