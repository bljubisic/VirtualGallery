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

- (void) flickrResponseReceived:(NSDictionary *) response;

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
}

@property (nonatomic, retain) NSMutableArray *centralImages;
@property (nonatomic, retain) NSMutableArray *fuzzyImages;
@property (retain) id delegate;

- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret;
- (BOOL) login:(NSString *) username withPass: (NSString *) password;
- (void) getRecentImages;
- (void) getFuzzyRelatedImagesFor:(NSArray *) tags;
- (void) getImageInfo:(NSDictionary *) image;
- (void) getSearchResultFor:(Criteria *) criteria;
- (BOOL) uploadImage: (ImageObject *) image;
- (void) flickrResponseReceived:(NSDictionary *) response;

@end
