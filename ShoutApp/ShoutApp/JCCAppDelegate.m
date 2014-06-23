//
//  JCCAppDelegate.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCAppDelegate.h"
#import "JCCFeedTableViewController.h"
#import "JCCViewController.h"
#import "JCCUserViewController.h"
#import "JCCLoginViewController.h"
#import "AFNetworking.h"
#import "JCCBadConnectionViewController.h"
#import "KeychainItemWrapper.h"
#import "JCCMakeRequests.h"
#import "JCCUserCredentials.h"

@implementation JCCAppDelegate
CGFloat outerWindowHeight;
CGFloat outerWindowWidth;
CGFloat tabBarHeight = 48;
int maxCharacters = 111;

// Note that the viewController for the table and the user page are now created in the login controller after a successful login
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyCAU6EIF1XjTI26yiqRMJvycaVfOYcHf74"];
    
    // Creates the window object
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    // Set the height and window size
    outerWindowHeight = self.window.frame.size.height;  // 568 on 4 inch screen ----- 480 on 3.5 inch
    outerWindowWidth = self.window.frame.size.width; // 320 on 4 inch screen ----- 320 on 3.5 inch
    
    
    
   // NOTE: Our default is to go to the login page.  This is why we set it as the root view controller at first.
    JCCLoginViewController *loginViewController = [[JCCLoginViewController alloc]init];
    UINavigationController* loginRegisterController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginRegisterController.navigationBar.topItem.title = @"SHOUT!";
    self.window.rootViewController = loginRegisterController;

    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShoutLogin" accessGroup:nil];
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    if (![username isEqualToString:@""])
        
    {
        NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
        
        NSError *error;
        NSDictionary *dictionaryData = @{@"username": username, @"password": password};

        NSString *token = [JCCMakeRequests attemptAuth:dictionaryData withPotentialError:&error];
        if(!error || token != nil)
        {
            // Sets the username and token for this session of the app
            sharedUserName = username;
            sharedUserToken = token;
            
            // Restores the default values
            username = @"";
            password = @"";
            
            JCCViewController *viewController = [[JCCViewController alloc] init];
            UIImage* feedIconImage = [UIImage imageNamed:@"FeedIcon.png"];
            UITabBarItem* feedItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:feedIconImage tag:1];
            viewController.tabBarItem = feedItem;
            
            JCCUserViewController *userViewController = [[JCCUserViewController alloc] init];
            UIImage* userIconImage = [UIImage imageNamed:@"UserIcon.png"];
            UITabBarItem* userItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:userIconImage tag:0];
            userViewController.tabBarItem = userItem;
            
            // Creates the root naviagtion controller
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            // NOTE: If you can login with the keychain then we want to immediately go to the tab bar root view controller.
            UITabBarController *tabBarController = [[UITabBarController alloc] init];
            NSArray* controllers = [NSArray arrayWithObjects:navigationController, userViewController, nil];
            navigationController.navigationBar.topItem.title = @"SHOUT!";
            [tabBarController setViewControllers:controllers];
            self.window.rootViewController = tabBarController;
        }        
    }

    [self.window makeKeyAndVisible];
    /**************************************************************************************************/
    // This registers every time that we lose internet connection.  It then pushes on our lack of internet view.
    
    //    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    //        // Double check with logging
    //        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
    //            [navigationController popViewControllerAnimated:NO];
    //        } else {
    //            JCCBadConnectionViewController *badView = [[JCCBadConnectionViewController alloc] init];
    //            [navigationController pushViewController:badView animated:NO];
    //        }
    //    }];
    /**************************************************************************************************/
    
    return YES;
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}





- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}





- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}





- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}





- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end