//
//  CreateNewRecordOrNotepad.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beats.h"

#import <AVFoundation/AVFoundation.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
#import "PCMMixer.h"
#import "AppConstat.h"
#import "ExtAudioFileConvertUtil.h"
#import "InstructionView.h"

//#import "SpeakHereController.h"
@class SpeakHereController;

@interface CreateNewRecordOrNotepad : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioRecorderDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    IBOutlet SpeakHereController *controller;

    IBOutlet UITableView *tblView;
    IBOutlet UIView *ViewTableBG;
    IBOutlet UITextView *TxtNote;
    IBOutlet UIButton *btnNotepad;
    IBOutlet UIView *NoteView;
    IBOutlet UIButton *btnDown;
    IBOutlet UIScrollView *Scrollview1;
    IBOutlet UILabel *LblPageno;
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnPrevious;
    IBOutlet UIButton *btnReset;
    IBOutlet UIButton *btnNewPage;
    NSMutableArray *NoteList;
    int PageNo;
    
}

//@property (nonatomic, retain) IBOutlet FFTView *fft_view;

-(IBAction)Back:(id)sender;
-(IBAction)Post:(id)sender;
-(IBAction)NotePadClicked:(id)sender;
-(IBAction)BeatsClicked:(id)sender;
- (IBAction)MyLibarary:(id)sender;
- (IBAction)DownView:(id)sender;
- (IBAction)Next:(id)sender;
- (IBAction)Previous:(id)sender;
- (IBAction)Reset:(id)sender;
- (IBAction)NewPages:(id)sender;
- (IBAction)Help:(id)sender;

-(void)GetPiece;
-(IBAction) clickBack;
- (void)reloadtable;
@end
