//
//  Posts.h
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
#import "EGOImageView.h"
@interface Posts : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *LblName;
    IBOutlet UILabel *LblLike;
    IBOutlet UIButton *BtnLike;
    IBOutlet UIButton *BtnFaV;
    IBOutlet EGOImageView *IMG_Photo;

    NSString *PieceId;

}
-(void)GetPiece;
-(IBAction)AddFaV:(id)Sender;
-(IBAction)AddLike:(id)Sender;
@end
