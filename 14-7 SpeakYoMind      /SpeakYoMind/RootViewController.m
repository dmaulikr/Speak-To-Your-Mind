//
//  RootViewController.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize feedPostId,oAuth2FBLoginView,fbGraph;

#pragma mark - View Did Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowArtistView) name:@"pushIt1" object:nil];
    
    ArtistView.hidden=TRUE;

    self.view.backgroundColor = [UIColor clearColor];
    txtUserName.text=@"demo";
    txtPassword.text=@"demo";
}

- (void)viewWillAppear:(BOOL)animated
{

    txtUserName.text=@"demo";
    txtPassword.text=@"demo";
    //self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}
#pragma mark TwitterEngineDelegate

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    
    ArtistView.hidden=TRUE;
    DisplayAlertWithTitle(@"Twitter Fail !!",@"Fail");
    return;

}
- (void) OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username{
    NSLog(@"Success:%@",username);
    if (username!=nil) {
        NSLog(@"Success !=nil:%@",username);
        NSLog(@"name = %@",username);
        //http://openxcellaus.info/announce/add_tw_token.php?User_Id=3&Tw_Username=tanna&Tw_Key=123546&Tw_Secret=fdsfds654f
        
        
        
        NSString  *urlstring1 = [NSString stringWithFormat:@"https://twitter.com/users/show.json?screen_name=%@",username];  
        
        NSURL *urlTwiter = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"profileupdate url = %@",urlTwiter);
        
        NSString * jsonRes1 = [NSString stringWithContentsOfURL:urlTwiter encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Twitter value >> %@",[jsonRes1 JSONValue]);
        NSString *str_Name =(NSString *)[[[jsonRes1 JSONValue]valueForKey:@"status"]valueForKey:@"id_str"]; 
        if ([str_Name length]>0) {
            [self ShowArtistView];
        }
        else
        {
            DisplayAlertWithTitle(@"Twitter Fail !!",@"Fail");
            return;
        }

       // [self tweet:nil];
    }else{
        DisplayAlertWithTitle(@"Twitter Fail !!",@"Fail");
        return;
    }
    
}
-(void)ShowArtistView
{
    ArtistView.hidden=FALSE;
    [self SelectArtist:(id)0];
    BtnArtist1.frame=CGRectMake(-160, 139, 158, 40);
    BtnArtist2.frame=CGRectMake(321, 181, 158, 40);
    BtnArtist3.frame=CGRectMake(-160, 223, 158, 40);
    BtnArtist4.frame=CGRectMake(321, 265, 158, 40);
    BtnArtist5.frame=CGRectMake(-160, 307, 158, 40);
    [self performSelector:@selector(MoveArtistButton) withObject:nil afterDelay:1.5];
}
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled");
    ArtistView.hidden=TRUE;

}

#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
    
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
    NSLog(@"REce");
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
    
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}
#pragma mark - custom methods
-(IBAction)clickBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)loadTwitterView
{
    //if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
   _engine.consumerKey= @"Pm5fOZw3XVFHqSkIugoog";
    _engine.consumerSecret= @"8Io3rt6mIq8JivzNaqflt33FwmCnlcWQzxUY7jM4Q";

	//_engine.consumerKey = @"PzkZj9g57ah2bcB58mD4Q";
	//_engine.consumerSecret = @"OvogWpara8xybjMUDGcLklOeZSF12xnYHLE37rel2g";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) {
		[self presentModalViewController: controller animated: YES];
    }else {
        
	}
}
-(IBAction)tweet:(id)sender {
	
	[_engine sendUpdate:@"Check this really cool game.I found called Quirky Word Search. It's so much more fun than the average word search:"];
}


#pragma mark - IBAction Methods
-(void)MoveArtistButton
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    BtnArtist1.frame=CGRectMake(81, 139, 158, 40);
    BtnArtist2.frame=CGRectMake(81, 181, 158, 40);
    BtnArtist3.frame=CGRectMake(81, 223, 158, 40);
    BtnArtist4.frame=CGRectMake(81, 265, 158, 40);
    BtnArtist5.frame=CGRectMake(81, 307, 158, 40);

    [UIView commitAnimations];
    
}
-(IBAction)Done:(id)sender
{
    HomeView *objHomeView=[[HomeView alloc]initWithNibName:@"HomeView" bundle:nil];
    objHomeView.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:objHomeView animated:YES];
    [objHomeView release];
    ArtistView.hidden=true;
    
}
-(IBAction)SelectArtist:(id)sender
{
    [BtnArtist1 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist2 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist3 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist4 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist5 setBackgroundColor:[UIColor yellowColor]];
    NSUserDefaults *loginInfo=[NSUserDefaults standardUserDefaults];
    //[loginInfo setValue:[dictRegister valueForKey:@"iUserID"] forKey:@"iUserID"];
      //  [loginInfo setValue:[dictRegister valueForKey:@"vImage"] forKey:@"vImage"];
   // [loginInfo setValue:[dictRegister valueForKey:@"vEmail"] forKey:@"vEmail"];
   // [loginInfo setObject:[NSString stringWithFormat:@"%@",txtUserName.text] forKey:@"vUserName"];
    

    
    switch ([sender tag]) {
        case 0:{
          
           // StrType=[[NSString alloc] initWithString:@"Rapper"];
            [loginInfo setValue:@"1" forKey:@"iArtistType"];
            [loginInfo setValue:@"Rapper" forKey:@"vArtistType"];
            
            [BtnArtist1 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 1:{
            [loginInfo setValue:@"2" forKey:@"iArtistType"];
            [loginInfo setValue:@"Singer" forKey:@"vArtistType"];
          //  StrType=[[NSString alloc] initWithString:@"Singer"];
            [BtnArtist2 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 2:{
            [loginInfo setValue:@"3" forKey:@"iArtistType"];
            [loginInfo setValue:@"Poet" forKey:@"vArtistType"];
          //  StrType=[[NSString alloc] initWithString:@"Poet"];
            [BtnArtist3 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 3:{
            [loginInfo setValue:@"4" forKey:@"iArtistType"];
            [loginInfo setValue:@"Mucisian" forKey:@"vArtistType"];
           // StrType=[[NSString alloc] initWithString:@"Mucisian"];
            [BtnArtist4 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 4:{
            [loginInfo setValue:@"5" forKey:@"iArtistType"];
            [loginInfo setValue:@"Other" forKey:@"vArtistType"];
          //  StrType=[[NSString alloc] initWithString:@"Other"];
            [BtnArtist5 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
    }
    [loginInfo synchronize];

    
}

-(IBAction)SignUp:(id)sender
{
    
    SignUp *objSignUp=[[SignUp alloc]initWithNibName:@"SignUp" bundle:nil];
    [self.navigationController pushViewController:objSignUp animated:YES];
    [objSignUp release];
}

-(IBAction)Login:(id)sender
{
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    
    if (![[SpeakYoMindAppDelegate sharedInstance]isconnectedToNetwork]) 
    {
        DisplayAlertConnection;
        return;
    }
    else
    {
        if ([txtUserName.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
        {
            DisplayAlertWithTitle(@"Note", @"Please Enter Username or Password");
            return;
        }
        else
        {
            
            [[SpeakYoMindAppDelegate sharedInstance]doshowLoadingView];
            NSString  *urlstring1 = [NSString stringWithFormat:@"%@login/?vUsername=%@&vPassword=%@",kWebServiceURL,txtUserName.text,txtPassword.text];            
            NSLog(@"%@",urlstring1);
            
            NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url1];
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request startSynchronous];  

        }
    }
}
-(IBAction)Login_Facebook:(id)sender
{
    oAuth2FBLoginView = [[oAuth2TestViewController alloc] initWithNibName:@"oAuth2TestViewController" bundle:nil];
    [oAuth2FBLoginView retain];
    oAuth2FBLoginView.delegate=self;
    [self presentModalViewController:oAuth2FBLoginView animated:YES];
    [oAuth2FBLoginView release];
}
-(IBAction)Login_Twitter:(id)sender
{
//    TwitterVC *ObjTwitterVC = [[TwitterVC alloc] initWithNibName:@"TwitterVC" bundle:nil];
//    //[oAuth2FBLoginView retain];
//   // oAuth2FBLoginView.delegate=self;
//    [self presentModalViewController:ObjTwitterVC animated:YES];
//    [ObjTwitterVC release];
    [self loadTwitterView];
}

#pragma mark - ASIHTTP Request
// CFNetwork, SystemConfiguration, MobileCoreServices, CoreGraphics and libz
- (void) requestStarted:(ASIHTTPRequest *) request 
{
    NSLog(@"request started...");
}
- (void) requestFinished:(ASIHTTPRequest *)request 
{
    
    NSString *responseString = [request responseString];
   
    //NSLog(@"Response %d : %@", request.responseStatusCode, [request responseString]);
    
    NSMutableDictionary *dictRegister = [NSMutableDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"%@",dictRegister);
    
    NSString *strMSG = [dictRegister valueForKey:@"message"];
    strMSG = [self removeNull:strMSG];
    
    [[SpeakYoMindAppDelegate sharedInstance]dohideLoadingView];
    
    
    if ([strMSG isEqualToString:@"SUCCESS"])
    {
        NSUserDefaults *loginInfo=[NSUserDefaults standardUserDefaults];
        [loginInfo setValue:[dictRegister valueForKey:@"iUserID"] forKey:@"iUserID"];
        [loginInfo setValue:[dictRegister valueForKey:@"iArtistType"] forKey:@"iArtistType"];
        [loginInfo setValue:[dictRegister valueForKey:@"vArtistType"] forKey:@"vArtistType"];
        [loginInfo setValue:[dictRegister valueForKey:@"vImage"] forKey:@"vImage"];
        [loginInfo setValue:[dictRegister valueForKey:@"vEmail"] forKey:@"vEmail"];
        [loginInfo setObject:[NSString stringWithFormat:@"%@",txtUserName.text] forKey:@"vUserName"];

        [loginInfo synchronize];
        
        
        HomeView *objHomeView=[[HomeView alloc]initWithNibName:@"HomeView" bundle:nil];
        objHomeView.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:objHomeView animated:YES];
        [objHomeView release];
        
//        UIAlertView *alertSuccess = [[UIAlertView alloc]initWithTitle:@"Successfull" message:@"Login Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        alertSuccess.tag=10;
//        [alertSuccess show];
//        [alertSuccess release];
        
    }
    else if([strMSG isEqualToString:@"ERROR"])
    {
        DisplayAlertWithTitle(@"Fail", @"Login Fail!!");
        return;
    }
    else if([strMSG isEqualToString:@""])
    {
        DisplayAlertWithTitle(@"Fail", @"Service Error");
        return;
    }
    else
    {
        DisplayAlertWithTitle(@"Fail", @"Login Fail!!");
        return;
    }
}

- (void) requestFailed:(ASIHTTPRequest *) request 
{
    [[SpeakYoMindAppDelegate sharedInstance]dohideLoadingView];
    
    NSError *error = [request error];
    NSString *err = [NSString stringWithFormat:@"%@",error];
    DisplayAlertWithTitle(@"Fail", err);
//    if (pool) {
//        [pool release];
//    }
    return;
    NSLog(@"%@", error);
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex==0)
        {
            
           
            
            

        }
    }

}
#pragma mark - Remove Null
-(NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];    
    if (!str) {
        return @"";
    }
    else if([str isEqualToString:@"<null>"]){
        return @"";
    }
    else if([str isEqualToString:@"(null)"]){
        return @"";
    }
    else{
        return str;
    }
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Extra 
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

#pragma mark - Dealloc
- (void)dealloc
{
    [txtUserName release];
    [txtPassword release];
     
    [super dealloc];
}

@end
