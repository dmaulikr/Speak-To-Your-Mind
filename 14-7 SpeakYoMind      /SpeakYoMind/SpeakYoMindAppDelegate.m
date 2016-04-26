//
//  SpeakYoMindAppDelegate.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeakYoMindAppDelegate.h"

@implementation SpeakYoMindAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;


+(SpeakYoMindAppDelegate *)sharedInstance
{
    return (SpeakYoMindAppDelegate *)[[UIApplication sharedApplication]delegate];

}
- (BOOL) validateEmail: (NSString *) Email {
	
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:Email];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BG.png"]];
    [img setFrame:CGRectMake(0,20, 320, 460)];
    [self.window addSubview:img];
    [self.window sendSubviewToBack:img];
    [img release];
    
    self.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Connection

- (BOOL) isconnectedToNetwork
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}

#pragma mark - AlertHandler
- (void)showLoadingView {
    
    //
    
    //[self doshowLoadingView];
	[self performSelectorOnMainThread:@selector(doshowLoadingView) withObject:nil waitUntilDone:NO];
    
    //	activityAlert = [[[ActivityAlertView alloc] 
    //                      initWithTitle:@"Loading"
    //                      message:@"Please wait..."
    //                      delegate:self cancelButtonTitle:nil 
    //                      otherButtonTitles:nil] autorelease];
    //	
    //    [activityAlert show];
}

// -----------------------------------------------------------------------------

- (void)hideLoadingView {
    
    
    //[self dohideLoadingView];
    [self performSelectorOnMainThread:@selector(dohideLoadingView) withObject:nil waitUntilDone:NO];
    
    //if ([activityAlert isVisible]) {
    //[activityAlert close];
    //}
    
}
- (void)doshowLoadingView{
    
    [NSThread detachNewThreadSelector:@selector(check) toTarget:self withObject:nil];
    
    
    //[AlertHandler showAlertForProcess];
}

-(void)check
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [AlertHandler showAlertForProcess];
    [pool release];
    
}

- (void)dohideLoadingView{
    [AlertHandler hideAlert];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
