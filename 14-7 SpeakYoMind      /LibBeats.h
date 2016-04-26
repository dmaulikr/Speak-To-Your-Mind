//
//  LibBeats.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibBeats : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITableView *tblView;
    
}

-(IBAction)MoreClicked:(id)sender;

@end
