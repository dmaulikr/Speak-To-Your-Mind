//
//  Favorites.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
#import <AVFoundation/AVFoundation.h>
#import "EGOImageView.h"

@interface Favorites : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *LblName;
    IBOutlet UILabel *LblLike;
    NSString *StrDeatURL1;
    AVAudioPlayer *avAudioObj;
    IBOutlet EGOImageView *IMG_Photo;
    
}
-(void)GetPiece;
@end
