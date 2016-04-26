//
//  Favorites.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favorites.h"

@implementation Favorites

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
    self.title=@"Favorites";
    self.view.backgroundColor = [UIColor clearColor];

    tblView.backgroundColor= [UIColor clearColor];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (PieceList!=nil) {
        [PieceList removeAllObjects];
        PieceList=nil;
    }
    PieceList=[[NSMutableArray alloc] init];
    [self GetPiece];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)GetPiece
{
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(GetPieceList) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
}
- (void)GetPieceList{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@favourite_piece/?iUserID=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
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
    [PieceList removeAllObjects];
    
    if ([tempdic valueForKey:@"piece"]!=nil) {
        
        [PieceList setArray:[tempdic valueForKey:@"piece"]];
        
        //[tblView reloadData];
        
        [self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
        
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
#pragma mark - IBAction Methods

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PieceList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [[NSBundle mainBundle]loadNibNamed:@"Favorites_Cell" owner:self options:nil];
        cell=myCell;
    }

    if ([PieceList count]!=0) {
        
        UIImageView *imgViewCellBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellBGImage.png"]];
        cell.backgroundView=imgViewCellBG;
        [imgViewCellBG release];
        imgViewCellBG=nil;
        LblName.text=[NSString stringWithFormat:@"%@-Artist",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"vPieceName"]];
        LblLike.text=[NSString stringWithFormat:@"%@ Likes",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"pieceTotalLikedCount"]];
        IMG_Photo.imageURL=[NSURL URLWithString:[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"vImageOfUserThumb"]  ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];


       // BtnFaV.tag=indexPath.row;
       // BtnLike.tag=indexPath.row;
        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(StrDeatURL1!=nil)
    {
        StrDeatURL1=nil;
    }
    StrDeatURL1=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex:indexPath.row] valueForKey:@"vPieceFileName"]]retain];
    [avAudioObj stop];
    if (avAudioObj!=nil) {
        [avAudioObj release];
        avAudioObj=nil;
    }
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

-(void)PlayBeat1
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    
    NSData *Data;
    
    Data=[NSData dataWithContentsOfURL:[NSURL URLWithString:StrDeatURL1]];
    
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
