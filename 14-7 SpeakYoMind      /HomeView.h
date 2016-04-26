//
//  HomeView.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNewRecordOrNotepad.h"

#import "SpeakYoMindAppDelegate.h"

#import "Library.h"
#import "Favorites.h"
#import "Top10Week.h"
#import "Posts.h"
#import "Settings.h"

@interface HomeView : UIViewController<UITextFieldDelegate>
{
    SpeakYoMindAppDelegate *objSpeakYoMindAppDelegate;
    IBOutlet UILabel *lblArtistName;

    IBOutlet UIImageView *imgViewUser;
    IBOutlet UIActivityIndicatorView *indicator;

}
-(IBAction)CreateNew:(id)sender;
-(IBAction)Library:(id)sender;
-(IBAction)Favorites:(id)sender;
-(IBAction)Top10:(id)sender;
-(IBAction)Post:(id)sender;
-(IBAction)Settings:(id)sender;
@end
