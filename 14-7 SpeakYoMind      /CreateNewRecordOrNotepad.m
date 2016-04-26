
//
//  CreateNewRecordOrNotepad.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateNewRecordOrNotepad.h"
#import "SpeakHereViewController.h"


@implementation CreateNewRecordOrNotepad
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


#pragma mark - View DidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPiece) name:@"pushIt" object:nil];
    
    self.title=@"Create New";
    self.view.backgroundColor = [UIColor clearColor];
    
    //TxtNote.
   // tblView.hidden=YES;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Scrollview1.contentSize=CGSizeMake(314, 268);
    self.view.frame=CGRectMake(0, 0, 320, 480);
    tblView.hidden=TRUE;
    ViewTableBG.hidden=TRUE;
    btnNext.hidden=TRUE;
    btnPrevious.hidden=TRUE;
    PageNo=1;
    LblPageno.text=[NSString stringWithFormat:@"Page %d",PageNo];
    TxtNote.text=@"";
    FlagPlay=0;
    if (PieceList!=nil) {
        [PieceList removeAllObjects];
        PieceList=nil;
    }
    PieceList=[[NSMutableArray alloc] init];
    if (NoteList!=nil) {
        [NoteList removeAllObjects];
        NoteList=nil;
    }
    NoteList=[[NSMutableArray alloc] init];

    [self GetPiece];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - IBAction Methods
- (IBAction)Next:(id)sender
{  
    if (PageNo<[NoteList count]) {
        btnNext.hidden=FALSE;
        btnPrevious.hidden=FALSE;

        PageNo++;
        LblPageno.text=[NSString stringWithFormat:@"Page %d",PageNo];
        TxtNote.text=[NSString stringWithFormat:@"%@",[NoteList objectAtIndex:PageNo-1]];
    }
    if(PageNo>=[NoteList count])
    {
        btnNext.hidden=TRUE;
        btnPrevious.hidden=FALSE;
    }

}
- (IBAction)Previous:(id)sender
{
    if (PageNo>[NoteList count]) {
        if ([TxtNote.text length]!=0) {
            [NoteList addObject:[NSString stringWithFormat:@"%@",TxtNote.text]];
        }
        
    }
    if (PageNo==1) {
        btnNext.hidden=FALSE;
        btnPrevious.hidden=TRUE;
    }
    else
    {
        btnNext.hidden=FALSE;
        btnPrevious.hidden=FALSE;
        if (PageNo>[NoteList count]) {
            if ([TxtNote.text length]==0) {
                btnNext.hidden=TRUE;

            }
            
        }
        PageNo--;
        LblPageno.text=[NSString stringWithFormat:@"Page %d",PageNo];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",[NoteList objectAtIndex:PageNo-1]]);
        TxtNote.text=[NSString stringWithFormat:@"%@",[NoteList objectAtIndex:PageNo-1]];
        if (PageNo==1) {
            btnNext.hidden=FALSE;
            btnPrevious.hidden=TRUE;
        }

    }
    
   
}
- (IBAction)Reset:(id)sender
{   
    btnNext.hidden=TRUE;
    btnPrevious.hidden=TRUE;
    PageNo=1;
    LblPageno.text=[NSString stringWithFormat:@"Page %d",PageNo];

    TxtNote.text=@"";

    if ([NoteList count]!=0) {
        [NoteList removeAllObjects];
    }
}
- (IBAction)NewPages:(id)sender
{
    btnNext.hidden=TRUE;
    btnPrevious.hidden=FALSE;
    [NoteList addObject:[NSString stringWithFormat:@"%@",TxtNote.text]];
    PageNo=[NoteList count]+1;
    LblPageno.text=[NSString stringWithFormat:@"Page %d",PageNo];
    TxtNote.text=@"";

}
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)Post:(id)sender
{


}
-(IBAction)NotePadClicked:(id)sender
{
    self.view.frame=CGRectMake(0, 0, 320, 480);

    TxtNote.hidden=FALSE;
    tblView.hidden=TRUE;
    ViewTableBG.hidden=TRUE;
    NoteView.hidden=FALSE;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view bringSubviewToFront:NoteView];
    NoteView.frame = CGRectMake(0, 248, NoteView.frame.size.width, NoteView.frame.size.height);
    [UIView commitAnimations];

}
- (IBAction)DownView:(id)sender
{
    self.view.frame=CGRectMake(0, 0, 320, 480);

    [TxtNote resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view bringSubviewToFront:NoteView];
    NoteView.frame = CGRectMake(0, 480, NoteView.frame.size.width, NoteView.frame.size.height);
    [UIView commitAnimations];
}
- (IBAction)MyLibarary:(id)sender
{
  //  tblView.hidden=NO;
    tblView.hidden=FALSE;
    ViewTableBG.hidden=FALSE;

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    tblView.hidden=TRUE;
    ViewTableBG.hidden=TRUE;
}
- (IBAction)Help:(id)sender
{
    InstructionView *objInstructionView=[[InstructionView alloc]initWithNibName:@"InstructionView" bundle:nil];
    [self.navigationController pushViewController:objInstructionView animated:YES];
    [objInstructionView release];
}
-(IBAction)BeatsClicked:(id)sender
{
    FlagBeats=0;
    Beats *objBeats=[[Beats alloc]initWithNibName:@"Beats" bundle:nil];
    [self.navigationController pushViewController:objBeats animated:YES];
    [objBeats release];
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
    
    if ([tempdic valueForKey:@"piece"]!=nil) {
        
        [PieceList setArray:[tempdic valueForKey:@"piece"]];
        
        //[tblView reloadData];
        
        //[self performSelectorOnMainThread:@selector(reloadtable) withObject:nil waitUntilDone:YES];
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
    return [PieceList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([PieceList count]!=0) {
        cell.textLabel.text=[NSString stringWithFormat:@"%@",[[PieceList objectAtIndex: indexPath.row] valueForKey:@"vPieceName"]];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewTableBG.hidden=TRUE;
    tblView.hidden=YES;

}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.view.frame=CGRectMake(0, 0, 320, 480);

    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.view.frame=CGRectMake(0, -100, 320, 480);

    [textField resignFirstResponder];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.view.frame=CGRectMake(0, -216, 320, 480);
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
       if (abs(textView.contentSize.height/textView.font.lineHeight)>=12) 
    {
        if(([text isEqualToString:@""] && [text length]==0))
        {
            return YES;
        }
        else
        {
            if (abs(textView.contentSize.height/textView.font.lineHeight)>=12 && [text isEqualToString:@"\n"]) {
                [textView resignFirstResponder];
                self.view.frame=CGRectMake(0, 0, 320, 480);

                return YES;
            }
            return NO;
        }
    }
    else
    {
        if (abs(textView.contentSize.height/textView.font.lineHeight)<12 && [text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            self.view.frame=CGRectMake(0, 0, 320, 480);

            return YES;
        }
    }

    return YES;
}

#pragma mark - Dealloc
-(void)viewWillDisappear:(BOOL)animated
{
    if (NoteList!=nil) {
        [NoteList removeAllObjects];
        NoteList=nil;
    }
}
-(void)dealloc
{
    //[btnNotepad release];
   // [tblView release];
    [super dealloc];
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
