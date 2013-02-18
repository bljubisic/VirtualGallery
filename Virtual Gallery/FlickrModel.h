//
//  FlickrModel.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 10/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObject.h"
#import "Criteria.h"


@protocol FlickrModelDelegate <NSObject>

@optional

- (void) receivedCentralFromFlickr:(NSArray *) arrayResults;
- (void) receivedFuzzyFromFlickr:(NSArray *) arrayResults;
- (void) flickrResponseReceivedImageInfo:(NSDictionary *) response;
- (void) receivedImageInfoForFuzzyForFlickr:(NSDictionary *) response;
- (void) flickrResponseReceivedImageInfoForExif:(NSDictionary *)response;
- (void) flickrError;

@end

@interface FlickrModel : NSObject {
    id <FlickrModelDelegate> delegate;
    NSString *key;
    NSString *sharedSecret;
    NSString *authToken;
    
    NSString *RESTAPIEndpoint;
	NSString *photoSource;
	NSString *photoWebPageSource;
	NSString *authEndpoint;
    NSString *uploadEndpoint;
    
    NSString *oauthToken;
    NSString *oauthTokenSecret;
    NSURLConnection* connection;
}

@property (nonatomic, retain) NSMutableArray *centralImages;
@property (nonatomic, retain) NSMutableArray *fuzzyImages;
@property (retain) id delegate;

- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret;
- (void) getRecentImages:(BOOL) forFuzzy;
- (void) getFuzzyRelatedImagesFor:(NSArray *) tags;
- (void) getImageInfo:(NSString *) imageID;
- (void) getImageInfoForFuzzy:(NSString *)imageID;
- (void) getSearchResultFor:(Criteria *) criteria;
- (void) getImageExif: (NSString *) imageID;

@end
