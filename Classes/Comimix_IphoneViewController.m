//
//  Comimix_IphoneViewController.m
//  Comimix-Iphone
//
//  Created by Prabhjot on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Comimix_IphoneViewController.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"

@interface Comimix_IphoneViewController()
-(void)layoutForCurrentOrientation:(BOOL)animated;
-(void)createADBannerView;
@end

@implementation Comimix_IphoneViewController


@synthesize message;
@synthesize session = _session;
@synthesize postGradesButton = _postGradesButton;
@synthesize logoutButton = _logoutButton;
@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize posting = _posting;
@synthesize listData;
@synthesize itemsToDisplay;
@synthesize imageView, asynchImage;
@synthesize indicator;
@synthesize swipeLeftRecognizer,tapRecognizer;

@synthesize contentView,  banner;

NSInteger totalLinks,checkedItemCount,backCount;
NSArray *parsedItems;
NSArray *finalSplit ;
NSArray *splitonce;
NSString *urlAddress, *parserLink, *presentLink,  *nextLink,  *concat;
NSString *finalSplitString, *content ;
NSString *path;
NSString *imageURL;
NSMutableArray *linkStore;
NSMutableDictionary *item;
NSMutableData *receivedData;
NSData *myData;
NSURL *url;
UIImage  *previousImg, *nextImg, *presentImg, *checkImg;
UIScrollView *scroll;
NSTimer *countdownTimer;

int loadstatus,newImgReq,netConnection,timing,backStatus,comimixConnection,mailTo;
int tap,doubleTap;CGFloat imageHeight, connectTimes,currentPosition;

- (void)viewDidLoad {
	// NSLog(@" In ViewDidLoad");
	[super viewDidLoad];
	presentImg=[UIImage imageNamed:@"Loading.png"];
	[indicator startAnimating];

	if(banner == nil)
    {
        [self createADBannerView];
    }
    [self layoutForCurrentOrientation:NO];
	
	tap=0;
	timing=1;
	doubleTap=0;
	newImgReq=1;
	backStatus=0;
	currentPosition=0;
	connectTimes=0;
	netConnection=0;
	comimixConnection=0;
	
	presentLink=@"http://4.bp.blogspot.com/_CHG2GRbeET8/SS3f-tcSNiI/AAAAAAAAJEk/qVdRYu1MLMs/s320/missing-715826.gif";
	nextLink=@"http://4.bp.blogspot.com/_CHG2GRbeET8/SS3f-tcSNiI/AAAAAAAAJEk/qVdRYu1MLMs/s320/missing-715826.gif";
	concat=@"http://";
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];						//Prabhjot-Allocating memory to parsedItems for storage
	self.itemsToDisplay = [NSArray array];
	
	
	/*
	 UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
	 swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	 swipeRight.delegate = self;
	 [imageView addGestureRecognizer:swipeRight];				//Prabhjot- Adding backward gesture
	 [swipeRight release];
	 
	 UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	 swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	 swipeLeft.delegate = self;
	 [imageView addGestureRecognizer:swipeLeft];				//Prabhjot- Adding forward gesture
	 [swipeLeft release];
	 */																//Old code for swipe
	
	//	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 45.0, 480.0, 320.0)];
	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];	
	asynchImage = [InternetImage alloc] ;
	linkStore=[[NSMutableArray alloc] initWithCapacity:11];
	
	static NSString* kApiKey = @"23a3d34e898393d9fa17e601827f1b4e";
	static NSString* kApiSecret = @"247011a96e0a721963c5a7f9a11b46d5";
	_session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];
	// Load a previous session from disk if available.  Note this will call session:didLogin if a valid session exists.
	[_session resume];
	
	
	
	url = [NSURL URLWithString:@"http://www.comimix.com/rotate6.php"];
	[self loadTheLink];
	//	content = [NSString stringWithContentsOfURL:url];
	//	if (content!=NULL) {
	//		comimixConnection=1;
	//	}
	//	[self FetchLink];
	
	/*	 NSString *path = [[NSBundle mainBundle] pathForResource:@"tableData" ofType:@"plist"];
	 listData = [NSMutableArray arrayWithContentsOfFile:path];
	 NSMutableDictionary *item=[listData objectAtIndex:0];
	 NSString *urlString=[item objectForKey:@"text"];
	 a=[listData count];
	 links=[NSMutableArray array];
	 for (int i=0; i<a; i++) {
	 item=[listData objectAtIndex:i];
	 BOOL checked = [[item objectForKey:@"checked"] boolValue];
	 if (checked==YES) {
	 urlString=[item objectForKey:@"text"];
	 [links addObject:urlString];
	 }
	 
	 }
	 totalLinks=[links count];
	 
	 //	array=[[NSArray alloc] initWithObjects:@"http://24.media.tumblr.com/tumblr_l947d6RIRK1qz8z2ro1_500.png",@"http://24.media.tumblr.com/tumblr_l8qk55sqmA1qz8z2ro1_r1_500.png",@"http://30.media.tumblr.com/tumblr_l8hqllqWcz1qz8z2ro1_500.png",nil];
	 
	 //NSString *imageName	 = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"jpeg"];
	 int r=rand()%totalLinks;
	 urlAddress = [links objectAtIndex:r]; // Jasjit - change path to jpg here
	 //	NSString *urlAddress = [item objectForKey:@"text"]; // Jasjit - change path to jpg here
	 //Create a URL object.
	 
	 
	 //	feedParser = [[MWFeedParser alloc] initWithFeedURL:@"http://www.garfieldminusgarfield.net/rss"];
	 feedParser = [[MWFeedParser alloc] initWithFeedURL:urlAddress];
	 feedParser.delegate = self;
	 feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	 feedParser.connectionType = ConnectionTypeAsynchronously;
	 [feedParser parse];
	 */	
	
	/*
     Create and configure the four recognizers. Add each to the view as a gesture recognizer.
     */
	
	scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 33, 482, 256)];
	UIGestureRecognizer *recognizer;
	
    /*
     Create a tap recognizer and add it to the view.
     Keep a reference to the recognizer to test in gestureRecognizer:shouldReceiveTouch:.
     */
	recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self.view addGestureRecognizer:recognizer];
    self.tapRecognizer = (UITapGestureRecognizer *)recognizer;
    recognizer.delegate = self;
	[recognizer release];
    /*
     Create a swipe gesture recognizer to recognize right swipes (the default).
     We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
     */
	
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
	
    /*
     Create a swipe gesture recognizer to recognize left swipes.
     Keep a reference to the recognizer so that it can be added to and removed from the view in takeLeftSwipeRecognitionEnabledFrom:.
     Add the recognizer to the view if the segmented control shows that left swipe recognition is allowed.
     */
	recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)recognizer;
	[recognizer release];
	
    self.imageView = imageView;
    [self.view addSubview:imageView];	
	//	NSLog(@"ViewDidLoad Ended");
	
}
- (void)LoadUrl {
	// NSLog(@" In LoadUrl");	
	if (comimixConnection==1) {
		/*		url = [NSURL URLWithString:@"http://www.comimix.com/rotate6.php"];
		 imageURL = [NSString stringWithContentsOfURL:url];
		 imageURL = [concat stringByAppendingString:imageURL];
		 nextLink=imageURL;
		 [self downloadImageFromInternet:imageURL];
		 */	//Prabhjot-Synchronous code for Fetching the link
		[self loadTheLink];
		
	}
	else
	{
		//Prabhjot-Synchromous code for downloading
		totalLinks=[parsedItems count];												//Prabhjot-Getting the total no of feeds
		if (totalLinks>0) {
			int linkIndex= arc4random()%totalLinks;								//Prabhjot-loading any random no
			urlAddress = [parsedItems objectAtIndex:linkIndex];					//Prabhjot-Getting the url of any random feed
			for (int i=0; i<totalLinks; i++) {
				[parsedItems removeObjectAtIndex:0];
			}
		}
		else {
			[self FetchLink];
		}
		
		
		//Prabhjot-fetching the imageUrl From the url description from Rss Feed
		@try {
			splitonce = [urlAddress  componentsSeparatedByString:@"src=\""];
			finalSplitString = [splitonce objectAtIndex:1];
			finalSplit = [finalSplitString  componentsSeparatedByString:@"\""];
			imageURL = [finalSplit objectAtIndex:0];
			imageURL = [imageURL stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]];
			// NSLog(@"%@", imageURL);	
			nextLink=imageURL;
			[self downloadImageFromInternet:imageURL];
		} 
		@catch (id theException) {
			// NSLog(@"%@", theException);
			[self FetchLink];
		}
	}
	// NSLog(@"Load Url Ended");
}
- (void)FetchLink {
	// // NSLog(@"In FetchLink");
	if (comimixConnection==1) {
		[self loadTheLink];
	}
	else
	{
		
		NSMutableArray *links=[[NSMutableArray alloc] init];									//Prabhjot-Allocating memory to links for storage;
		path = [[NSBundle mainBundle] pathForResource:@"tableData" ofType:@"plist"];
		listData = [NSMutableArray arrayWithContentsOfFile:path];
		item=[listData objectAtIndex:0];
		totalLinks=[listData count];
		for (int i=0; i<totalLinks; i++) {
			item=[listData objectAtIndex:i];
			parserLink=[item objectForKey:@"text"];
			[links addObject:parserLink];														//Prabhjot-Adding checked items to links array
		}
		checkedItemCount=[links count];
		int randomLinkNo= arc4random()%totalLinks;
		parserLink=[links objectAtIndex:randomLinkNo];											//Prabhjot-Getting any random link to parse
		
		
		/*		//------For Testing-------//
		 //	if (i<totalLinks) {
		 //		parserLink =[links objectAtIndex:i];
		 //		noOfTimes=noOfTimes+1;
		 //		if (noOfTimes==5) {
		 //			noOfTimes=0;
		 //			i=i+1;
		 //		}
		 //	}
		 //	// NSLog(@"the link no is %d",i);		
		 */		
		[links release];
		
		//	parserLink=@"http://www.toothpastefordinner.com/rss/rss.php";
		//Prabhjot-Calling the parser function
		feedParser = [[MWFeedParser alloc] initWithFeedURL:parserLink];
		feedParser.delegate = self;
		feedParser.feedParseType = ParseTypeFull;												// Prabhjot-Parse feed info and all items
		feedParser.connectionType = ConnectionTypeAsynchronously;
		[feedParser parse];
		[feedParser release];
	}
	// NSLog(@"FetchLink Ended");
}
- (IBAction) showComix {
	//	presentLink=nextLink;
	presentImg=nextImg;
	backCount=[linkStore count];
	if (backCount>10) {
		[linkStore removeObjectAtIndex:0];
	}
	scroll.zoomScale=1;
	[scroll removeFromSuperview];
	CGFloat wid=presentImg.size.width;
	CGFloat high=presentImg.size.height;
	CGFloat asp=high/wid;
	CGFloat newHeight=asp*482;
	imageHeight=newHeight;
	imageView.frame =CGRectMake(0.0, 0.0, 482.0, newHeight);
	[imageView setImage:presentImg];
	/*
	if (newHeight<256) {
		CGFloat space=(256-newHeight)/2;
		imageView.frame =CGRectMake(0.0, space, 480.0, newHeight);
	}
	else {
		imageView.frame =CGRectMake(0.0, 0.0, 480.0, newHeight);
	}
	
	scroll.frame=CGRectMake(0, 33, 480, 256);
	scroll.multipleTouchEnabled=YES;
	scroll.autoresizingMask=( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	scroll.scrollEnabled=YES;
	scroll.delegate=self;*/
	
	scroll.frame=CGRectMake(0, 33, 482, 256);
	CGRect innerFrame = imageView.frame;
	CGRect scrollerBounds = scroll.bounds;
	CGPoint myScrollViewOffset = CGPointMake( 0, 0);
	scroll.contentOffset = myScrollViewOffset;
	UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
	scroll.contentInset = anEdgeInset;
	
	
	if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
	{
		CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2 );
		CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2 );
		CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
		scroll.contentOffset = myScrollViewOffset;
		
	}
	
	if ( scrollerBounds.size.width > innerFrame.size.width )
	{
		anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
		anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
	}
	if ( scrollerBounds.size.height > innerFrame.size.height )
	{
		anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
		anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
	}
	scroll.contentInset = anEdgeInset;
	
	scroll.multipleTouchEnabled=NO;
	scroll.autoresizingMask=( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	scroll.scrollEnabled=YES;
	scroll.delegate=self;
	scroll.maximumZoomScale=4.00;
	scroll.minimumZoomScale=1.00;
	scroll.bounces = YES;
	scroll.backgroundColor = [UIColor clearColor];	
	scroll.contentMode = (UIViewContentModeScaleAspectFit);
	scroll.clipsToBounds=YES;
	scroll.contentSize=CGSizeMake(280, newHeight);
	scroll.userInteractionEnabled=TRUE;
	[scroll addSubview:imageView];
	[self.view addSubview:scroll];
	if (loadstatus==1) {
		presentLink=nextLink;
		[imageView setImage:nextImg];
		[indicator stopAnimating];
		loadstatus=0;
		newImgReq=0;
		tap=0;
		doubleTap=0;
		timing=0;
		if (backStatus==0) {
			
			[linkStore addObject:presentLink];
			[self FetchLink];
		}
	}
	else {
		newImgReq=1;
	}
	// NSLog(@"ShowComix Ended");
	
}

- (IBAction)Back {
	backStatus=1;
	//NSLog(@"Tap Backward");			
	[indicator startAnimating];
	backCount=[linkStore count];
	if (backCount>1) {
		currentPosition=[linkStore indexOfObject:presentLink];
		if (currentPosition==0) {
			timing=0;
			[indicator stopAnimating];
		}
		else {
			imageURL=[linkStore objectAtIndex:currentPosition-1];
			nextLink=imageURL;
			newImgReq=1;
			[self downloadImageFromInternet:imageURL];
		}
		
	}
	else {
		timing=0;
		[indicator stopAnimating];
	}
	
}
- (void) Forward {
	newImgReq=1;
	[indicator startAnimating];
	//NSLog(@"Tap Forward");
	newImgReq=1;
	backCount=[linkStore count];
	currentPosition=[linkStore indexOfObject:presentLink];
	if (currentPosition>=backCount-1) {
		//NSLog(@"In Current");
		if (backStatus==0) {
			backStatus=0;
			[self showComix];
		}
		else {
			backStatus=0;
			[self FetchLink];
		}
	}
	else {
		//NSLog(@"In else");
		backStatus=1;
		imageURL=[linkStore objectAtIndex:currentPosition+1];
		nextLink=imageURL;
		[self downloadImageFromInternet:imageURL];
	}
	
}

- (void) centreTapped {
	if (tap==0) {
		tap=1;
		scroll.zoomScale=1;
		[scroll removeFromSuperview];
		//		scroll.bounds.size.width=480;
		//		scroll.size.height=256;
		//		
		//	[self hrrr];
		CGFloat wid=presentImg.size.width;
		CGFloat high=presentImg.size.height;
		CGFloat asp=high/wid;
		CGFloat newHeight=asp*482;
		imageHeight=newHeight;
		NSLog(@"New Height %f",newHeight);
		imageView.frame =CGRectMake(0.0, 0.0,482, newHeight);
		scroll.frame=CGRectMake(0, 33, 482, 256);
		//		
		//		
		//		if (newHeight<256) {
		//			CGFloat space=(256-newHeight)/2;
		//			imageView.frame =CGRectMake(0.0, space, 952.0, newHeight);
		//		}
		//		else {
		//			imageView.frame =CGRectMake(0.0, 0.0, 952.0, newHeight);
		//		}
		//		
		[imageView setImage:presentImg];
		CGPoint myScrollViewOffset = CGPointMake( 0, 0);
		scroll.contentOffset = myScrollViewOffset;
		UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
		scroll.contentInset = anEdgeInset;
		
		CGRect innerFrame = imageView.frame;
		CGRect scrollerBounds = scroll.bounds;
		
		if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
		{
			CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2 );
			CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2 );
			CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
			scroll.contentOffset = myScrollViewOffset;
			
		}
		
		//		UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
		if ( scrollerBounds.size.width > innerFrame.size.width )
		{
			anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
			anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
		}
		if ( scrollerBounds.size.height > innerFrame.size.height )
		{
			anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
			anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
		}
		scroll.contentInset = anEdgeInset;
		
		
		
		
		scroll.multipleTouchEnabled=NO;
		scroll.autoresizingMask=( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		scroll.scrollEnabled=YES;
		scroll.delegate = self;
		scroll.bounces = YES;
		scroll.maximumZoomScale=2;
		scroll.minimumZoomScale=1;
		scroll.contentSize=CGSizeMake(482, newHeight);
		scroll.backgroundColor = [UIColor clearColor];	
		scroll.contentMode = (UIViewContentModeScaleAspectFit);
		scroll.clipsToBounds=YES;
		scroll.userInteractionEnabled=TRUE;
		[scroll addSubview:imageView];
		[self.view addSubview:scroll];
		scroll.zoomScale=2;
		
		
	}
	else {
		tap=0;
		scroll.zoomScale=1;
		[scroll removeFromSuperview];
		
		CGFloat wid=presentImg.size.width;
		CGFloat high=presentImg.size.height;
		CGFloat asp=high/wid;
		CGFloat newHeight=asp*482;
		imageHeight=newHeight;
		imageView.frame =CGRectMake(0.0, 0.0, 482.0, newHeight);
		[imageView setImage:presentImg];
		scroll.frame=CGRectMake(0, 33, 482, 256);
		CGRect innerFrame = imageView.frame;
		CGRect scrollerBounds = scroll.bounds;
		
		if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
		{
			CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2 );
			CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2 );
			CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
			scroll.contentOffset = myScrollViewOffset;
			
		}
		
		UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
		if ( scrollerBounds.size.width > innerFrame.size.width )
		{
			anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
			anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
		}
		if ( scrollerBounds.size.height > innerFrame.size.height )
		{
			anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
			anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
		}
		scroll.contentInset = anEdgeInset;
		
		
		scroll.multipleTouchEnabled=NO;
		scroll.autoresizingMask=( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		scroll.scrollEnabled=YES;
		scroll.delegate=self;
		scroll.bounces = YES;
		scroll.maximumZoomScale=4.00;
		scroll.minimumZoomScale=1.00;
		scroll.backgroundColor = [UIColor clearColor];	
		scroll.contentMode = (UIViewContentModeScaleAspectFit);
		scroll.clipsToBounds=YES;
		scroll.contentSize=CGSizeMake(280, newHeight);
		scroll.userInteractionEnabled=TRUE;
		[scroll addSubview:imageView];
		[self.view addSubview:scroll];
	}
	
}
- (void)scrollViewDidZoom:(UIScrollView *)pScrollView {
	//		imageView.frame =CGRectMake(0.0, 0.0, 480.0, imageHeight);
	//		NSLog(@"IN ViewForZooming");
	CGRect innerFrame = imageView.frame;
	CGRect scrollerBounds = pScrollView.bounds;
	
	if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
	{
		CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2 );
		CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2 );
		CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);
		
		pScrollView.contentOffset = myScrollViewOffset;
		
	}
	
	UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
	if ( scrollerBounds.size.width > innerFrame.size.width )
	{
		anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
		anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
	}
	if ( scrollerBounds.size.height > innerFrame.size.height )
	{
		anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
		anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
	}
	pScrollView.contentInset = anEdgeInset;
	
	
	
	
	
	
	
	//
	//	[scroll removeFromSuperview];
	////	imageView = [[UIImageView alloc]initWithImage:presentImg];
	//	CGFloat wid=presentImg.size.width;
	//	CGFloat high=presentImg.size.height;
	//	CGFloat asp=high/wid;
	//	CGFloat newHeight=asp*480;
	//	imageHeight=newHeight;
	//	
	//	[imageView setImage:presentImg];
	//	
	////	if (newHeight<256) {
	////		CGFloat space=(256-newHeight)/2;
	////		imageView.frame =CGRectMake(0.0, space, 480.0, newHeight);
	////	}
	////	else {
	//		imageView.frame =CGRectMake(0.0, 0.0, 480.0, newHeight);
	////	}
	//	
	//	[imageView setImage:presentImg];
	////	imageView.frame = [[UIScreen mainScreen] bounds];
	//	imageView.contentMode = (UIViewContentModeScaleAspectFit);
	//	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//	imageView.backgroundColor = [UIColor blackColor];
	//	// I'm setting the UIImageView size so it fills the screen first
	////	float ratio = presentImg.size.width/480;
	////	CGRect imageFrame = CGRectMake(0,0, 480, (presentImg.size.height/ratio));
	////	imageView.frame = imageFrame;
	////	//
	////	scroll.frame=GRectMAKE([[UIScreen mainScreen] applicationFrame]]);
	//	[scroll setContentSize: CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height)];
	//	scroll.frame=CGRectMake(0, 33, 480, 256);
	//	scroll.contentMode = (UIViewContentModeScaleAspectFit);
	//	scroll.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//	scroll.maximumZoomScale = 2.5;
	//	scroll.minimumZoomScale = 1;
	//	scroll.clipsToBounds = YES;
	//	scroll.delegate = self;
	//	[scroll addSubview:imageView];
	//	//imageView.center = scrollView.center; This is one of my many attempts, try this, the actual size of the scrollView's content view after the zoom gets a wrong height
	//
	////	[imageView release];
	//	[self.view addSubview:scroll];
	//
}
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
//NSLog(@"IN ViewForZooming");
    return imageView;
} 

- (IBAction)postGradesTapped:(id)sender {
	// NSLog(@"In postGradesTapped");
	_posting = YES;
	// If we're not logged in, log in first...
	if (![_session isConnected]) {
		self.loginDialog = nil;
		_loginDialog = [[FBLoginDialog alloc] init];	
		[_loginDialog show];	
	}
	// If we have a session and a name, post to the wall!
	else if (_facebookName != nil) {
		[self postToWall];
		
	}
	// Otherwise, we don't have a name yet, just wait for that to come through.
	// NSLog(@"postGrades Ended");
}
- (IBAction)logoutButtonTapped:(id)sender {
	[_session logout];
}
- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	// NSLog(@"in FBSession");
	[self getFacebookName];
	// NSLog(@"FBsession Ended");
}
- (void)session:(FBSession*)session willLogout:(FBUID)uid {
	_logoutButton.hidden = YES;
	_facebookName = nil;
}
- (void)getFacebookName {
	// NSLog(@"In GetFacebookName");
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", _session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	// NSLog(@"GetFacebookname Ended");
}
- (void)request:(FBRequest*)request didLoad:(id)result {
	// NSLog(@"In FBRequest");
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		self.facebookName = name;		
		_logoutButton.hidden = NO;
		[_logoutButton setTitle:[NSString stringWithFormat:@"Facebook: Logout as %@", name] forState:UIControlStateNormal];
		if (_posting) {
			[self postToWall];
			_posting = NO;
		}
	}
	// NSLog(@"FBRequest Ended");
}
- (void)postToWall {	
	FBStreamDialog* dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.userMessagePrompt = @"Enter your message:";
	dialog.attachment = [NSString stringWithFormat:@"{\"name\":\"%@ shared this Comic\",\"href\":\"http://www.comimix.com/\",\"caption\":\" \",\"description\":\"\",\"media\":[{\"type\":\"image\",\"src\":\"%@\",\"href\":\"%@\"}]}",
						 _facebookName, presentLink, presentLink];
	dialog.actionLinks = @"[{\"text\":\"Read a new comic!\",\"href\":\"http://www.comimix.com/\"}]";
	[dialog show];
	
}

- (void) downloadImageFromInternet:(NSString*) urlToImage {
	// NSLog(@"In DownloadFromInternet");
	// Create a instance of InternetImage
	if (backStatus==1) {
		[asynchImage abortDownload];
	}
	[asynchImage initWithUrl:urlToImage];
	
	// Start downloading the image with self as delegate receiver
	[asynchImage downloadImage:self];
	// NSLog(@"DownloadFromInternet Ended");
}
- (void) internetImageReady:(InternetImage*)downloadedImage {	
	checkImg=downloadedImage.Image;
	CGFloat checkImgWidth=checkImg.size.width;
	if (checkImgWidth>1) {
		nextImg = checkImg;
		netConnection=1;
		// NSLog(@"Image Downloaded");
		loadstatus=1;
		if (newImgReq==1) {
			[self showComix];
		}
	}
	else {
		backStatus=0;
		[self FetchLink];
	}
	
	// NSLog(@"InternetImageReady Ended");
	
	
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {		
		if(timing==0) {
			timing=1;
			[self Forward];
		}
    }
    else {
		if(timing==0) {
			timing=1;
			[self Back];
		}
	}
}
- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer {
//	NSLog(@"here");
	CGPoint location = [recognizer locationInView:self.view];
	if (location.x>380) {
		if(timing==0) {
			timing=1;
			[self Forward];
		}
	}
	if (location.x<95) {
		if(timing==0) {
			timing=1;
			[self Back];
		}
	}
	if ((location.x>95)&&(location.x<380)) {
		if (doubleTap==1) {
			doubleTap=0;
			[self centreTapped];
		}
	}
}
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((touch.view == toFriend) && (gestureRecognizer == tapRecognizer)) {
        return NO;
    }
	if ((touch.view == toComimix) && (gestureRecognizer == tapRecognizer)) {
        return NO;
    }
	if ((touch.view == _postGradesButton) && (gestureRecognizer == tapRecognizer)) {
        return NO;
    }
	if ((touch.view == save) && (gestureRecognizer == tapRecognizer)) {
        return NO;
    }
	if ((touch.view == banner) && (gestureRecognizer == tapRecognizer )) {
		return NO;
	}
	if ((touch.view==scroll)&&(gestureRecognizer==tapRecognizer) ){
		return NO;
	}
	if ([touch tapCount]==2) {
		doubleTap=1;
	}
    return YES;
}																	//Old swipe 

- (IBAction) mailtoFriend {
	mailTo=0;
	[self showPicker:toFriend];
}
- (IBAction) mailtoComimix {
	mailTo=1;
	[self showPicker:toComimix ];
}
- (IBAction) saveStrip {
	UIImageWriteToSavedPhotosAlbum(presentImg, nil, nil, nil);
}

- (void)feedParserDidStart:(MWFeedParser *)parser {
	// NSLog(@"Parsing: %@", parser.url);
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	// NSLog(@"Parsed Feed Info: “%@”", info.title);
	//	self.title = info.title;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	
	//	// NSLog(@"Parsed Feed Item Summary: “%@”", item.summary);
	//	// NSLog(@"Parsed Feed Item Link: “%@”", item.link);
	if (item) [parsedItems addObject:item.summary];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser {
	// NSLog(@"Finished Parsing");
	[self LoadUrl];
	//self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
	//					   [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
	//																			 ascending:NO] autorelease]]];
	//	self.tableView.userInteractionEnabled = YES;
	//	self.tableView.alpha = 1;
	//	[self.tableView reloadData];
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	
 	// NSLog(@"Finished Parsing With Error: %@", error);
	if (netConnection==0) {
		presentImg=[UIImage imageNamed:@"No_Internet.png"];
		[imageView setImage:presentImg];
		[indicator stopAnimating];
		
		
	}
	
	self.title = @"Failed";
	self.itemsToDisplay = [NSArray array];
	[parsedItems removeAllObjects];
	
	//	self.tableView.userInteractionEnabled = YES;
	//	self.tableView.alpha = 1;
	//	[self.tableView reloadData];
}

- (IBAction)showPicker:(id)sender  {
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	//NSLog(@"in picker");
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}
- (void)displayComposerSheet {
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	if (mailTo==0) {
		[picker setSubject:@" Watch this Comic!"];
		myData= UIImageJPEGRepresentation(presentImg, 1.0);	
		[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:@"rainy"];
		NSString *emailBody = @"Sent from <a href=www.comimix.com>Comimix</a>";
		[picker setMessageBody:emailBody isHTML:YES];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
	else {
		[picker setSubject:@"Feedback"];
		NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@comimix.com"]; 
		[picker setToRecipients:toRecipients];
		NSString *emailBody = @" ";
		[picker setMessageBody:emailBody isHTML:NO];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
	
	// Set up recipients
	//	NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@comimix.com"]; 
	//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
	//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	//	
	//	[picker setToRecipients:toRecipients];
	//	[picker setCcRecipients:ccRecipients];	
	//	[picker setBccRecipients:bccRecipients];
	//	
	//	// Attach an image to the email
	//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	//    NSData *myData = [NSData dataWithContentsOfFile:path];
	//	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	
	
	// Fill out the email body text
	//	NSString *emailBody = @"This comic strip is so amazing!";
	//	[picker setMessageBody:emailBody isHTML:NO];
	//	
	//	[self presentModalViewController:picker animated:YES];
	//    [picker release];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message.text = @"Result: failed";
			break;
		default:
			message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
- (void)launchMailAppOnDevice {
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=Shared by Comimix";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)loadTheLink {
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.comimix.com/rotate6.php"]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:10.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	if (netConnection==0) {
		comimixConnection=0;
		connectTimes=1;
		[self FetchLink];
	}
	if ((netConnection==1)&&(comimixConnection==1)) {
		[self loadTheLink];
	}
	if ((netConnection==0) &&(connectTimes==1)) {
		presentImg=[UIImage imageNamed:@"No_Internet.png"];
		[imageView setImage:presentImg];
		[indicator stopAnimating];
	}
    // inform the user
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
	if (netConnection==0) {
		comimixConnection=1;
	}
    // receivedData is declared as a method instance elsewhere
	//    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	NSString *returnValue = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
	imageURL = [concat stringByAppendingString:returnValue];
	nextLink=imageURL;
	[returnValue release];
	[self downloadImageFromInternet:imageURL];
	
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutForCurrentOrientation:NO];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutForCurrentOrientation:YES];
}
- (void)createADBannerView {
    // --- WARNING ---
    // If you are planning on creating banner views at runtime in order to support iOS targets that don't support the iAd framework
    // then you will need to modify this method to do runtime checks for the symbols provided by the iAd framework
    // and you will need to weaklink iAd.framework in your project's target settings.
    // See the iPad Programming Guide, Creating a Universal Application for more information.
    // http://developer.apple.com/iphone/library/documentation/general/conceptual/iPadProgrammingGuide/Introduction/Introduction.html
    // --- WARNING ---
	
    // Depending on our orientation when this method is called, we set our initial content size.
    // If you only support portrait or landscape orientations, then you can remove this check and
    // select either ADBannerContentSizeIdentifier320x50 (if portrait only) or ADBannerContentSizeIdentifier480x32 (if landscape only).
    NSString *contentSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? ADBannerContentSizeIdentifier320x50 : ADBannerContentSizeIdentifier480x32;
    
    // Calculate the intial location for the banner.
    // We want this banner to be at the bottom of the view controller, but placed
    // offscreen to ensure that the user won't see the banner until its ready.
    // We'll be informed when we have an ad to show because -bannerViewDidLoadAd: will be called.
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0, CGRectGetMaxY(self.view.bounds));
    
    // Now to create and configure the banner view
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    bannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set.
    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    [self.view addSubview:bannerView];
    self.banner = bannerView;
    [bannerView release];
}
- (void)layoutForCurrentOrientation:(BOOL)animated {
    CGFloat animationDuration = animated ? 0.2 : 0.0;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by half the banner height to get the final position
    CGPoint bannerCenter = CGPointMake(CGRectGetMidX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0;
    
    // First, setup the banner's content size and adjustment based on the current orientation
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
        bannerHeight = 32.0;
    }
    else
    {
        banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
        bannerHeight = 50.0;
    }
    
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if(banner.bannerLoaded)
    {
        contentFrame.size.height -= bannerHeight;
        bannerCenter.y -= bannerHeight / 2.0;
    }
    else
    {
        bannerCenter.y += bannerHeight / 2.0;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         contentView.frame = contentFrame;
                         [contentView layoutIfNeeded];
                         
                         banner.center = bannerCenter;
                     }];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutForCurrentOrientation:YES];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutForCurrentOrientation:YES];
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    // While the banner is visible, we don't need to tie up Core Location to track the user location
    // so we turn off the map's display of the user location. We'll turn it back on when the ad is dismissed.
	//   mapView.showsUserLocation = NO;
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    // Now that the banner is dismissed, we track the user's location again.
	//   mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//	if ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	//	{
	//		// NSLog(@"Landscape View");
	//		rotation=1;
	//		if (netConnection==1) {
	//			nextImg=presentImg;
	//			[self showComix];
	//		}
	//	
	//	}
	//	else
	//	{
	//		// NSLog(@"Potrait View");
	//		rotation=0;
	//		if (netConnection==1) {
	//			nextImg=presentImg;
	//			[self showComix];
	//		}
	//	}
	
	
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft );
	//			 interfaceOrientation == UIInterfaceOrientationPortrait ||
	//			 interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown );
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.postGradesButton = nil;
    self.logoutButton = nil;
	self.message = nil;
	self.swipeLeftRecognizer = nil;
	self.imageView = nil;
	self.tapRecognizer = nil;
	self.contentView = nil;
    banner.delegate = nil;
    self.banner = nil;
}
- (void)dealloc {
	[message release];
	[url dealloc];
	[receivedData dealloc];
	[content dealloc];
	[tapRecognizer release];
	[swipeLeftRecognizer release];
	[_session release];
	_session = nil;
	[_postGradesButton release];
	_postGradesButton = nil;
    [_logoutButton release];
	_logoutButton = nil;
    [_loginDialog release];
	_loginDialog = nil;
    [_facebookName release];
	_facebookName = nil;
	//Prabhjot-deallocating the memory
	[asynchImage abortDownload];
	// Then release.
	[asynchImage dealloc];
	[formatter dealloc];
	[imageView dealloc];
	[previousImg dealloc];
	[presentImg dealloc];
	[nextImg dealloc];
	[checkImg dealloc];
	[parsedItems dealloc];
	[urlAddress dealloc];
	[parserLink dealloc];
	[listData dealloc];
	[itemsToDisplay dealloc];
	[splitonce dealloc];
	[finalSplitString dealloc];
	[finalSplit dealloc] ;
	[imageURL dealloc];
	[item dealloc];
	[path dealloc];
	[scroll dealloc];
	[presentLink dealloc];
	[nextLink dealloc];
	[countdownTimer dealloc];
	[indicator dealloc];
	[asynchImage dealloc];
	[linkStore dealloc];
	[myData dealloc];
	[contentView release]; 
	contentView = nil;
    banner.delegate = nil;
    [banner release];
	banner = nil; 
	[super dealloc];
}

@end
