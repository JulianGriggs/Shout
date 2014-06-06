//
//  JCCMuteHandler.h
//  ShoutApp
//
//  Created by Julian Griggs on 5/19/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCCMuteHandler : NSObject

/***
 Displays the alert modal upon clicking the alert button.  If the user then confirms their decision to mute the author of the shout they selected, then a synchronous mute is sent to the server.  Otherwise, the modal disappears.  If a user tries to mute themselves, a modal pops up informing them that this is not a permitted action.
 ***/
+ (void)sendMute:(UIButton*)sender fromTableViewController:(UITableViewController*) tableViewController;
@end
