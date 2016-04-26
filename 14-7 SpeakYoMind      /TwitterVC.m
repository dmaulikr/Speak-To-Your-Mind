//
//  TwitterVC.m
//  ExtremeWordSearch
//
//  Created by OpenXcell-Macmini3 on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterVC.h"

@interface TwitterVC ()

@end

@implementation TwitterVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadTwitterView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authDataTweet"];
	[defaults synchronize];

}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}
#pragma mark TwitterEngineDelegate

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}
- (void) OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username{
    NSLog(@"Success:%@",username);
    if (username!=nil) {
        NSLog(@"Success !=nil:%@",username);
        [self tweet:nil];
    }else{
        
    }
    
}
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled");
}

#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);

}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    NSLog(@"REce");
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}
#pragma mark - custom methods
-(IBAction)clickBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)loadTwitterView
{
    if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"PzkZj9g57ah2bcB58mD4Q";
	_engine.consumerSecret = @"OvogWpara8xybjMUDGcLklOeZSF12xnYHLE37rel2g";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) {
		[self presentModalViewController: controller animated: YES];
    }else {

	}
}
-(IBAction)tweet:(id)sender {
	
	[_engine sendUpdate:@"Check this really cool game.I found called Quirky Word Search. It's so much more fun than the average word search:"];
}
@end
