//
//  Settings.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionView.h"
#import "EditAccount.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
@interface Settings : UIViewController<SA_OAuthTwitterControllerDelegate>
{
    SA_OAuthTwitterEngine *_engine;

}
-(IBAction)Back:(id)sender;
-(IBAction)LogoutCliked:(id)sender;
- (IBAction)Help:(id)sender;
- (IBAction)EditAccount:(id)sender;

-(IBAction)TwitterPost:(id)sender;
@end
