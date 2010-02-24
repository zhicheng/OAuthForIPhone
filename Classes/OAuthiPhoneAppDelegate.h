//
//  OAuthiPhoneAppDelegate.h
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuthiPhoneViewController;

@interface OAuthiPhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OAuthiPhoneViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OAuthiPhoneViewController *viewController;

@end

