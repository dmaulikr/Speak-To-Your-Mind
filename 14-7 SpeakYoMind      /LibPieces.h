//
//  LibPieces.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
#import "PostList.h"
#import <AVFoundation/AVFoundation.h>

@interface LibPieces : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextViewDelegate>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *LblName;
    IBOutlet UIButton *BtnPost;
    IBOutlet UIButton *PlayBtn;

    UIActionSheet *Actionsheet1;
    IBOutlet UIView *PostView;
    IBOutlet UITextView *TxtPost;
   NSString *PieceId;
    NSMutableArray *PostList;
    AVAudioPlayer *avAudioObj;
    int FlagTag;

    NSString *StrDeatURL1;


}
-(void)GetPiece;
-(IBAction)Post:(id)sender;
-(IBAction)PostDone:(id)sender;


@end
