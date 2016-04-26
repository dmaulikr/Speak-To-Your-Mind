//
//  Settings.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "SA_OAuthTwitterEngine.h"
// _engine.consumerKey= @"Pm5fOZw3XVFHqSkIugoog";
//_engine.consumerSecret= @"8Io3rt6mIq8JivzNaqflt33FwmCnlcWQzxUY7jM4Q";
#define kOAuthConsumerKey				@"Pm5fOZw3XVFHqSkIugoog"	    //REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret			@"8Io3rt6mIq8JivzNaqflt33FwmCnlcWQzxUY7jM4Q"	
@implementation Settings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Settings";
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - IBAction Methods
-(void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username
{
    
    NSLog(@"asd = %@",username);
    
    
}

- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier);  
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
}  
-(IBAction)TwitterPost:(id)sender
{   
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    
    
   //NSString *strToken= [[NSUserDefaults standardUserDefaults] objectForKey:@"OATK"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
   //NSString *strSecret= [[NSUserDefaults standardUserDefaults] objectForKey:@"OATS"];
    _engine.consumerKey = kOAuthConsumerKey;
    _engine.consumerSecret = kOAuthConsumerSecret;
    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    
    
    
}
-(IBAction)LogoutCliked:(id)sender
{
    NSUserDefaults *loginInfo=[NSUserDefaults standardUserDefaults];
    [loginInfo removeObjectForKey:@"iUserID"];
    [loginInfo removeObjectForKey:@"iArtistType"];
    [loginInfo removeObjectForKey:@"vArtistType"];
    [loginInfo removeObjectForKey:@"vImage"];
    [loginInfo synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Help:(id)sender
{
    InstructionView *objInstructionView=[[InstructionView alloc]initWithNibName:@"InstructionView" bundle:nil];
    [self.navigationController pushViewController:objInstructionView animated:YES];
    [objInstructionView release];
}
- (IBAction)EditAccount:(id)sender
{
    EditAccount *objEditAccount=[[EditAccount alloc]initWithNibName:@"EditAccount" bundle:nil];
    [self.navigationController pushViewController:objEditAccount animated:YES];
    [objEditAccount release];
}
#pragma mark - Extra Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
