//
//  LibNotes.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface LibNotes : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
   // IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    IBOutlet UIView *viewCreateNote;
    IBOutlet UITextView *txtView;
    IBOutlet UITextField *txtTitle;
    NSMutableArray *NoteList;
}
-(IBAction)NewNote:(id)sender;
-(IBAction)CancelNote:(id)sender;
-(IBAction)SaveNote:(id)sender;
-(NSString *)removeNull:(NSString *)str;
@end
