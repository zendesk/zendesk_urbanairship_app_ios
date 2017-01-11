/*
 *
 *  ViewController.m
 *  ZendeskSDK Urban Airship Example App
 *
 *  Created by Zendesk on 5/26/15.
 *
 *  Copyright (c) 2015 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

#import "AppDelegate.h"
#import "ViewController.h"
#import <ZendeskSDK/ZendeskSDK.h>


@interface ViewController ()

@end

@implementation ViewController

static BOOL isZendeskSDKInitialised = NO;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( ! isZendeskSDKInitialised) {
        
        
        [[ZDKConfig instance] initializeWithAppId:appId
                                       zendeskUrl:zendeskURL
                                         ClientId:clientId
                                        onSuccess:^{
                                            isZendeskSDKInitialised = YES;
                                        }
                                          onError:^(NSError *error) {
                                              
                                          }];
    }
    
}

- (void) showInitializationAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Wait a second..." message:@"I just need to herd some cats" delegate:self cancelButtonTitle:@"OK, I'll try again in a moment" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)showHelpCenter:(id)sender {
    if ( ! isZendeskSDKInitialised ) {
        [self showInitializationAlert];
        return;
    }
    
    [ZDKHelpCenter showHelpCenterWithNavController:self.navigationController];
}


- (IBAction)showTicketList:(id)sender {
    if ( ! isZendeskSDKInitialised ) {
        [self showInitializationAlert];
        return;
    }
    
    [ZDKRequests showRequestListWithNavController:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerForPush:(id)sender {
   
    if ( ! isZendeskSDKInitialised ) {
        [self showInitializationAlert];
        return;
    }
    
    NSString *identifier = [self getDeviceId];
    if ( ! identifier) {
        NSLog(@"No identifier found");
        return;
    }
    
    [[ZDKConfig instance] enablePushWithUAChannelID:identifier callback:^(ZDKPushRegistrationResponse *registrationResponse, NSError *error) {
        
        NSString *title;
        
        if (error) {
            
            title = @"Registration Failed";
            NSLog(@"Couldn't register device: %@. Error: %@", identifier, error);
            
        } else if (registrationResponse) {
            
            title = @"Registration Successful";
            NSLog(@"Successfully registered device with channel ID: %@", identifier);
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
}


- (IBAction)unregisterForPush:(id)sender {
    
    if ( ! isZendeskSDKInitialised ) {
        [self showInitializationAlert];
        return;
    }
    
    NSString *identifier = [self getDeviceId];
    if ( ! identifier) {
        NSLog(@"No identifier found");
        return;
    }
    
    [[ZDKConfig instance] disablePush:identifier callback:^(NSNumber *responseCode, NSError *error) {
        
        NSString *title;
        
        if (error) {
            
            title = @"Failed to Unregister";
            NSLog(@"Couldn't unregister device: %@. Error: %@", identifier, error);
            
        } else if (responseCode) {
            
            title = @"Unregistered";
            NSLog(@"Successfully unregistered device: %@", identifier);
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
    
}

- (NSString*) getDeviceId
{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:APPLE_PUSH_UUID];
    
    return result;
}


@end
