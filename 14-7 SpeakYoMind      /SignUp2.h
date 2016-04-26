//
//  SignUp2.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpeakYoMindAppDelegate.h"
#import "AppConstat.h"
#import "JSON.h"


@interface SignUp2 : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{

    SpeakYoMindAppDelegate *objSpeakYoMindAppDelegate;
    IBOutlet UITableView *tblView;
    NSMutableArray *arrArtistTitle;
    
    NSString *strArtistType;
    int int_ArtistType;
}


-(void)RegisterUser;
-(IBAction)Back:(id)sender;
-(IBAction)DoneClicked:(id)sender;
#pragma mark - Remove Null
-(NSString *)removeNull:(NSString *)str;



@end
