//
//  HomeView.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}



#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBarHidden = NO;
    self.title=@"Main Page";
   
    objSpeakYoMindAppDelegate = (SpeakYoMindAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    indicator.hidden=YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(StrDeatURL!=nil)
    {
        StrDeatURL=nil;
    }
    indicator.hidden=NO;
    [indicator startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *loginInfo=[NSUserDefaults standardUserDefaults];
    NSLog(@"Userid     >> %@",[loginInfo objectForKey:@"iUserID"]);
    NSLog(@"ArtistID   >> %@",[loginInfo objectForKey:@"iArtistType"]);
    NSLog(@"ArtistName >> %@",[loginInfo objectForKey:@"vArtistType"]);
    NSLog(@"ArtistName >> %@",[loginInfo objectForKey:@"vImage"]);
    
    lblArtistName.text=[NSString stringWithFormat:@"%@",[loginInfo objectForKey:@"vArtistType"]];
    
    NSString *strImg = [NSString stringWithFormat:@"%@",[loginInfo objectForKey:@"vImage"]];
    NSURL *urlImg = [NSURL URLWithString:strImg];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImg]];
    imgViewUser.image = img;
    [indicator stopAnimating];
    indicator.hidesWhenStopped=YES;

}


#pragma mark - IBAction Methods
-(IBAction)CreateNew:(id)sender
{
    CreateNewRecordOrNotepad *objCreateNewRecordOrNotepad=[[CreateNewRecordOrNotepad alloc]initWithNibName:@"CreateNewRecordOrNotepad" bundle:nil];
    [self.navigationController pushViewController:objCreateNewRecordOrNotepad animated:YES];
    [objCreateNewRecordOrNotepad release];

}
-(IBAction)Library:(id)sender
{
    Library *objLibrary=[[Library alloc]initWithNibName:@"Library" bundle:nil];
    [self.navigationController pushViewController:objLibrary animated:YES];
    [objLibrary release];


}
-(IBAction)Favorites:(id)sender
{
    Favorites *objFavorites=[[Favorites alloc]initWithNibName:@"Favorites" bundle:nil];
    [self.navigationController pushViewController:objFavorites animated:YES];
    [objFavorites release];
}
-(IBAction)Top10:(id)sender
{
    Top10Week *objTop10Week=[[Top10Week alloc]initWithNibName:@"Top10Week" bundle:nil];
    [self.navigationController pushViewController:objTop10Week animated:YES];
    [objTop10Week release];
}
-(IBAction)Post:(id)sender
{
    Posts *objPosts=[[Posts alloc]initWithNibName:@"Posts" bundle:nil];
    [self.navigationController pushViewController:objPosts animated:YES];
    [objPosts release];
}
-(IBAction)Settings:(id)sender
{
    Settings *objSettings=[[Settings alloc]initWithNibName:@"Settings" bundle:nil];
    [self.navigationController pushViewController:objSettings animated:YES];
    [objSettings release];
}


#pragma mark - Dealloc
-(void)dealloc
{
    [lblArtistName release];
    [super dealloc];
}
    

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Extra
- (void)viewDidUnload
{
    [super viewDidUnload];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
