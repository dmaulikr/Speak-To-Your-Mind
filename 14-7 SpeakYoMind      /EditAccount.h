//
//  EditAccount.h
//  SpeakYoMind
//
//  Created by apple apple on 7/12/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstat.h"
#import "EGOImageView.h"
#import "SpeakYoMindAppDelegate.h"
#import "JSON.h"
#import "AppConstat.h"

@interface EditAccount : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtUserName;
    IBOutlet EGOImageView *imgViewUser;

    IBOutlet UIButton *BtnArtist1;
    IBOutlet UIButton *BtnArtist2;
    IBOutlet UIButton *BtnArtist3;
    IBOutlet UIButton *BtnArtist4;
    IBOutlet UIButton *BtnArtist5;
    
    UIImagePickerController *UIPiker;
    int FlagSelected;
    IBOutlet UIView *ViewChnagePassword;
    IBOutlet UITextField *txtCurrent;
    IBOutlet UITextField *txtNew;
    IBOutlet UITextField *txtConfirm;
    NSString *StrType;


}
-(void)UpdateUser;
-(IBAction)Back:(id)sender;
-(IBAction)BrowseClicked:(id)sender;
-(IBAction)TakeNewClicked:(id)sender;
-(IBAction)SelectArtist:(id)sender;
-(IBAction)ChnagePassword:(id)sender;
-(IBAction)Change:(id)sender;
-(IBAction)Update:(id)sender;
-(IBAction)Back1:(id)sender;

-(void)SelectArtist1:(int)sender;
-(void)DefaultSelect;
#pragma mark - Validate Email
-(BOOL)validateEmail:(NSString *)Email;

@end
