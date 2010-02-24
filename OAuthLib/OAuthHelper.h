//
//  OAuthHelper.h
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"

@protocol OAuthHelperDelegate <NSObject>

@optional
- (void) getRequestToken:(OAToken *) request_token;
- (void) getAccessToken:(OAToken *) access_token;
- (void) getHTTPBodyViaOAuth:(NSString *)http_body;
- (void) getOAuthError:(NSError *) error;

@end



@interface OAuthHelper : NSObject {
	OAConsumer	*_consumer;
	OAToken		*_requestToken;
	OAToken		*_accessToken;
	
	id<OAuthHelperDelegate> delegate;
}

- (id) initWithConsumerKey:(NSString *)consumer_key secret:(NSString *)consumer_secret;
- (void) requestRequestTokenWithURL:(NSString *)request_token_url;
- (NSURL *) authorizeURLwithBaseURL:(NSString *)authorize_url;
- (void) requestAccessTokenWithURL:(NSString *)access_token_url;
- (void) setAccessTokenKey:(NSString *)access_token secret:(NSString *)secret_token;
- (void) accessResourceWithURL:(NSString *)resource_url HTTPMethod:(NSString *)http_method HTTPBody:(NSData *)http_body HTTPHeaders:(NSDictionary *)http_headers;

@property (retain, nonatomic) OAToken					*requestToken;
@property (retain, nonatomic) OAToken					*accessToken;
@property (retain, nonatomic) OAConsumer				*consumer;
@property (nonatomic, assign) id<OAuthHelperDelegate>	delegate;

@end
