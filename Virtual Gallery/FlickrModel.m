//
//  FlickrModel.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 10/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "FlickrModel.h"

@implementation FlickrModel

@synthesize centralImages = _centralImages;
@synthesize fuzzyImages = _fuzzyImages;

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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Store incoming data into a string
    _centralImages = [[NSMutableArray alloc] init];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // Create a dictionary from the JSON string
    NSError *jsonError = nil;
    //id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"its an array!");
        NSArray *jsonArray = (NSArray *)jsonObject;
        NSLog(@"jsonArray - %@",jsonArray);
    }
    else {
        NSLog(@"its probably a dictionary");
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        NSLog(@"jsonDictionary - %@",jsonDictionary);
    }
    NSLog(@"Error parsing JSON: %@", jsonError);
    NSDictionary *results = (NSDictionary *)jsonObject;
    NSArray *photos;
    
    if([results objectForKey:@"photos"] == nil) {
        NSDictionary *photo = [results objectForKey:@"photo"];
        photos = [[NSArray alloc] initWithObjects:photo, nil];
    }
    else {
        // Build an array from the dictionary for easy access to each entry
        photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    }
    
    /*
    // Loop through each entry in the dictionary...
    for (NSDictionary *photo in photos)
    {
        ImageObject *image = [[ImageObject alloc] init];
        
        // Get title of the image
        NSString *title = [photo objectForKey:@"title"];
        NSString *author = [photo objectForKey: @"username"];
        // Save the title to the photo titles array
        
        // Build the URL to where the image is stored (see the Flickr API)
        // In the format http://farmX.static.flickr.com/server/id_secret.jpg
        // Notice the "_s" which requests a "small" image 75 x 75 pixels
        NSString *photoURLStringSmall =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        NSLog(@"photoURLString: %@", photoURLStringSmall);
        
        // The performance (scrolling) of the table will be much better if we
        // build an array of the image data here, and then add this data as
        // the cell.image value (see cellForRowAtIndexPath:)
        
        // Build and save the URL to the large image so we can zoom
        // in on the image if requested
        NSString *photoURLStringLarge =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg",
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        NSLog(@"photoURLsLareImage: %@\n\n", photoURLStringLarge);
        
        [image setTitle: title];
        [image setAuthor: author];
        //[image setDescription: description];
        [image setImageURLLarge: photoURLStringLarge];
        [image setImageURLSmall:photoURLStringSmall];
        [image setMoved: 0];
        //[image setTags: tags];
        //[image setYear: year];
        [_centralImages addObject:image];
    }
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"processImages" object:photos];
     
    
}
        

@end
