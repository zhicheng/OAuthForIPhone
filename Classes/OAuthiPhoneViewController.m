//
//  OAuthiPhoneViewController.m
//  OAuthiPhone
//
//  Created by weizhicheng on 10-2-22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "OAuthiPhoneViewController.h"

#define kOAConsumerKey			@"06dd4f7b603b5c4c1497ee7220b214e4"
#define kOAConsumerSecretKey 	@"d19430a103e7eb40"
#define kOARequestTokenURL		@"http://www.douban.com/service/auth/request_token"
#define kOAAuthorizeTokenURL	@"http://www.douban.com/service/auth/authorize"
#define kOAAccessTokenURL		@"http://www.douban.com/service/auth/access_token"
#define kOAResourceURL			@"http://api.douban.com/notes"

@implementation OAuthiPhoneViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	//client = [[OAuthClientTest alloc] init];
	//[client accessResource];
	oauth = [[OAuthHelper alloc ]initWithConsumerKey:kOAConsumerKey secret:kOAConsumerSecretKey];
	[oauth setDelegate:self];
	NSString *access_token_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_token_key"];
	NSString *access_token_secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_token_secret"];
	if (access_token_key == nil || access_token_secret == nil) {
		[oauth requestRequestTokenWithURL:kOARequestTokenURL];
		sleep(20);
		[oauth requestAccessTokenWithURL:kOAAccessTokenURL];
	} else {
		[oauth setAccessTokenKey:access_token_key secret:access_token_secret];
	}

	
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
	
	NSDictionary *header = [NSDictionary dictionaryWithObject:@"application/atom+xml" forKey:@"Content-Type"];
	
	NSData *http_body = [content dataUsingEncoding:NSUTF8StringEncoding];
	[oauth accessResourceWithURL:kOAResourceURL
					  HTTPMethod:@"POST"
						HTTPBody:http_body
					 HTTPHeaders:header];

	self.view = contentView;
	[contentView release];
}

- (void) test
{
	[client requestAccessToken];
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) getRequestToken:(OAToken *) request_token
{
	NSLog(@"show request_token:%@", request_token);
	NSURL *url = [oauth authorizeURLwithBaseURL:kOAAuthorizeTokenURL];
	NSLog(@"authorize url:%@", url);
	
}
- (void) getAccessToken:(OAToken *) access_token
{
	NSLog(@"show access_token:%@", access_token);
	[[NSUserDefaults standardUserDefaults] setObject:access_token.key forKey:@"oauth_token_key"];
	[[NSUserDefaults standardUserDefaults] setObject:access_token.secret forKey:@"oauth_token_secret"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) getHTTPBodyViaOAuth:(NSString *)http_body
{
	NSLog(@"show http_body:%@", http_body);
}
- (void) getOAuthError:(NSError *) error
{
	NSLog(@"show oauth error:%@", error);
}

- (void)dealloc {
    [super dealloc];
}

@end
