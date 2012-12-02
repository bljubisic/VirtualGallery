//
//  FlickrModel.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 10/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "FlickrModel.h"

#define kDefaultFlickrRESTAPIEndpoint		@"http://api.flickr.com/services/rest/"
#define kDefaultFlickrPhotoSource			@"http://static.flickr.com/"
#define kDefaultFlickrPhotoWebPageSource	@"http://www.flickr.com/photos/"
#define kDefaultFlickrAuthEndpoint			@"http://flickr.com/services/auth/"
#define kDefaultFlickrUploadEndpoint		@"http://api.flickr.com/services/upload/"


@implementation FlickrModel

@synthesize centralImages = _centralImages;
@synthesize fuzzyImages = _fuzzyImages;
@synthesize delegate;


- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret
{
    if ((self = [super init])) {
        key = [inKey copy];
        sharedSecret = [inSharedSecret copy];
        
        RESTAPIEndpoint = kDefaultFlickrRESTAPIEndpoint;
		photoSource = kDefaultFlickrPhotoSource;
		photoWebPageSource = kDefaultFlickrPhotoWebPageSource;
		authEndpoint = kDefaultFlickrAuthEndpoint;
        uploadEndpoint = kDefaultFlickrUploadEndpoint;
    }
    return self;
}

- (void) getRecentImages {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&per_page=9&format=json&nojsoncallback=1", flickr_key];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) getSearchResultFor:(Criteria *)criteria {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *freeText = [criteria.freeText stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *tags = [criteria.tags stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&tags=%@&per_page=9&format=json&nojsoncallback=1", flickr_key, freeText, tags];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) getFuzzyRelatedImagesFor:(NSArray *)tags {
    
    NSString *tagsString = [tags componentsJoinedByString:@","];
    tagsString = [tagsString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=6&format=json&nojsoncallback=1", flickr_key, tagsString];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"URL Fuzzy: %@", url);
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
- (void) getImageInfo:(NSDictionary *)image {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", flickr_key, image[@"id"]];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Store incoming data into a string
    _centralImages = [[NSMutableArray alloc] init];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
    NSError *jsonError = nil;
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    
    NSDictionary *results = (NSDictionary *)jsonObject;

    //NSLog(@"error: %@", [jsonError debugDescription]);
    //NSLog(@"json: %@", jsonString);
    
    if ([delegate respondsToSelector:@selector(flickrResponseReceived:)]) {
        [delegate flickrResponseReceived:results];
    }
 
}

        

@end
