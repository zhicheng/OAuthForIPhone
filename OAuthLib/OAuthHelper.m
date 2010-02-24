//
//  OAuthHelper.m
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OAuthLib.h"
#import "OAuthHelper.h"

@implementation OAuthHelper

@synthesize requestToken = _requestToken;
@synthesize accessToken = _accessToken;
@synthesize consumer = _consumer;
@synthesize delegate;

- (id) initWithConsumerKey:(NSString *)consumer_key secret:(NSString *)consumer_secret
{
	if (self = [super init]) {
		self.consumer = [[[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret] autorelease];
	}
	return self;
}

- (void) requestRequestTokenWithURL:(NSString *)request_token_url
{
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:request_token_url]
																   consumer:self.consumer
																	  token:nil
																	  realm:nil
														  signatureProvider:nil];
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	//NSLog(@"debug show request_token_url:%@", request_token_url);
	[fetcher fetchDataWithRequest:request 
						 delegate:self 
				didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) 
				  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[self.delegate getRequestToken:self.requestToken];
#ifdef OADEBUG
		NSLog(@"show request token:%@", responseBody);
#endif
	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self.delegate getOAuthError:error];
#ifdef OADEBUG
	NSLog(@"request request token fail:%@", error);
#endif
}

- (NSURL *) authorizeURLwithBaseURL:(NSString *)authorize_url
{
	NSString *url_string = [NSString stringWithFormat:@"%@?oauth_token=%@",authorize_url, self.requestToken.key];
	NSURL *url = [NSURL URLWithString:url_string];
	return url;
}

- (void) requestAccessTokenWithURL:(NSString *)access_token_url
{
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:access_token_url]
																   consumer:self.consumer
																	  token:self.requestToken
																	  realm:nil
														  signatureProvider:nil];
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request 
						 delegate:self 
				didFinishSelector:@selector(accessTokenTicket:didFinishWithData:) 
				  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[self.delegate getAccessToken:self.accessToken];
#ifdef OADEBUG
		NSLog(@"show access token:%@", responseBody);
#endif
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self.delegate getOAuthError:error];
#ifdef OADEBUG
	NSLog(@"request request token fail:%@", error);
#endif
}

- (void) setAccessTokenKey:(NSString *)access_key secret:(NSString *)access_secret
{
	self.accessToken = [[[OAToken alloc] initWithKey:access_key secret:access_secret] autorelease];
}


/*  access user's resource */
/* Usage:
 ---------------------
 [oauth accessResourceWithURL:kOAResourceURL
				   HTTPMethod:@"POST"
                     HTTPBody:http_body
		           HTTPParams:nil
                  HTTPHeaders:header];
 
 ---------------------
 
 the HTTPBody and HTTPParams can't set in same time.
 if you set HTTPBody and HTTPParams Just HTTPBody in 
 request.
 
 if you use the mulipart the upload file you need 
 build the HTTPBody by you self, and set the HTTPBody
 params.
 
 if you just POST Some text maybe just HTTPParams enought. :-)
 

 
 */
- (void) accessResourceWithURL:(NSString *)resource_url 
					HTTPMethod:(NSString *)http_method 
					  HTTPBody:(NSData *)http_body
					HTTPParams:(NSArray *)http_params
				   HTTPHeaders:(NSDictionary *)http_headers
{
	NSURL *url = [NSURL URLWithString:resource_url];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:self.consumer
																	  token:self.accessToken
																	  realm:nil
														  signatureProvider:[[OAHMAC_SHA1SignatureProvider alloc] init]];
	for (NSString *key in http_headers){
		[request setValue:[http_headers objectForKey:key] forHTTPHeaderField:key];
	}
	
	if (http_body != nil) {
		[request setHTTPBody:http_body];
	} else if (HTTPParams != nil) {
		for (NSString *key in http_params) {
			[request setParameters:http_params];
		}
	}
	

	[request setHTTPMethod:http_method];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(apiTicket:didFinishWithData:)
				  didFailSelector:@selector(apiTicket:didFailWithError:)];
}

- (void) apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[self.delegate getHTTPBodyViaOAuth:responseBody];
#ifdef OADEBUG
		NSLog(@"show access token:%@", responseBody);
#endif
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	[self.delegate getOAuthError:error];
#ifdef OADEBUG
	NSLog(@"request request token fail:%@", error);
#endif
}

@end
