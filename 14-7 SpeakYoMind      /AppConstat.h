//
//  AppConstat.h
//  FM Host
//
//  Created by Surya on 12/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//#define kWebServiceUrl @"http://myabilita.com/ws_herematch/"
#define kWebServiceURL @"http://openxcellaus.info/speakyomind/webservice/"


#define kUserImageWSURl @"http://s3.amazonaws.com/tap-production/userphoto/thumbnail_large/"
#define kEventImageWSURl @"http://myabilita.com/ws_herematch/event_images/"
#define kLocationErrormsg @"Location Services must be turned on herematch to function correctly."

//#define kWebServiceUrl @"http://www.openxcellaus.info/herematch/"
// UIAlertView methods

//alert with only message
#define DisplayAlert(msg) { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}


//alert with message and title
#define DisplayAlertWithTitle(title,msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}


//alert with only localized message
#define DisplayLocalizedAlert(msg){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}


//alert with localized message and title
#define DisplayLocalizedAlertWithTitle(msg,title){UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title,@"") message:NSLocalizedString(msg,@"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alertView show]; [alertView autorelease];}


#define DisplayAlertConnection { UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please connect to internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alertView show]; [alertView release];}


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/256.0f green:(g)/256.0f blue:(b)/256.0f alpha:1.0f]

int FlagPlay,Flag_BeatSound,FlagBeats;
NSString *StrDeatURL,*IPieceId;
NSMutableArray *PieceList;




