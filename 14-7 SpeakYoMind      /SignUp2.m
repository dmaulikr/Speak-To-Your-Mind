//
//  SignUp2.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUp2.h"

@implementation SignUp2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
    }
    return self;
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Artist Type";
    self.view.backgroundColor = [UIColor clearColor];
    tblView.backgroundColor = [UIColor clearColor];
    objSpeakYoMindAppDelegate = (SpeakYoMindAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    arrArtistTitle = [[NSMutableArray alloc]initWithObjects:@"Rapper",@"Singer",@"Poet",@"Mucisian",@"Other", nil];

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
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)DoneClicked:(id)sender
{

    if (![[SpeakYoMindAppDelegate sharedInstance]isconnectedToNetwork])
    {
        DisplayAlertConnection;
        return;
    }
    else
    {
    
        if (int_ArtistType==0) 
        {
            DisplayAlertWithTitle(@"Note", @"Please Select Artist Type");
            return;
        }
        else
        {
            [self RegisterUser];
        }
    }
}
-(void)RegisterUser
{
    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
    NSString *strEmail    = [userInfo  objectForKey:@"txtEmail"];
    NSString *strUserName = [userInfo objectForKey:@"txtUserName"];
    NSString *strPassword = [userInfo objectForKey:@"txtPassword"];
    NSData* imgData = [userInfo objectForKey:@"imgViewUser"];
  
    
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter11 = [[NSDateFormatter alloc] init];
    dateFormatter11.dateFormat = @"yyyyddMMhhmmss";
    
    NSString *strdate=[dateFormatter11 stringFromDate:now];
    
    [dateFormatter11 release];
    
    NSString *imgName = [NSString stringWithFormat:@"%@ImageTest",strdate];
 //   NSData *imgData=UIImagePNGRepresentation(imgView.image);
    
    

        [[SpeakYoMindAppDelegate sharedInstance]doshowLoadingView];
//    1) vUsername
//    2) vEmail
//    3) vPassword
//    4) vImage
//    5) iArtistType
            
        NSString  *urlstring = [NSString stringWithFormat:@"%@register/?vUsername=%@&vEmail=%@&vPassword=%@&vImage=%@&iArtistType=%d",kWebServiceURL,strUserName,strEmail,strPassword,imgName,int_ArtistType];
        NSLog(@"URL >> %@",urlstring);   
        
        NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
       // NSLog(@"profileupdate url = %@",url);
        
        //===============================================        
        NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
        [postRequest setURL:url];
        [postRequest setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData  *body = [[NSMutableData alloc] init];
        [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
//        if (imgView.image!=Nil)
//        {//userfile
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vImage\"; filename=\"%@.png\"\r\n",imgName]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Add Image
        [body appendData:[NSData dataWithData:imgData]];
//        }
        
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postRequest setHTTPBody:body];
        
        NSURLResponse *response;
        NSError* error = nil;
        
        
        NSData* data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
        NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        
        [[SpeakYoMindAppDelegate sharedInstance]dohideLoadingView];
       

        NSMutableDictionary *dictRegister = [NSMutableDictionary dictionaryWithDictionary:[result JSONValue]];
        NSLog(@"%@",dictRegister);
        NSString *strMSG = [dictRegister valueForKey:@"message"] ;
        
        strMSG = [self removeNull:strMSG];
        if([strMSG isEqualToString:@""])
        {
            DisplayAlertWithTitle(@"Service Problem", @"No Data Found");
            return;
        
        }
        else if ([strMSG isEqualToString:@"SUCCESS"]) 
        {
            UIAlertView *alertSuccess = [[UIAlertView alloc]initWithTitle:@"Successfull" message:@"Register Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertSuccess.tag=10;
            [alertSuccess show];
            [alertSuccess release];
            
        }
        else if([strMSG isEqualToString:@"UNTAKEN"])
        {
            DisplayAlertWithTitle(@"Fail", @"Username Already Exist !!");
            return;
        
        }
        else if([strMSG isEqualToString:@"ENTAKEN"])
        {
            DisplayAlertWithTitle(@"Fail", @"Emailid Already Exist !!");
            return;
            
        }
        else if([strMSG isEqualToString:@"ERROR"])
        {
            DisplayAlertWithTitle(@"Fail", @"Register Failed!!");
            return;
            
        }
        else if([strMSG isEqualToString:@"IMGPROBLEM"])
        {
            DisplayAlertWithTitle(@"Fail", @"Image Not Update Successfull!!");
            return;
            
        }
        else
        {
            DisplayAlertWithTitle(@"Fail", @"Register Failed!!");
            return;
        }
}
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex==0)
        {
            NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
            [userInfo removeObjectForKey:@"txtEmail"];
            [userInfo removeObjectForKey:@"txtUserName"];
            [userInfo removeObjectForKey:@"txtPassword"];
            [userInfo removeObjectForKey:@"imgViewUser"];
            [userInfo synchronize];
            [self.navigationController popToRootViewControllerAnimated:YES];   
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
#pragma mark - TableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrArtistTitle count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *imgViewCellBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellBG.png"]];
    cell.backgroundView=imgViewCellBG;
    cell.textLabel.text=[arrArtistTitle objectAtIndex:indexPath.row];
    
    [imgViewCellBG release];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    strArtistType =[NSString stringWithFormat:@"%@", [arrArtistTitle objectAtIndex:indexPath.row]];
    int_ArtistType = indexPath.row+1;
}

#pragma mark - Dealloc
-(void)dealloc
{
    
    [arrArtistTitle release];
    [tblView release];
    [super dealloc];
}

#pragma mark - Extra

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
