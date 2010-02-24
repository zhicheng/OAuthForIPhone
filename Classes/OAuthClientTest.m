//
//  OAuthClientTest.m
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OAuthClientTest.h"

#define kOAConsumerKey			@"06dd4f7b603b5c4c1497ee7220b214e4"
#define kOAConsumerSecretKey 	@"d19430a103e7eb40"
#define kOARequestTokenURL		@"http://www.douban.com/service/auth/request_token"
#define kOAAuthorizeTokenURL	@"http://www.douban.com/service/auth/authorize?oauth_token=%@"
#define kOAAccessTokenURL		@"http://www.douban.com/service/auth/access_token"
//#define kOAResourceURL			@"http://192.168.1.7:8000/profile.json"
#define kOAResourceURL			@"http://api.douban.com/notes"
#define kOArealm				@""

#define kOAToken				@"0367a1db27ec10670a36e59177c43135"
#define kOASecret				@"5373ac1b03455002"
@implementation OAuthClientTest

@synthesize requestToken = _requestToken;
@synthesize accessToken = _accessToken;
@synthesize consumer = _consumer;

- (id) init
{
	if (self = [super init]) {
		self.consumer = [[[OAConsumer alloc] initWithKey:kOAConsumerKey secret:kOAConsumerSecretKey] autorelease];
	}
	return self;
}

- (void) requestRequestToken
{
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kOARequestTokenURL]
																   consumer:self.consumer
																	  token:nil
																	  realm:kOArealm
														  signatureProvider:nil];
	[request setHTTPMethod:@"GET"];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(requestTokenTicket:didFinishWithData:) didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		NSLog(@"show request token:%@", responseBody);
	}
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"request request token fail:%@", error);
}

- (UIWebView *) authorize
{

	NSString *url = [NSString stringWithFormat:kOAAuthorizeTokenURL, self.requestToken.key];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	[webView setBackgroundColor:[UIColor whiteColor]];
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	
	return webView;
	//[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:
											//[NSString stringWithFormat:kOAAuthorizeTokenURL, self.requestToken.key]]];
}

- (void) requestAccessToken
{
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kOAAccessTokenURL]
																   consumer:self.consumer
																	  token:self.requestToken
																	  realm:kOArealm
														  signatureProvider:nil];
	[request setHTTPMethod:@"GET"];
	
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
		NSLog(@"show access token:%@", responseBody);
	}
}

- (void) accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"request request token fail:%@", error);
}

- (void) accessResource
{
	self.accessToken = [[OAToken alloc] initWithKey:kOAToken secret:kOASecret];
	NSString *content = @"\r\n\r\n<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
	<entry xmlns=\"http://www.w3.org/2005/Atom\" \
	xmlns:db=\"http://www.douban.com/xmlns/\"> \
	<title>ABOUT ME</title> \
	<content> \
	在失去勇气的日子里，要提醒自己的好！  我从来不寻找任何避风港，20多年的日子里每个选择都来自我自己，我比你们想象的都要坚强。我为我的坚强付出了很多，却到现在依然没有后悔过任何。 我从不觉得牺牲自己是件多伟大的事，没有人是需要别人来成全的，从来不想以自己的付出作为最后的救命稻草，这种付出委实是在出卖尊严...... \
	</content> \
	<db:attribute name=\"privacy\">private</db:attribute> \
	<db:attribute name=\"can_reply\">yes</db:attribute> \
	</entry>";
	//NSURL *url = [NSURL URLWithString:@"http://api.douban.com/people/%40me"];
	NSURL *url = [NSURL URLWithString:kOAResourceURL];
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:self.consumer
																	  token:self.accessToken
																	  realm:kOArealm
														  //signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
														  signatureProvider:[[OAHMAC_SHA1SignatureProvider alloc] init]];
	[request setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/atom+xml" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	//[request 
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
		NSLog(@"show access token:%@", responseBody);
	}
}

- (void) apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
	NSLog(@"request request token fail:%@", error);
} 


- (void)restConnection:(NSURLConnection *)connection didReturnResource:(id)resource object:(id)object {
	//NSLog(@"resource:%@", resource);
	[self requestAccessToken];
	[self accessResource];
}

@end
