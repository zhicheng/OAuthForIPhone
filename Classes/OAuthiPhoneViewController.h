//
//  OAuthiPhoneViewController.h
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthClientTest.h"
#import "OAuthLib.h"

@interface OAuthiPhoneViewController : UIViewController<OAuthHelperDelegate> {
	OAuthClientTest *client;
	OAuthHelper *oauth;
}

@end

