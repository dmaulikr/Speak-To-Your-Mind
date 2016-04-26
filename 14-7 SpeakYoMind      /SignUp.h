//
//  SignUp.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp2.h"


#import "AppConstat.h"
@interface SignUp : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIImageView *imgViewUser;

    UIImagePickerController *UIPiker;
}
-(IBAction)NextClicked:(id)sender;
-(IBAction)Back:(id)sender;



-(IBAction)BrowseClicked:(id)sender;
-(IBAction)TakeNewClicked:(id)sender;

#pragma mark - Validate Email
-(BOOL)validateEmail:(NSString *)Email;
@end
