//
//  Beats.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Beats.h"

@implementation Beats

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Beats";
    self.view.backgroundColor = [UIColor clearColor];
    tblView.backgroundColor = [UIColor clearColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(BeatList!=nil)
    {
        [BeatList removeAllObjects];
        BeatList=nil;
    }
    BeatList=[[NSMutableArray alloc] init];
    [self GetBeats];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [avAudioObj stop];
    if (avAudioObj!=nil) {
        [avAudioObj release];
        avAudioObj=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)UseBeat:(id)Sender
{
    if ([[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:[Sender tag]] valueForKey:@"beatStatus"]] isEqualToString:@"NonPurchased"]) 
    {  
         
        
    }
    else
    {
        [avAudioObj stop];
        if (avAudioObj!=nil) {
            [avAudioObj release];
            avAudioObj=nil;
        }
        FlagBtn=[Sender tag];
        if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
            [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
            [self performSelectorInBackground:@selector(SaveBeat) withObject:nil];
        }
        else
        {
            DisplayAlertConnection;
            return;
        }   
    }
    
    
}
 -(void)SaveBeat
 {
     NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];

     if(StrDeatURL!=nil)
     {
         StrDeatURL=nil;
     }
     NSData *data;
     StrDeatURL=[[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:FlagBtn] valueForKey:@"vBeat"]]retain];
     NSLog(@"%@",StrDeatURL);
     NSArray *dirPaths;    
     NSString *docsDir;
     
     dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     docsDir = [dirPaths objectAtIndex:0];
     
     NSString *resPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BeatSound.caf"]];
//     if ([[NSFileManager defaultManager] fileExistsAtPath:resPath]) 
//     {
//         [[NSFileManager defaultManager] removeItemAtPath: resPath error:NULL];
//         
//     }
     data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrDeatURL]];
     [data writeToFile:resPath atomically:YES];
     Flag_BeatSound=0;
     [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
     [pool release];

 }
-(IBAction)PlayBeat:(id)Sender
{
    [avAudioObj stop];
    if (avAudioObj!=nil) {
        [avAudioObj release];
        avAudioObj=nil;
    }
    FlagBtn=[Sender tag];
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(PlayBeat1) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
    
}
//-(void)PlayBeat1
//{
//    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
//    
//    if(StrDeatURL!=nil)
//    {
//        StrDeatURL=nil;
//    }
//    NSData *data;
//    StrDeatURL=[[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:FlagBtn] valueForKey:@"vBeat"]]retain];
//    NSLog(@"%@",StrDeatURL);
//    NSArray *dirPaths;    
//    NSString *docsDir;
//    
//    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = [dirPaths objectAtIndex:0];
//    
//    NSString *resPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BeatSound.caf"]];
//    //     if ([[NSFileManager defaultManager] fileExistsAtPath:resPath]) 
//    //     {
//    //         [[NSFileManager defaultManager] removeItemAtPath: resPath error:NULL];
//    //         
//    //     }
//    data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrDeatURL]];
//    [data writeToFile:resPath atomically:YES];
//    Flag_BeatSound=0;
//    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
//    [pool release];
//    
//}
#pragma mark - Webservice

-(void)GetBeats
{
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(GetBeatsList) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
}
- (void)GetBeatsList{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@beats/?iUserID=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
   // NSString  *urlstring1 = [NSString stringWithFormat:@"%@beats/",kWebServiceURL];

    NSURL *url = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"jsonREsponse = %@",jsonRes);
    // NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"msg"];
    
    NSDictionary * tempdic = [[NSDictionary alloc] init];
    //if ([strlogin isEqualToString:@"Updated successfully"]) {
    tempdic = [jsonRes JSONValue];
    //  NSLog(@"%@",tempdic);
    
    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
    [BeatList removeAllObjects];
    
    if ([tempdic valueForKey:@"beats"]!=nil) {
        
        [BeatList setArray:[tempdic valueForKey:@"beats"]];
       
        //[tblView reloadData];
        
        [self reloadtable];
        
    }
    if (tempdic!=nil) {
        // [tempdic release];
        tempdic=nil;
    }
    [pool release];
    
    
}

- (void)reloadtable{
    
    [tblView reloadData];
}
#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BeatList count] ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [[NSBundle mainBundle]loadNibNamed:@"Beats_Cell" owner:self options:nil];
        cell=myCell;
    }
    if ([BeatList count]!=0)  {
        
        LblName.text=[[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:indexPath.row] valueForKey:@"vBeatTitle"]]uppercaseString];
        if ([[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:indexPath.row] valueForKey:@"beatStatus"]] isEqualToString:@"NonPurchased"]) {
            [UseBtn setBackgroundImage:[UIImage imageNamed:@"Buy.png"] forState:
             UIControlStateNormal];
        }
        
        UseBtn.tag=indexPath.row;
        PlayBtn.tag=indexPath.row;
        if (FlagBeats==1)
        {
            UseBtn.hidden=TRUE;
        }

    }
       
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FlagBtn=indexPath.row;
//    [avAudioObj stop];
//    if (avAudioObj!=nil) {
//        [avAudioObj release];
//        avAudioObj=nil;
//    }
//    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
//        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
//        [self performSelectorInBackground:@selector(PlayBeat) withObject:nil];
//    }
//    else
//    {
//        DisplayAlertConnection;
//        return;
//    }  
    
    

//    NSArray *dirPaths;    
//	NSString *docsDir;
	
//	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	docsDir = [dirPaths objectAtIndex:0];
//    
//    NSString *resPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BeatSound.caf"]];
//
//    data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrDeatURL]];
//    [data writeToFile:resPath atomically:YES];
    
}
-(void)PlayBeat1
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];

    if(StrDeatURL!=nil)
    {
        StrDeatURL=nil;
    }
    NSData *Data;
    StrDeatURL=[[NSString stringWithFormat:@"%@",[[BeatList objectAtIndex:FlagBtn] valueForKey:@"vBeat"]]retain];
    NSLog(@"%@",StrDeatURL);
    Data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrDeatURL]];
    
    
    avAudioObj = [[AVAudioPlayer alloc] initWithData:Data error:nil];
    [avAudioObj prepareToPlay];
    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];

    [avAudioObj play];	
	[pool release];
}
#pragma mark - Deallocs
-(void)dealloc
{
    [tblView release];
    [myCell release];
    [super dealloc];
}
#pragma mark - Extra
- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
