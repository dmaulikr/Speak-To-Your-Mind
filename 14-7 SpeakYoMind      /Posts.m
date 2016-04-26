//
//  Posts.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Posts.h"

@implementation Posts

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
    self.title=@"Posts";
    self.view.backgroundColor = [UIColor clearColor];
    tblView.backgroundColor=[UIColor clearColor];
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

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@piece/?iUserID=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
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
    
    if ([tempdic valueForKey:@"pieces"]!=nil) {
        
        [PieceList setArray:[tempdic valueForKey:@"pieces"]];
        
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
        [[NSBundle mainBundle]loadNibNamed:@"Posts_Cell" owner:self options:nil];
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

        BtnFaV.tag=indexPath.row;
        BtnLike.tag=indexPath.row;
        if ([[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"favStatus"]] isEqualToString:@"FAVOURITE"]) {
            [BtnFaV setImage:[UIImage imageNamed:@"btnStar_G.png"] forState:UIControlStateNormal];
            BtnFaV.userInteractionEnabled=FALSE;

        }
        if ([[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"likeStatus"]] isEqualToString:@"UNLIKED"]==NO) {
            [BtnLike setImage:[UIImage imageNamed:@"btnHeart_G.png"] forState:UIControlStateNormal];
            BtnLike.userInteractionEnabled=FALSE;
            
        } 

    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
-(IBAction)AddFaV:(id)Sender
{
  
    if (PieceId!=nil) {
        PieceId=nil;
    }
    PieceId=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: [Sender tag]] valueForKey:@"iPieceID"]] retain];
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(AddFaV1) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    } 
    
}
-(void)AddFaV1
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@favourite_piece/add/?iPieceID=%@&iUserID=%@",kWebServiceURL,PieceId,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURL *url = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"message"];

    if ([strlogin isEqualToString:@"SUCCESS"]) {
        [self GetPieceList];   
        //DisplayAlertWithTitle(@"Selected Piece Added SucessFully.", @"Note");
       // return;
    }
    else
    {
        [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];

        DisplayAlertWithTitle(@"Selected Pieces Add Failed !", @"Note");
        return;        
    }
    [pool release];
}

-(IBAction)AddLike:(id)Sender
{
    if (PieceId!=nil) {
        PieceId=nil;
    }
    PieceId=[[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: [Sender tag]] valueForKey:@"iPieceID"]] retain];
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(AddLike1) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    } 
    
}
-(void)AddLike1
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@like_piece/add/?iPieceID=%@&iUserID=%@",kWebServiceURL,PieceId,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
    NSURL *url = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"message"];
    
    if ([strlogin isEqualToString:@"SUCCESS"]) {
        [self GetPieceList];   
       // DisplayAlertWithTitle(@"Selected Piece Added SucessFully.", @"Note");
        //return;
    }
    else
    {
        [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];

        DisplayAlertWithTitle(@"Selected Pieces Add Failed !", @"Note");
        return;        
    }
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
