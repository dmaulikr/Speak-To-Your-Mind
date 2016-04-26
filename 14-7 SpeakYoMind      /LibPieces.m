//
//  LibPieces.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LibPieces.h"

@implementation LibPieces

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
-(IBAction)Post:(id)sender
{
    TxtPost.text=@"";
    [TxtPost becomeFirstResponder];
    PostView.hidden=FALSE;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view bringSubviewToFront:TxtPost];
    PostView.frame = CGRectMake(2, 47, PostView.frame.size.width, PostView.frame.size.height);
    [UIView commitAnimations];
}
-(IBAction)PostDone:(id)sender
{
    [TxtPost resignFirstResponder];
    if (PieceId!=nil) {
        PieceId=nil;
    }
    PieceId=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: [sender tag]] valueForKey:@"iPieceID"]] retain];
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(AddPost) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    } 
    
    

}
-(IBAction)AddFaV:(id)Sender
{
    
    
}
-(void)AddPost
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@comment_piece/add/?iPieceID=%@&iUserID=%@&tCommentText=%@",kWebServiceURL,PieceId,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],[NSString stringWithFormat:@"%@",TxtPost.text]];
    NSURL *url = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"message"];
    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
    
    if ([strlogin isEqualToString:@"SUCCESS"]) {
        //[self GetPostList];   
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        //  [self.view bringSubviewToFront:TxtPost];
        PostView.frame = CGRectMake(2, -244, PostView.frame.size.width, PostView.frame.size.height);
        [UIView commitAnimations];
        
        DisplayAlertWithTitle(@"Post Comment SucessFully.", @"Note");
        return;
    }
    else
    {

        DisplayAlertWithTitle(@"Post Comment Failed !", @"Note");
        return;        
    }
    [pool release];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //self.view.frame=CGRectMake(0, -310, 320, 480);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        self.view.frame=CGRectMake(0, 0, 320, 480);
        [textView resignFirstResponder];
    }
    return YES;

}
#pragma mark - WS

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
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@piece/?ByiUserID=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
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
#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //FlagPlay=0;
    TxtPost.layer.borderWidth = 2.0f;
    TxtPost.layer.borderColor = [[UIColor blackColor] CGColor];
    TxtPost.layer.cornerRadius = 8; 
    
    PostView.layer.cornerRadius = 8; 
    
    if (PieceList!=nil) {
        [PieceList removeAllObjects];
        PieceList=nil;
    }
    PieceList=[[NSMutableArray alloc] init];
    [self GetPiece];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Pieces";
    self.view.backgroundColor = [UIColor clearColor];
    tblView.backgroundColor=[UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        [[NSBundle mainBundle]loadNibNamed:@"LibPieces_Cell" owner:self options:nil];
        cell=myCell;
        
    }
    if ([PieceList count]!=0) {

        UIImageView *imgViewCellBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellBGImage.png"]];
        cell.backgroundView=imgViewCellBG;
        [imgViewCellBG release];
            imgViewCellBG=nil;
        LblName.text=[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"vPieceName"]];
        BtnPost.tag=indexPath.row;
        PlayBtn.tag=indexPath.row;

    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IPieceId!=nil) {
        IPieceId=nil;
    }
    IPieceId=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"iPieceID"]] retain];
    PostList *objPostList=[[PostList alloc]initWithNibName:@"PostList" bundle:nil];
    [self.navigationController pushViewController:objPostList animated:YES];
    [PostList release];
    
}
-(IBAction)PlayBeat:(id)Sender
{
    [avAudioObj stop];
    if (avAudioObj!=nil) {
        [avAudioObj release];
        avAudioObj=nil;
    }
    FlagTag=[Sender tag];
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
    
    if(StrDeatURL1!=nil)
    {
        StrDeatURL1=nil;
    }
    NSData *Data;
    StrDeatURL1=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex:FlagTag] valueForKey:@"vPieceFileName"]]retain];
    NSLog(@"%@",StrDeatURL1);
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
