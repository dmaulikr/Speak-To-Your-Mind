//
//  SignUp.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUp.h"

@implementation SignUp

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
    //self.navigationController.navigationBarHidden = NO;
    self.title=@"Sign Up";
    
    UIPiker = [[UIImagePickerController alloc] init];
	UIPiker.allowsImageEditing = NO;
	UIPiker.delegate = self;
    
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"btnEdit.png"] forState:UIControlStateNormal];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame=CGRectMake(0,0, 52, 29); 
    [button addTarget:self action:@selector(DoneClicked:) forControlEvents:UIControlEventTouchUpInside];

     
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithCustomView:button];
    */

    self.view.backgroundColor = [UIColor clearColor];
    txtEmail.text=@"a@a.com";
    txtUserName.text=@"a";
    txtPassword.text=@"a";
    
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
-(IBAction)NextClicked:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtUserName resignFirstResponder];
    [txtPassword resignFirstResponder];
    if (![self validateEmail:txtEmail.text] ) 
    {
        DisplayAlertWithTitle(@"Note", @"Please Enter Valid Email");
        return;
    }
    else if([txtUserName.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""])
    {
        DisplayAlertWithTitle(@"Note", @"Please Enter Username or Password");
        return;
    }
    else
    {
    
        NSUserDefaults *userInfo =[NSUserDefaults standardUserDefaults];
        [userInfo setValue:txtEmail.text forKey:@"txtEmail"];
        [userInfo setValue:txtUserName.text forKey:@"txtUserName"];
        [userInfo setValue:txtPassword.text forKey:@"txtPassword"];
       
        [userInfo setObject:UIImagePNGRepresentation(imgViewUser.image) forKey:@"imgViewUser"];
        
       // [userInfo setObject:imgViewUser.image forKey:@"imgViewUser"];
        [userInfo synchronize];
       
        SignUp2 *objSignUp2=[[SignUp2 alloc]initWithNibName:@"SignUp2" bundle:nil];
        [self.navigationController pushViewController:objSignUp2 animated:YES];
        [objSignUp2 release];
    }

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
#pragma mark - Dealloc
-(void)dealloc
{
    
    [txtEmail release];
    [txtUserName release];
    [txtPassword release];
    
    [imgViewUser release];
    
    [super dealloc];
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Extra
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
