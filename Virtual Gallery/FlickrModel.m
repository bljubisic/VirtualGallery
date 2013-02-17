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


@implementation FlickrModel {
    BOOL centralLine;
    BOOL fuzzyLine;
    BOOL imageInfoForFuzzy;
    BOOL imageInfoForExif;
    NSString *jsonString;
    NSMutableData *data;
}

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
    centralLine = NO;
    fuzzyLine = NO;
    imageInfoForFuzzy = NO;
    imageInfoForExif = NO;
    jsonString = [[NSString alloc] init];
    data = [[NSMutableData alloc] init];
    return self;
}

- (void) getRecentImages:(BOOL) forFuzzy {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&per_page=9&format=json&nojsoncallback=1", flickr_key];
    if(!forFuzzy) {
        centralLine = YES;
        fuzzyLine = NO;
    }
    else {
        centralLine = NO;
        fuzzyLine = YES;
    }
    //NSLog(@"URLString fuzzy recent: %@", urlString);
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    imageInfoForFuzzy = forFuzzy;
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
    centralLine = YES;
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];

    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) getFuzzyRelatedImagesFor:(NSArray *)tags {
    
    //NSLog(@"flickr getFuzzyRelatedImagesFor");
    NSArray *tmpTags;
    if([tags count] > 5)
        tmpTags = [tags subarrayWithRange:NSMakeRange(0, 5)];
    else
        tmpTags = [NSArray arrayWithArray:tags];
    
    NSString *tagsString = [tmpTags componentsJoinedByString:@","];
    tagsString = [tagsString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=6&format=json&nojsoncallback=1", flickr_key, tagsString];
    fuzzyLine = YES;
    //NSLog(@"URLString fuzzy: %@", urlString);
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"URL Fuzzy: %@", url);
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    //NSLog(@"flickr getFuzzyRelatedImages URL: %@", urlString);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) getImageInfoForFuzzy:(NSString *) imageID {
    
    //NSLog(@"flickr getting image info for: %@", imageID);
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", flickr_key, imageID];
    //NSLog(@"URLString fuzzy info: %@", urlString);
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    imageInfoForFuzzy = YES;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
- (void) getImageInfo:(NSString *) imageID {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", flickr_key, imageID];
    //NSLog(@"URLString normal: %@", urlString);
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    imageInfoForFuzzy = NO;
    // Setup and start async download
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void) getImageExif:(NSString *) imageID {
    
    NSString *const flickr_key = @"78a1801bf9c641dd87aa8849e0c4c693";
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.getExif&api_key=%@&photo_id=%@&format=json&nojsoncallback=1", flickr_key, imageID];
    //NSLog(@"URLString normal: %@", urlString);
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    imageInfoForExif = YES;
    // Setup and start async download
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataTmp
{
    // Store incoming data into a string
    _centralImages = [[NSMutableArray alloc] init];
    

    [data appendData:dataTmp];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *jsonStringTmp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByAppendingString:jsonStringTmp];
    
    // Create a dictionary from the JSON string
    NSError *jsonError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    
    NSDictionary *results = (NSDictionary *)jsonObject;
    data = [[NSMutableData alloc] init];
    //NSLog(@"error: %@", [jsonError debugDescription]);
    if(jsonError != nil) {
        NSLog(@"error: %@", [jsonError debugDescription]);
        if([delegate respondsToSelector:@selector(flickrError:)])
            [delegate flickrError];
    }
    //NSLog(@"json: %@", jsonString);
    if([results objectForKey:@"photos"]) {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        NSArray *tmpArray = [[results objectForKey:@"photos"] objectForKey:@"photo"];
        for(int i = 0; i < [tmpArray count]; i++) {
            NSDictionary *tmpPhoto = [tmpArray objectAtIndex:i];
            ImageObject *imgObject = [[ImageObject alloc] initWithDataFromFlickr:tmpPhoto];
            [returnArray addObject:imgObject];
        }
        if(centralLine) {
            centralLine = NO;
            //NSLog(@"exit getCentral flickr");
            if ([delegate respondsToSelector:@selector(receivedCentralFromFlickr:)]) {
                [delegate receivedCentralFromFlickr:returnArray];
            }
        }
        else if(fuzzyLine) {
            fuzzyLine = NO;
            //NSLog(@"exit getFuzzyImages flickr");
            if ([delegate respondsToSelector:@selector(receivedFuzzyFromFlickr:)]) {
                [delegate receivedFuzzyFromFlickr:returnArray];
            }
        }
    }
    else if([results objectForKey:@"photo"]) {
        NSDictionary *tmpPhoto = [results objectForKey:@"photo"];
        if(imageInfoForFuzzy) {
            imageInfoForFuzzy = NO;
            imageInfoForExif = NO;
            //NSLog(@"exit imageInfo fuzzy flickr");
            if ([delegate respondsToSelector:@selector(receivedImageInfoForFuzzyForFlickr:)]) {
                [delegate receivedImageInfoForFuzzyForFlickr:tmpPhoto];
            }
        }
        else if (imageInfoForExif){
            imageInfoForExif = NO;
            //NSLog(@"exit imageInfo fuzzy flickr for exif");
            if ([delegate respondsToSelector:@selector(flickrResponseReceivedImageInfo:)]) {
                [delegate flickrResponseReceivedImageInfoForExif:tmpPhoto];
            }
        }
        else {
            //NSLog(@"exit imageInfo fuzzy flickr for info");
            if ([delegate respondsToSelector:@selector(flickrResponseReceivedImageInfo:)]) {
                [delegate flickrResponseReceivedImageInfo:tmpPhoto];
            }
        }
    }
}



@end
