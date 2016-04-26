

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
#import <AVFoundation/AVFoundation.h>

@interface Beats : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    
    IBOutlet UIButton *UseBtn;
    IBOutlet UIButton *PlayBtn;

    IBOutlet UILabel *LblName;
    
    NSMutableArray *BeatList;
    AVAudioPlayer *avAudioObj;
    int FlagBtn;
}
-(void)GetBeats;
-(IBAction)UseBeat:(id)Sender;
-(IBAction)PlayBeat:(id)Sender;

- (void)reloadtable;
@end
