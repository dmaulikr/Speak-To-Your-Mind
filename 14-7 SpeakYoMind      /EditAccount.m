//
//  EditAccount.m
//  SpeakYoMind
//
//  Created by apple apple on 7/12/12.
//  Copyright (c) 2012 koenxcell. All rights reserved.
//

#import "EditAccount.h"

@implementation EditAccount

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
#pragma mark - Validate Email
-(BOOL)validateEmail:(NSString *)Email
{	
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:Email];
}

-(IBAction)BrowseClicked:(id)sender
{
    
    NSLog(@"Photo Library");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        UIPiker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:UIPiker animated:YES];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"Photo Library Error");
        return;
    }
    
}
-(IBAction)TakeNewClicked:(id)sender
{
    NSLog(@"Camera");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIPiker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:UIPiker animated:YES];
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"Camera Not Available");
        return;
    }
}
#pragma mark - Image Piker Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [imgViewUser setImage:[editingInfo objectForKey:@"UIImagePickerControllerOriginalImage"] ];
    CGRect rect=CGRectMake(0,0,150,150);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imgViewUser.image=picture1;
    [self dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - IBAction Methods
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SelectArtist:(id)sender
{
    [self SelectArtist1:[sender tag]];
}
-(void)SelectArtist1:(int)sender
{
    FlagSelected=sender;
    [BtnArtist1 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist2 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist3 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist4 setBackgroundColor:[UIColor yellowColor]];
    [BtnArtist5 setBackgroundColor:[UIColor yellowColor]];
    
    if (StrType!=nil) {
        [StrType release];
        StrType=nil;
    }
    switch (sender) {
        case 0:{
            StrType=[[NSString alloc] initWithString:@"Rapper"];

            [BtnArtist1 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 1:{
            StrType=[[NSString alloc] initWithString:@"Singer"];
            [BtnArtist2 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 2:{
            StrType=[[NSString alloc] initWithString:@"Poet"];
            [BtnArtist3 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 3:{
            StrType=[[NSString alloc] initWithString:@"Mucisian"];
            [BtnArtist4 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
        case 4:{
            StrType=[[NSString alloc] initWithString:@"Other"];
            [BtnArtist5 setBackgroundColor:[UIColor lightGrayColor]];
        }
            break;
    }

}
-(IBAction)ChnagePassword:(id)sender
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.5];
    ViewChnagePassword.frame=CGRectMake(0, 0, ViewChnagePassword.frame.size.width, ViewChnagePassword.frame.size.height);
    [UIView commitAnimations];
}
-(IBAction)Change:(id)sender
{
    [txtCurrent resignFirstResponder];
    [txtNew resignFirstResponder];
    [txtConfirm resignFirstResponder];
    if ([txtCurrent.text length] == 0) {
        DisplayAlertWithTitle(@"Current Password Please.",@"Note");
        return;
    }
    else if ([txtNew.text length] == 0) {
        
        DisplayAlertWithTitle(@"Enter New Password Please.",@"Note");
        return;
    }
    else if ([txtConfirm.text length] == 0) {
        
        DisplayAlertWithTitle(@"Enter Confom Password Please.",@"Note");
        return;
    }
    else if ([txtConfirm.text isEqualToString: txtNew.text]==NO) {
        
        DisplayAlertWithTitle(@"Your Confirm Password and New Password Don't Match !!!",@"Note");
        return;
    }
    else
    {
        if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
            [[SpeakYoMindAppDelegate sharedInstance] doshowLoadingView];
            [self performSelectorInBackground:@selector(doChangePassword) withObject:nil];
        }
        else
        {
            DisplayAlertConnection;
            return;     
        } 
    }
}
- (void)doChangePassword
{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    NSString  *urlstring1 = [NSString stringWithFormat:@"%@changepassword/?iUserID=%@&oldPassword=%@&newPassword=%@",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],txtCurrent.text,txtNew.text];
    NSURL *url = [NSURL URLWithString:[urlstring1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * jsonRes = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSString * strlogin = [(NSString *)[jsonRes JSONValue] valueForKey:@"message"];
    
    if ([strlogin isEqualToString:@"SUCCESS"]) {
        
        [[SpeakYoMindAppDelegate sharedInstance] dohideLoadingView];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Password Changed Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag=11;
        [alertView show];
        [alertView release];

    }
    else
    {
        [[SpeakYoMindAppDelegate sharedInstance] dohideLoadingView];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Password Change Failed !!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }
    [pool release];
}


-(IBAction)Update:(id)sender
{
    
    if (![[SpeakYoMindAppDelegate sharedInstance]isconnectedToNetwork])
    {
        DisplayAlertConnection;
        return;
    }
    else
    {
        
        if (![[SpeakYoMindAppDelegate sharedInstance] validateEmail:txtEmail.text]) {
            DisplayAlertWithTitle(@"Please Enter Valid Email Address !!",@"Note");
            return;
        }

        else if ([txtUserName.text length]==0) {
            DisplayAlertWithTitle(@"Flll Up All Fields !!", @"Note")
            return;
        } 
        else
        {
            [[SpeakYoMindAppDelegate sharedInstance]showLoadingView];
            [self performSelectorInBackground:@selector(UpdateUser) withObject:nil ];
        }
    }
}
-(void)UpdateUser
{
    NSAutoreleasePool *Pool=[[NSAutoreleasePool alloc] init];
//    NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
//    NSString *strEmail    = [userInfo  objectForKey:@"txtEmail"];
//    NSString *strUserName = [userInfo objectForKey:@"txtUserName"];
//    NSString *strPassword = [userInfo objectForKey:@"txtPassword"];
     NSData* imgData = UIImagePNGRepresentation(imgViewUser.image);
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter11 = [[NSDateFormatter alloc] init];
    dateFormatter11.dateFormat = @"yyyyddMMhhmmss";
    
    NSString *strdate=[dateFormatter11 stringFromDate:now];
    
    [dateFormatter11 release];
    
    NSString *imgName = [NSString stringWithFormat:@"%@ImageTest",strdate];
   
    
    
    NSString  *urlstring = [NSString stringWithFormat:@"%@updateprofile/index.php/?iUserID=%@&vUsername=%@&vEmail=%@&@&vImage=%@&iArtistType=%d",kWebServiceURL,[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"],txtUserName.text,txtEmail.text,imgName,FlagSelected];
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
    
    NSMutableDictionary *dictRegister = [NSMutableDictionary dictionaryWithDictionary:[result JSONValue]];
    NSLog(@"%@",dictRegister);
    NSString *strMSG = [dictRegister valueForKey:@"message"] ;
    [[SpeakYoMindAppDelegate sharedInstance]dohideLoadingView];
   // strMSG = [self removeNull:strMSG];
    if ([strMSG isEqualToString:@"SUCCESS"]) 
    {
        NSUserDefaults *loginInfo=[NSUserDefaults standardUserDefaults];
        [loginInfo setValue: [NSString stringWithFormat:@"%d",FlagSelected] forKey:@"iArtistType"];

        [loginInfo setValue: StrType forKey:@"vArtistType"];
        [loginInfo setValue:[dictRegister valueForKey:@"imageUrl"] forKey:@"vImage"];
        [loginInfo setValue:[NSString stringWithFormat:@"%@",txtEmail.text] forKey:@"vEmail"];
        [loginInfo setValue:[NSString stringWithFormat:@"%@",txtUserName.text] forKey:@"vUserName"];
        
        [loginInfo synchronize];
        
        UIAlertView *alertSuccess = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Upadation Successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertSuccess.tag=10;
        [alertSuccess show];
        [alertSuccess release];
        
    }
    else
    {
        DisplayAlertWithTitle(@"Fail", @"Upadation Failed!!");
        return;
    }
    [Pool release];
}

-(IBAction)Back1:(id)sender;
{
    txtCurrent.text=@"";
    txtNew.text=@"";
    txtConfirm.text=@"";

    [txtCurrent resignFirstResponder];
    [txtNew resignFirstResponder];
    [txtConfirm resignFirstResponder];

    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.5];
    ViewChnagePassword.frame=CGRectMake(0, 480, ViewChnagePassword.frame.size.width, ViewChnagePassword.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:YES];   
        }
    }
    else if (alertView.tag==11)
    {
        if (buttonIndex==0)
        {
            [self Back1:(id)0];   
        }
    }
    
}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    FlagSelected=[[[NSUserDefaults standardUserDefaults] valueForKey:@"iArtistType"] intValue];
    self.title=@"Edit Account";
    
    UIPiker = [[UIImagePickerController alloc] init];
	UIPiker.allowsImageEditing = NO;
	UIPiker.delegate = self;
    self.view.backgroundColor = [UIColor clearColor];
    txtEmail.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"vEmail"];
    txtUserName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"vUserName"];
    imgViewUser.imageURL=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"vImage"]];
    [self SelectArtist1:FlagSelected];

    //[self DefaultSelect];
    

}
//-(void)DefaultSelect
//{
//    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"vArtistType"] lowercaseString] isEqualToString:@"rapper"]) {
//    }
//    else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"vArtistType"]lowercaseString] isEqualToString:@"singer"]) {
//        [self SelectArtist1:1];
//    }
//    else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"vArtistType"]lowercaseString] isEqualToString:@"poet"]) {
//        [self SelectArtist1:2];
//    }
//    else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"vArtistType"]lowercaseString] isEqualToString:@"musician"]) {
//        [self SelectArtist1:3];
//    }
//    else if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"vArtistType"]lowercaseString] isEqualToString:@"Other"]) {
//        [self SelectArtist1:4];
//    }
//    
//}

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
