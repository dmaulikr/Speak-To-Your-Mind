//
//  InstructionView.h
//  SpeakYoMind
//
//  Created by apple apple on 7/4/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface InstructionView : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *TXTView1;
}
-(IBAction)Back:(id)sender;
@end
