//
//  TwitterVC.h
//  ExtremeWordSearch
//
//  Created by OpenXcell-Macmini3 on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
@interface TwitterVC : UIViewController <SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate> {
    SA_OAuthTwitterEngine *_engine;
}

-(IBAction)clickBack:(id)sender;
-(void)loadTwitterView;
-(IBAction)tweet:(id)sender;
@end
