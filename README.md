# zendesk_urbanairship_app_ios

The following guide is based off:

[Urban Airship iOS integration guide](http://docs.urbanairship.com/platform/ios.html)

[Zendesk iOS Embeddable getting started](https://developer.zendesk.com/embeddables/docs/ios/gettingstarted)

## Steps
1. Install Cocoapods if you have not already done so: `gem install cocoapods`.
2. Download the Zendesk SDK into the project. Run `pod install` in the top level directory of the project.
3. Open the newly created workspace.
4. [Setup Urban Airship](http://docs.urbanairship.com/platform/ios.html#apple-setup) with the app. This step has been partially completed.
  1. You will have to create an app in the Apple Developer member center. The bundle ID of the provided app is com.zendesk.UrbanAirshipSample. This ID is globally unique so you will have to choose a different bundle ID. You will then need change the Bundle Identifier in the project itself.
  2. Once the certificate has been setup in UrbanAirship you should only need to add the "Airship" folder from the [latest Urban Airship SDK](http://com.urbanairship.filereleases.s3.amazonaws.com/libUAirship-latest.zip) to the top level of the apps project directory.
  3. Add your development app key and app secret key to the Airship.plist file [as outlined here.](http://docs.urbanairship.com/platform/ios.html#create-airshipconfig-plist). 
5. Add your app key and app secret key to your Zendesk under Admin -> Mobile SDK -> \<Your app name> -> Customization. The push notifications drop down must be set to "Urban Airship".
6. In AppDelegate.m insert your application ID, zendesk URL and client ID into the indicated strings. The app uses an Anonymous identity by default. You can [change this to JWT if needed](https://developer.zendesk.com/embeddables/docs/ios/gettingstarted#authenticating-zendesk-users).
7.  You should now be able to run the app. Register for push then create a ticket, Help Center -> Contacts Us -> New. Replying to this ticket in your Zendesk will send a push notification to the device if everything is setup correctly.
