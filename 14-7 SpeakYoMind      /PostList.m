//
//  PostList.m
//  SpeakYoMind
//
//  Created by apple apple on 7/3/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import "PostList.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 390
#define CELL_CONTENT_MARGIN 45.0f

@implementation PostList

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
-(void)GetComment
{
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(GetCommentList) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
}
- (void)GetCommentList{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@comment_piece/?iPieceID=%@",kWebServiceURL,IPieceId];
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
    [CommentList removeAllObjects];
    NSLog(@"%@",[tempdic valueForKey:@"piece"]);
    
    if ([tempdic valueForKey:@"piece"]!=nil) {
        
        if ([[NSString stringWithFormat:@"%@",[tempdic valueForKey:@"piece"]] isEqualToString:@"<null>"]==NO) {
            [CommentList setArray:[tempdic valueForKey:@"piece"]];
            
            //[tblView reloadData];
            
            [self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
        }
        else
        {
            UIAlertView *Alert=[[UIAlertView alloc] initWithTitle:@"Note" message:@"Data Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [Alert show];
            [Alert release];
        }
        
        
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
    return [CommentList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [[NSBundle mainBundle]loadNibNamed:@"PostListCell" owner:self options:nil];
        cell=myCell;
    }
    if ([CommentList count]!=0) {
        
        UIImageView *imgViewCellBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellBG.png"]];
        cell.backgroundView=imgViewCellBG;
        [imgViewCellBG release];
        imgViewCellBG=nil;
        LblName.text=[NSString stringWithFormat:@"%@",[[CommentList objectAtIndex: indexPath.row] valueForKey:@"vUsername"]];
        LblDate.text=[NSString stringWithFormat:@"%@",[[CommentList objectAtIndex: indexPath.row] valueForKey:@"tCommentPostTime"]];
     
        UILabel* lblReview = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 260, 47)];
        [lblReview setNumberOfLines:0];
        [lblReview setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [lblReview setBackgroundColor:[UIColor clearColor]];
        
       // lblReview.textColor = [UIColor colorWithRed:61/255.0 green:81/255.0 blue:137/255.0 alpha:1.0];
         lblReview.textColor = [UIColor blackColor];

        NSString *Text=(NSString *)[[CommentList objectAtIndex:indexPath.row] valueForKey:@"tCommentText"];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [Text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        [lblReview setText:Text];
        [lblReview setFrame:CGRectMake(5,45 ,305, MAX(size.height,0))];
        
        [cell.contentView addSubview:lblReview];
                
        [lblReview release];
        lblReview=nil;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strDN =  [[[CommentList objectAtIndex:indexPath.row]valueForKey:@"tCommentText"]copy];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [strDN sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 0);
    
    return height + (CELL_CONTENT_MARGIN * 2)-35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark -UIAlertView

 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {   
        [self.navigationController popViewControllerAnimated:YES];
    }   
    
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (CommentList!=nil) {
        [CommentList removeAllObjects];
        CommentList=nil;
    }
    CommentList=[[NSMutableArray alloc] init];
    [self GetComment];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (CommentList!=nil) {
        [CommentList removeAllObjects];
        CommentList=nil;
    }
}
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
