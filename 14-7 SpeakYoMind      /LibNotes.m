//
//  LibNotes.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LibNotes.h"

@implementation LibNotes

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
-(void)GetNote
{
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        [self performSelectorInBackground:@selector(GetNoteList) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
}
- (void)GetNoteList{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@notes/?iUserID=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];
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
    [NoteList removeAllObjects];
    
    if ([tempdic valueForKey:@"posts"]!=nil) {
        
        [NoteList setArray:[tempdic valueForKey:@"posts"]];
        NSLog(@"no of goals %d",[NoteList count]);
        
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
    NSLog(@"AirportList :%@",NoteList);
    
    [tblView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Notes";
    
    self.view.backgroundColor = [UIColor clearColor];
    tblView.backgroundColor=[UIColor clearColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (NoteList!=nil) {
        [NoteList removeAllObjects];
        NoteList=nil;
    }
    NoteList = [[NSMutableArray alloc] init];
    [self GetNote];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - IBAction Methods
-(IBAction)NewNote:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view bringSubviewToFront:viewCreateNote];
    viewCreateNote.frame = CGRectMake(0, 0, viewCreateNote.frame.size.width, viewCreateNote.frame.size.height);
    [UIView commitAnimations];

}
-(IBAction)CancelNote:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    viewCreateNote.frame = CGRectMake(0, 481, viewCreateNote.frame.size.width, viewCreateNote.frame.size.height);
    [self.view bringSubviewToFront:viewCreateNote];
    [UIView commitAnimations];
    
}
-(IBAction)SaveNote:(id)sender
{
    [txtTitle resignFirstResponder];
    [txtView resignFirstResponder];
    
    if(![[SpeakYoMindAppDelegate sharedInstance]isconnectedToNetwork]) 
    {
        DisplayAlertConnection;
        return;
    }
    else
    {

        if ([txtTitle.text length]==0)
        {
            DisplayAlertWithTitle(@"Note", @"Please Insert Title");
            return;
        }
        if ([txtView.text length]==0)
        {
            DisplayAlertWithTitle(@"Note", @"Please Insert Notes");
            return;
        }
        else
        {
            [[SpeakYoMindAppDelegate sharedInstance]doshowLoadingView];
            NSString  *urlstring1 = [NSString stringWithFormat:@"%@notes/add/?vNoteTitle=%@&vNote=%@&iUserID=%@",kWebServiceURL,txtTitle.text,txtView.text,
            [[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"]];            
            NSLog(@"%@",urlstring1);
            
            NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url1];
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request startSynchronous];  

        }
    }
}
//-(IBAction)Login:(id)sender
//{
//    [txtUserName resignFirstResponder];
//    [txtPassword resignFirstResponder];
//    
//    
//    if (![[SpeakYoMindAppDelegate sharedInstance]isconnectedToNetwork]) 
//    {
//        DisplayAlertConnection;
//        return;
//    }
//    else
//    {
//        if ([txtUserName.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
//        {
//            DisplayAlertWithTitle(@"Note", @"Please Enter Username or Password");
//            return;
//        }
//        else
//        {
//            
//            [[SpeakYoMindAppDelegate sharedInstance]doshowLoadingView];
//            NSString  *urlstring1 = [NSString stringWithFormat:@"%@login/?vUsername=%@&vPassword=%@",kWebServiceURL,txtUserName.text,txtPassword.text];            
//            NSLog(@"%@",urlstring1);
//            
//            NSURL *url1 = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            
//            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url1];
//            [request setRequestMethod:@"POST"];
//            [request setDelegate:self];
//            [request startSynchronous];  
//            
//        }
//    }
//}

#pragma mark - ASIHTTP Request
// CFNetwork, SystemConfiguration, MobileCoreServices, CoreGraphics and libz
- (void) requestStarted:(ASIHTTPRequest *) request 
{
    NSLog(@"request started...");
}
- (void) requestFinished:(ASIHTTPRequest *)request 
{
    
    NSString *responseString = [request responseString];
    
    NSLog(@"Response %d : %@", request.responseStatusCode, [request responseString]);
    
    NSMutableDictionary *dictRegister = [NSMutableDictionary dictionaryWithDictionary:[responseString JSONValue]];
    NSLog(@"%@",dictRegister);
    
    NSString *strMSG = [dictRegister valueForKey:@"message"];
    strMSG = [self removeNull:strMSG];
    
    [[SpeakYoMindAppDelegate sharedInstance]dohideLoadingView];
    
    
    if ([strMSG isEqualToString:@"SUCCESS"])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        
        viewCreateNote.frame = CGRectMake(0, 481, viewCreateNote.frame.size.width, viewCreateNote.frame.size.height);
        [self.view bringSubviewToFront:viewCreateNote];
        [UIView commitAnimations];
        [self GetNote];

    }
    else if([strMSG isEqualToString:@"NTTAKEN"])
    {
        DisplayAlertWithTitle(@"Fail", @"Note Title Already Exist !!");
        return;
    }
    else if([strMSG isEqualToString:@"ERROR"])
    {
        DisplayAlertWithTitle(@"Fail", @"Add Note Fail!!");
        return;
    }
    else
    {
        DisplayAlertWithTitle(@"Fail", @"Add Note Fail!!");
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
    return [NoteList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
       // [[NSBundle mainBundle]loadNibNamed:@"LibPieces_Cell" owner:self options:nil];
       // cell=myCell;
    }
    if ([NoteList count]>0) {
        
        UIImageView *imgViewCellBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellBG.png"]];
        cell.backgroundView=imgViewCellBG;
        
        cell.textLabel.text=[[NoteList objectAtIndex:indexPath.row] valueForKey:@"vNoteTitle"];
                             
        [imgViewCellBG release];

        }

       return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TextView Delegate

#pragma mark - Deallocs
-(void)viewWillDisappear:(BOOL)animated
{
    if (NoteList!=nil) {
        [NoteList removeAllObjects];
        NoteList=nil;
    }
}
-(void)dealloc
{
    [txtView release];
    [txtTitle release];
    [tblView release];
    [viewCreateNote release];
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
