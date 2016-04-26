//
/*

    File: SpeakHereController.mm
Abstract: n/a
 Version: 2.4

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2009 Apple Inc. All Rights Reserved.


*/

#import "SpeakHereController.h"
//#import "PlayView.h"

@implementation SpeakHereController

@synthesize player;
@synthesize recorder;

@synthesize btn_record;
@synthesize btn_play;
@synthesize fileDescription;
@synthesize lvlMeter_in;
@synthesize playbackWasInterrupted;


char *OSTypeToStr(char *buf, OSType t)
{
	char *p = buf;
	char str[4], *q = str;
	*(UInt32 *)str = CFSwapInt32(t);
	for (int i = 0; i < 4; ++i) {
		if (isprint(*q) && *q != '\\')
			*p++ = *q++;
		else {
			sprintf(p, "\\x%02x", *q++);
			p += 4;
		}
	}
	*p = '\0';
	return buf;
}

-(void)setFileDescriptionForFormat: (CAStreamBasicDescription)format withName:(NSString*)name
{
	char buf[5];
	const char *dataFormat = OSTypeToStr(buf, format.mFormatID);
	NSString* description = [[NSString alloc] initWithFormat:@"(%d ch. %s @ %g Hz)", format.NumberChannels(), dataFormat, format.mSampleRate, nil];
	fileDescription.text = description;
	[description release];	
}

#pragma mark Playback routines

-(void)stopPlayQueue
{
	player->StopQueue();
	[lvlMeter_in setAq: nil];
	btn_record.enabled = YES;
}

-(void)pausePlayQueue
{
	player->PauseQueue();
	playbackWasPaused = YES;
}

- (void)stopRecord
{
    [lvlMeter_in setAq: nil];

	player->DisposeQueue(true);
    NSArray *dirPaths;
	NSString *docsDir;
//	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];

	recordFilePath = (CFStringRef)[docsDir stringByAppendingPathComponent:@"recordedFile.caf"];

	player->CreateQueueForFile(recordFilePath);

    btn_play.enabled = YES;
    btn_record.enabled = YES;	

}
- (void) doConvertCallback1: (NSTimer *)timer {

    NSArray *dirPaths;    
	NSString *docsDir;
	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
    
    NSString *resPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"recordedFile.caf"]];

	NSString *outFilename = @"Track.caf";
    
    NSString *tmpPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:outFilename]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath: tmpPath error:NULL];
        
    }
    
	NSData *resData = [NSData dataWithContentsOfFile:resPath];
    
    OSStatus err = [ExtAudioFileConvertUtil convertToCaff:resPath outPath:tmpPath numChannels:2];
    
	if (err) {
		NSString *errMsg = [NSString stringWithFormat:@"error converting to %@: %@",
							outFilename, [ExtAudioFileConvertUtil commonExtAudioResultCode:err]];
		NSAssert(FALSE, errMsg);
	}
    
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath];
	NSAssert(exists, @"audio file was not written");
    
	NSData *fileData1 = [NSData dataWithContentsOfFile:tmpPath];	
    
	NSLog(@"wrote audio file %@ of length %d",
          outFilename, [fileData1 length]);

    [self performSelector:@selector(doConvertCallback2:)];
}

- (void) doConvertCallback2: (NSTimer *)timer {

    NSArray *dirPaths;    
	NSString *docsDir;
	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
    
    NSString *resPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"BeatSound.caf"]];

	NSString *outFilename = @"Trake1.caf";

    NSString *tmpPath =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:outFilename]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath: tmpPath error:NULL];
        
    }
    
    
    
	NSData *resData = [NSData dataWithContentsOfFile:resPath];
	NSLog(@"resource audio file %@ of length %d", @"recordedFile", [resData length]);
        
    OSStatus err = [ExtAudioFileConvertUtil convertToCaff:resPath outPath:tmpPath numChannels:2];
    
	if (err) {
		NSString *errMsg = [NSString stringWithFormat:@"error converting to %@: %@",
							outFilename, [ExtAudioFileConvertUtil commonExtAudioResultCode:err]];
		NSAssert(FALSE, errMsg);
	}
    
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath];
	NSAssert(exists, @"audio file was not written");
    
	NSData *fileData1 = [NSData dataWithContentsOfFile:tmpPath];	
    
	NSLog(@"wrote audio file %@ of length %d",
          outFilename, [fileData1 length]);
    
    
    NSTimer *doAudioTimer = [NSTimer timerWithTimeInterval: 1.0
                                                    target: self
                                                  selector: @selector(doAudioCallback:)
                                                  userInfo: NULL
                                                   repeats: FALSE];
    
    [[NSRunLoop currentRunLoop] addTimer: doAudioTimer forMode: NSDefaultRunLoopMode];
}

- (void) doAudioCallback: (NSTimer *)timer {
	
    
    NSArray *dirPaths;    
	NSString *docsDir;
	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
    
    NSString *resName1 =[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"Track.caf"]];
    
    NSString *resPath1 =resName1;
	NSString *resPath2 = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"Trake1.caf"]];//[[NSBundle mainBundle] pathForResource:resName2 ofType:nil]; //
    
    NSLog(@"resPath2 %@",resPath2);
    
    NSURL *url = [NSURL fileURLWithPath:resPath1];
    NSData *urlData1 = [NSData dataWithContentsOfURL:url];
    
    double UD1,UD2;
    UD1=[urlData1 length];

    url = [NSURL fileURLWithPath:resPath2];
    NSData *urlData2 = [NSData dataWithContentsOfURL:url];
    UD2=[urlData2 length];
      

	NSString *tmpFilename = @"Lesson_Mix.caf";
	NSString *tmpPath = [docsDir stringByAppendingPathComponent:tmpFilename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath: tmpPath error:NULL];
        
    }

    
	OSStatus status;
    
	status = [PCMMixer mix:resPath1 file2:resPath2 mixfile:tmpPath];
    
	if (status == OSSTATUS_MIX_WOULD_CLIP && FlagPlay==0) 
    {
        NSLog(@"Not Gone");
	}
    else if (status != OSSTATUS_MIX_WOULD_CLIP && FlagPlay==0)
    {	
        if(FlagPlay==0)
        {
        NSLog(@"Gone");
        
		NSURL *url = [NSURL fileURLWithPath:tmpPath];
		//NSLog(@"URL>>?> %@",url);
        if (FlagSave==1) {
            if (DataAudio!=nil) {
                [DataAudio release];
                DataAudio=nil;
            }
            DataAudio = [[NSData alloc] initWithContentsOfURL:url];
        }
		
		//NSLog(@"wrote mix file of size %d : %@", [urlData length], tmpPath);

        [lvlMeter_in setAq: nil];
        player->DisposeQueue(true);
        
        
        NSArray *dirPaths;
        NSString *docsDir;
        //	
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        
        recordFilePath = (CFStringRef)[docsDir stringByAppendingPathComponent:@"Lesson_Mix.caf"];
    
        player->CreateQueueForFile(recordFilePath);
            FlagPlay=1;
        }

	}
    if (FlagSave==0) {
     
        if (FlagPlay==1) {
            if (player->IsRunning())
            {
                if (playbackWasPaused) {
                    OSStatus result = player->StartQueue(true);
                    if (result == noErr)
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
                }
                else
                    [self stopPlayQueue];
            }
            else
            {		
                OSStatus result = player->StartQueue(false);
                if (result == noErr)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
            }

        }
    }
    else
    {
        [self AddPeice];
        FlagSave=0;
    }
    
}
- (IBAction)SavePiece:(id)sender
{
    
    if ([TxtNamePiece.text length]==0) {
        DisplayAlertWithTitle(@"Note", @"Please Enter Piece Name !");
        return;
    }
    else
    {
        
        [TxtNamePiece resignFirstResponder];
        FlagSave=1;
        [self play:0];
    }
    
}



- (IBAction)play:(id)sender
{
    
    if([StrDeatURL length]!=0)
    {
        if (Flag_BeatSound==0) {
                FlagPlay=0;
           
        }
        else if (Flag_BeatSound==1) {
            if (FlagSave==1) {
                FlagPlay=0;
            }
            else
            {
                FlagPlay=1;
            }
        }

        if (FlagPlay==0) {
            Flag_BeatSound=1;
            [self performSelector:@selector(doConvertCallback1:)];

        }
        else if (FlagPlay==1) {
            if (player->IsRunning())
            {
                if (playbackWasPaused) {
                    OSStatus result = player->StartQueue(true);
                    if (result == noErr)
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
                }
                else
                    [self stopPlayQueue];
            }
            else
            {		
                OSStatus result = player->StartQueue(false);
                if (result == noErr)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:self];
            }
            
        }
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"Please Select Beat !");
    }


   }
- (IBAction)record:(id)sender
{
    FlagPlay=0;
	if (recorder->IsRunning()) // If we are currently recording, stop and save the file.
	{
        recorder->StopRecord();

        btn_record.enabled = NO;	
        [self stopRecord];

	}
	else // If we're not recording, start.
	{
		btn_play.enabled = NO;	
		
		// Set the button's state to "stop"
		//btn_record.title = @"Stop";
				
		// Start the recorder
		recorder->StartRecord(CFSTR("recordedFile.caf"));
		
		[self setFileDescriptionForFormat:recorder->DataFormat() withName:@"Recorded File"];
		
		// Hook the level meter up to the Audio Queue for the recorder
		[lvlMeter_in setAq: recorder->Queue()];
	}	
}

#pragma mark AudioSession listeners
void interruptionListener(	void *	inClientData,
							UInt32	inInterruptionState)
{
	SpeakHereController *THIS = (SpeakHereController*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
		if (THIS->recorder->IsRunning()) {
			[THIS stopRecord];
		}
		else if (THIS->player->IsRunning()) {
			//the queue will stop itself on an interruption, we just need to update the UI
			[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
			THIS->playbackWasInterrupted = YES;
		}
	}
	else if ((inInterruptionState == kAudioSessionEndInterruption) && THIS->playbackWasInterrupted)
	{
		// we were playing back when we were interrupted, so reset and resume now
		THIS->player->StartQueue(true);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueResumed" object:THIS];
		THIS->playbackWasInterrupted = NO;
	}
}

void propListener(	void *                  inClientData,
					AudioSessionPropertyID	inID,
					UInt32                  inDataSize,
					const void *            inData)
{
	SpeakHereController *THIS = (SpeakHereController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			/*CFStringRef oldRoute = (CFStringRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
			if (oldRoute)	
			{
				printf("old route:\n");
				CFShow(oldRoute);
			}
			else 
				printf("ERROR GETTING OLD AUDIO ROUTE!\n");
			
			CFStringRef newRoute;
			UInt32 size; size = sizeof(CFStringRef);
			OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute);
			if (error) printf("ERROR GETTING NEW AUDIO ROUTE! %d\n", error);
			else
			{
				printf("new route:\n");
				CFShow(newRoute);
			}*/

			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
			{			
				if (THIS->player->IsRunning()) {
					[THIS pausePlayQueue];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
				}		
			}

			// stop the queue if we had a non-policy route change
			if (THIS->recorder->IsRunning()) {
				[THIS stopRecord];
			}
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
			THIS->btn_record.enabled = (isAvailable > 0) ? YES : NO;
		}
	}
}
#pragma mark WebServices

-(void)AddPeice
{
    if ([[SpeakYoMindAppDelegate sharedInstance] isconnectedToNetwork]) {
        [[SpeakYoMindAppDelegate sharedInstance] showLoadingView];
        
        [self performSelectorInBackground:@selector(AddPeice1) withObject:nil];
    }
    else
    {
        DisplayAlertConnection;
        return;
    }  
}//Piece name ,Piece file, userid
- (void)AddPeice1{
    NSAutoreleasePool *pool =[ [NSAutoreleasePool alloc] init];
    
    NSString  *urlstring = [NSString stringWithFormat:[NSString stringWithFormat:@"%@piece/add/",kWebServiceURL]];
    NSLog(@"%@",urlstring);
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    
    //[request setPostValue:[NSString stringWithFormat:@"%@", TxtNamePiece.text] forKey:@"vPieceFileName"];
    [request setPostValue:[NSString stringWithFormat:@"%@", TxtNamePiece.text] forKey:@"vPieceName"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"iUserID"] forKey:@"iUserID"];
    //[request setPostValue:strLink forKey:@"text"];
    // [request setData: myData withFileName: @"Image.png" andContentType: @"image/png" forKey: @"userfile"];
  //  NSData *postData = [NSData dataWithContentsOfURL:url];
    //url is my audio url path of NSDocumentDirectory.
    [request addData:DataAudio withFileName:[NSString stringWithFormat:@"%@.caf",TxtNamePiece.text] andContentType:@"audio/caf" forKey:@"vPieceFileName"];
    
    [request setDelegate:self];
    [request startAsynchronous];

   [pool release];
}
-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"Request Started");
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@", request.responseStatusCode, [request responseString]);
    NSString *strMSG = [[[request responseString] JSONValue]valueForKey:@"message"];
    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
    if ([strMSG isEqualToString:@"SUCCESS"]) {
        TxtNamePiece.text=@"";
        //DisplayAlertWithTitle(@"Note", @"Piece SuccesFully Saved");
        UIAlertView *Alert=[[UIAlertView alloc] initWithTitle:@"Note" message:@"Piece SuccesFully Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [Alert show];
        [Alert release];
        //return;
        
    }
    else
    {
        DisplayAlertWithTitle(@"Note", @"Piece Save Failed !!");
        return;
    }    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[SpeakYoMindAppDelegate sharedInstance] hideLoadingView];
    DisplayAlertWithTitle(@"Note", @"Piece Save Failed !!");
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    

    NSNotification *notif = [NSNotification notificationWithName:@"pushIt" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
    
    }   
    
}

#pragma mark Initialization routines
- (void)awakeFromNib
{		
	// Allocate our singleton instance for the recorder & player object
	recorder = new AQRecorder();
	player = new AQPlayer();
		
	OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error) printf("ERROR INITIALIZING AUDIO SESSION! %ld\n", error);
	else 
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;	
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
									
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %ld\n", error);
		btn_record.enabled = (inputAvailable) ? YES : NO;
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %ld\n", error);

		error = AudioSessionSetActive(true); 
		if (error) printf("AudioSessionSetActive (true) failed");
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];

	UIColor *bgColor = [[UIColor alloc] initWithRed:.39 green:.44 blue:.57 alpha:.5];
	[lvlMeter_in setBackgroundColor:bgColor];
	[lvlMeter_in setBorderColor:bgColor];
	[bgColor release];
	
	// disable the play button since we have no recording to play yet
	btn_play.enabled = NO;
	playbackWasInterrupted = NO;
	playbackWasPaused = NO;
}

# pragma mark Notification routines
- (void)playbackQueueStopped:(NSNotification *)note
{
	//btn_play.title = @"Play";
	[lvlMeter_in setAq: nil];
	btn_record.enabled = YES;
}

- (void)playbackQueueResumed:(NSNotification *)note
{
//	btn_play.title = @"Stop";
	btn_record.enabled = NO;
	[lvlMeter_in setAq: player->Queue()];
}

#pragma mark Cleanup
- (void)dealloc
{
	[btn_record release];
	[btn_play release];
	[fileDescription release];
	[lvlMeter_in release];
	
	delete player;
	delete recorder;
	
	[super dealloc];
}

@end
