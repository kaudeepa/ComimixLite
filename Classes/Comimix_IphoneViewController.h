//
//  Comimix_IphoneViewController.h
//  Comimix-Iphone
//
//  Created by Prabhjot on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "InternetImage.h"
#import "FBConnect.h"
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface Comimix_IphoneViewController : UIViewController  <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate> {
	
	IBOutlet UIImageView *imageView;
	IBOutlet UIActivityIndicatorView *indicator;
	
	NSMutableArray *listData;
	MWFeedParser *feedParser;
	InternetImage *asynchImage; 
	
	UISwipeGestureRecognizer *swipeLeftRecognizer;
	UITapGestureRecognizer *tapRecognizer;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	
	IBOutlet UILabel *message;
	
	FBSession * session;
	FBLoginDialog *_loginDialog;
	UIButton *_postGradesButton;
	UIButton *_logoutButton;
	NSString *_facebookName;
	UIButton *toComimix;
	UIButton *toFriend;
	UIButton *save;
	BOOL _posting;
	
	UIView *contentView;
//  MKMapView *mapView;
    ADBannerView *banner;
}

@property (nonatomic, retain) IBOutlet UIButton *toComimix;
@property (nonatomic, retain) IBOutlet UIButton *toFriend;
@property (nonatomic, retain) IBOutlet UIButton *save;
@property (nonatomic, retain) IBOutlet UIButton *postGradesButton;
@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) NSMutableArray *listData;
@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, readonly, getter=isZooming) BOOL zooming;
@property (nonatomic, retain) InternetImage *asynchImage;
@property (nonatomic, retain) FBSession *session;
@property (nonatomic, retain) FBLoginDialog *loginDialog;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, assign) BOOL posting;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
// After the interface
@property(nonatomic, retain) IBOutlet UIView *contentView;
//@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet ADBannerView *banner;

-(void) displayComposerSheet;
-(void) launchMailAppOnDevice;
-(void) downloadImageFromInternet:(NSString*) urlToImage;
-(void) internetImageReady:(InternetImage*)internetImage;
-(void) postToWall;
-(void) getFacebookName;

- (IBAction) showComix;
- (IBAction) Back;
- (IBAction) Forward;
- (IBAction) mailtoFriend;
- (IBAction) mailtoComimix;
- (IBAction) saveStrip;
- (IBAction) showInfo:(id)sender;
- (IBAction) postGradesTapped:(id)sender;
- (IBAction) logoutButtonTapped:(id)sender;
- (IBAction) showPicker ;

@end