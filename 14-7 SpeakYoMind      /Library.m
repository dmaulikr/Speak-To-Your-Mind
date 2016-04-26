//
//  Library.m
//  SpeakYoMind
//
//  Created by Vivek Rajput on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Library.h"

@implementation Library

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
    self.title = @"Library";
    self.view.backgroundColor = [UIColor clearColor];
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
-(IBAction)LibBeats:(id)sender
{
    FlagBeats=1;
    Beats *objBeats=[[Beats alloc]initWithNibName:@"Beats" bundle:nil];
    [self.navigationController pushViewController:objBeats animated:YES];
    [objBeats release];
}
-(IBAction)LibPieces:(id)sender
{
    LibPieces *objLibPieces=[[LibPieces alloc]initWithNibName:@"LibPieces" bundle:nil];
    [self.navigationController pushViewController:objLibPieces animated:YES];
    [objLibPieces release];
}
-(IBAction)LibNotes:(id)sender
{
    LibNotes *objLibNotes=[[LibNotes alloc]initWithNibName:@"LibNotes" bundle:nil];
    [self.navigationController pushViewController:objLibNotes animated:YES];
    [objLibNotes release];
}
-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Dealloc
-(void)dealloc
{
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
