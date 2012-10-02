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
//#import "SBJson.h"


@interface FlickrModel : NSObject

@property (nonatomic, retain) NSMutableArray *centralImages;
@property (nonatomic, retain) NSMutableArray *fuzzyImages;

- (BOOL) login:(NSString *) username withPass: (NSString *) password;
- (void) getRecentImages;
- (void) getFuzzyRelatedImagesFor:(ImageObject *) image;
- (void) getSearchResultFor:(Criteria *) criteria;
- (BOOL) uploadImage: (ImageObject *) image;

@end
