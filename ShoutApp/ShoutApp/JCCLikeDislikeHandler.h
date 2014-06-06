//
//  JCCLikeDislikeHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCCTableViewCell1.h"

@interface JCCLikeDislikeHandler : NSObject
/***
 Sends the like.  This updates the UI to show that user has liked the message.  In addition it asynchronously sends a "like" to the server.
 ***/
+ (void)sendUp:(UIButton*)sender fromTableViewController: (UITableViewController *)tableViewController;



/***
 Sends the dislike.  This updates the UI to show that user has disliked the message.  In addition it asynchronously sends a "dislike" to the server.
 ***/
+ (void)sendDown:(UIButton*)sender fromTableViewController:(UITableViewController *) tableViewController;



/***
 Sets default to clear background and black text for like/dislike labels.
 ***/
+(void)setDefaultLikeDislike:(JCCTableViewCell1*)cell;



/***
 Sets the like label to marked.
 ***/
+(void)setLikeAsMarked:(JCCTableViewCell1*)cell;



/***
 Sets the dislike label to marked.
 ***/
+(void)setDislikeAsMarked:(JCCTableViewCell1*)cell;



/***
 Sets the like label to unmarked.
 ***/
+(void)setLikeAsUnmarked:(JCCTableViewCell1*)cell;



/***
 Sets the dislike label to unmarked.
 ***/
+(void)setDislikeAsUnmarked:(JCCTableViewCell1*)cell;

@end
