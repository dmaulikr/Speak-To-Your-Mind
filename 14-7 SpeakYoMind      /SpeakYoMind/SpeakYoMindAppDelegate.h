//
//  SpeakYoMindAppDelegate.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlertHandler.h"
#import "Reachability.h"



@interface SpeakYoMindAppDelegate : NSObject <UIApplicationDelegate> 
{

}
+(SpeakYoMindAppDelegate *)sharedInstance;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

#pragma mark - Connection
- (BOOL) isconnectedToNetwork;

#pragma mark - AlertHandler
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)doshowLoadingView;
-(void)check;
- (void)dohideLoadingView;
- (BOOL) validateEmail: (NSString *) Email;

@end
