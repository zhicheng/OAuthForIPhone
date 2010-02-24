//
//  OAuthClientTest.h
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "OAConsumer.h"

@class OAToken;
@class OAConsumer;

@interface OAuthClientTest : NSObject {
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
	OAToken		*_accessToken;
	//OAuthClientTestDelegate *_delegate;
}

- (void) requestRequestToken;
- (UIWebView *) authorize;
- (void) requestAccessToken;
- (void) accessResource;

@property (retain) OAToken					*requestToken;
@property (retain) OAToken					*accessToken;
@property (retain) OAConsumer				*consumer;

@end
