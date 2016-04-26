//
//  RootViewController.h
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakYoMindAppDelegate.h"

#import "SignUp.h"

#import "HomeView.h"


#import "AppConstat.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "FbGraph.h"
#import "FbGraphResponse.h"
#import "TwitterVC.h"

#import "oAuth2TestViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
@interface RootViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,callFacebookremove,SA_OAuthTwitterEngineDelegate,SA_OAuthTwitterControllerDelegate>
{
    SA_OAuthTwitterEngine *_engine;


   IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    FbGraph *fbGraph;
    IBOutlet UIButton *BtnArtist1;
    IBOutlet UIButton *BtnArtist2;
    IBOutlet UIButton *BtnArtist3;
    IBOutlet UIButton *BtnArtist4;
    IBOutlet UIButton *BtnArtist5;
    int FlagSelected;
    IBOutlet UIView *ArtistView;
    IBOutlet UIView *BlackView;



}
-(void)ShowArtistView;
-(void)MoveArtistButton;
-(IBAction)Done:(id)sender;
-(IBAction)SelectArtist:(id)sender;

-(IBAction)clickBack:(id)sender;
-(void)loadTwitterView;
-(IBAction)tweet:(id)sender; 
@property (nonatomic, retain) NSString *feedPostId;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) oAuth2TestViewController *oAuth2FBLoginView;
-(IBAction)SignUp:(id)sender;
-(IBAction)Login:(id)sender;


#pragma mark - Remove Null
-(NSString *)removeNull:(NSString *)str;
-(IBAction)Login_Facebook:(id)sender;
-(IBAction)Login_Twitter:(id)sender;

@end
