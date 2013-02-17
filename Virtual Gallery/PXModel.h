//
//  PXModel.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 05/12/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ImageModel.h"
#import "Criteria.h"
#import <PXAPI/PXAPI.h>

@protocol PXModelDelegate <NSObject>

@optional

- (void) pxResponseReceived:(NSArray *) arrayResults;
- (void) pxResponseReceivedFuzzy:(NSArray *)arrayResults;
- (void) pxResponseReceivedImageInfo:(NSDictionary *) response;
- (void) pxResponseReceivedImageInfoForFuzzy:(NSDictionary *) response;
- (void) pxResponseReceivedImageInfoExif:(NSDictionary *) response;

@end

@interface PXModel : NSObject {
    id <PXModelDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *centralImages;
@property (nonatomic, retain) NSMutableArray *fuzzyImages;
@property (retain) id delegate;

- (void) getRecentImages:(BOOL) forFuzzy;
- (void) getImageInfo:(NSString *)imageID forFuzzy:(BOOL) isFuzzy;
- (void) getImagesWithSameCategory:(NSNumber *) category;
- (void) getFuzzyRelatedImagesFor:(NSArray *) tags;
- (void) getSearchResultForCrit:(Criteria *) crit;
- (void) getImageExif:(NSString *) imageID;

@end
