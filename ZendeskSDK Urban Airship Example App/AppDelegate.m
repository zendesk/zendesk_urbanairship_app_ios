/*
 *
 *  AppDelegate.m
 *  ZendeskSDK Urban Airship Example App
 *
 *  Created by Zendesk on 5/26/15.
 *
 *  Copyright (c) 2015 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Terms
 *  of Service https://www.zendesk.com/company/terms and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/application-developer-and-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

#import <ZendeskSDK/ZendeskSDK.h>
#import "AppDelegate.h"

#import "ViewController.h"

static NSString * const appId = @"Your_app_id";
static NSString * const zendeskURL = @"Your_zendesk_url";
static NSString * const clientId = @"Your_client_id";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Create an identity
    ZDKAnonymousIdentity *identity = [ZDKAnonymousIdentity new];
    
    identity.email = @"urbanairshiptest@example.com";
    
    [ZDKConfig instance].userIdentity = identity;
    
    //Initalize the Zendesk SDK
    [[ZDKConfig instance] initializeWithAppId:appId zendeskUrl:zendeskURL andClientId:clientId];
    
 
    [ZDKLogger enable:YES];
    
    //Register with Urban Airship
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    [UAirship push].userNotificationTypes = (UIUserNotificationTypeAlert |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound);
    
    // User notifications will not be enabled until userPushNotificationsEnabled is
    // set YES on UAPush. Once enabled, the setting will be persisted and the user
    // will be prompted to allow notifications. Normally, you should wait for a more appropriate
    // time to enable push to increase the likelihood that the user will accept
    // notifications.
    [UAirship push].userPushNotificationsEnabled = YES;
   
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[UAirship push] appRegisteredForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSString *deviceTokenString = [[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"Device registered for remote notifications with identifier: %@", deviceTokenString );
    
    
    //The deviceToken is later used to register for push notifications in Zendesk
    //[[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:APPLE_PUSH_UUID];
    [[NSUserDefaults standardUserDefaults] setObject:[UAirship push].channelID forKey:APPLE_PUSH_UUID];

}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    

    NSMutableDictionary *pushUtilUserInfo = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
    [pushUtilUserInfo setObject:userInfo[@"tid"] forKey:@"zendesk_sdk_request_id"];
    
    
    
    [ZDKPushUtil handlePush:[[NSDictionary alloc] initWithDictionary:pushUtilUserInfo]
             forApplication:application
          presentationStyle:UIModalPresentationFormSheet
                layoutGuide:ZDKLayoutRespectTop
                  withAppId:appId
                 zendeskUrl:zendeskURL
                   clientId:clientId
     fetchCompletionHandler:completionHandler];
 
    
}

@end
