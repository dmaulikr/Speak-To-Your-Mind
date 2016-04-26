//
//  PostList.h
//  SpeakYoMind
//
//  Created by apple apple on 7/3/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
@interface PostList : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *LblName;
    IBOutlet UILabel *LblDate;
    IBOutlet UIButton *BtnLike;
    IBOutlet UIButton *BtnFaV;
    NSString *PieceId;
    NSMutableArray *CommentList;
}
-(void)GetComment;
-(IBAction)Back:(id)sender;
@end
