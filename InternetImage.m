//
//  Created by Björn Sållarp on 2008-09-03.
//  Copyright 2008 MightyLittle Industries. All rights reserved.
//
//  Read my blog @ http://jsus.is-a-geek.org/blog

#import "InternetImage.h"


@implementation InternetImage
NSURLRequest *imageRequest;
@synthesize ImageUrl, Image, workInProgress;
CGFloat expectedSize, downloadSize, percentageDownloaded;

-(id) initWithUrl:(NSString*)urlToImage
{	//NSLog(@"Image Url: %@",urlToImage);
	self = [super init];
	
	if(self)
	{
		self.ImageUrl = urlToImage;
	}
	
	return self;
}


- (void)setDelegate:(id)new_delegate
{
    m_Delegate = new_delegate;
}	

-(void)downloadImage:(id)delegate
{
	m_Delegate = delegate;
	
	imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:ImageUrl] 
											   cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
	imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
	
	if(imageConnection)
	{
		workInProgress = YES;
		m_ImageRequestData = [[NSMutableData data] retain];
	}
	[imageConnection release];
}

-(void)abortDownload
{
	if(workInProgress == YES)
	{
		[imageConnection cancel];
		[m_ImageRequestData release];
		workInProgress = NO;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	expectedSize=[response expectedContentLength];	
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [m_ImageRequestData setLength:0];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [m_ImageRequestData appendData:data];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the data object
    [m_ImageRequestData release];

    // inform the user
   // NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	if(workInProgress == YES)
	{
		workInProgress = NO;
		// Create the image with the downloaded data
		UIImage* downloadedImage = NULL;
		
		self.Image = downloadedImage;
		
		// release the data object
		[downloadedImage release];
		
		// Verify that our delegate responds to the InternetImageReady method
		if ([m_Delegate respondsToSelector:@selector(internetImageReady:)])
		{
			// Call the delegate method and pass ourselves along.
			[m_Delegate internetImageReady:self];
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if(workInProgress == YES)
	{
		workInProgress = NO;
		downloadSize=m_ImageRequestData.length;
		percentageDownloaded=downloadSize/expectedSize;
		if ((percentageDownloaded>.99) && (percentageDownloaded<1.01) ){
			// Create the image with the downloaded data
			UIImage* downloadedImage = [[UIImage alloc] initWithData:m_ImageRequestData];
			
			self.Image = downloadedImage;
			
			// release the data object
			[downloadedImage release];
			[m_ImageRequestData release];
			
			
			// Verify that our delegate responds to the InternetImageReady method
			if ([m_Delegate respondsToSelector:@selector(internetImageReady:)])
			{
				// Call the delegate method and pass ourselves along.
				[m_Delegate internetImageReady:self];
			}
		}
		else {
			[m_ImageRequestData release];
			UIImage* downloadedImage = NULL;
			
			self.Image = downloadedImage;
			
			// release the data object
			[downloadedImage release];
			
			// Verify that our delegate responds to the InternetImageReady method
			if ([m_Delegate respondsToSelector:@selector(internetImageReady:)])
			{
				// Call the delegate method and pass ourselves along.
				[m_Delegate internetImageReady:self];
			}
			//NSLog(@"Error detected");
		}

		}	
}


- (void)dealloc 
{
    [imageConnection release];
	[ImageUrl release];
	[Image release];
	[imageRequest release];
	[super dealloc];
}


@end
