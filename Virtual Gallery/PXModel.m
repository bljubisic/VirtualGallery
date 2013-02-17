//
//  PXModel.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 05/12/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "PXModel.h"
#import "ImageModel.h"

@implementation PXModel

@synthesize delegate;
@synthesize centralImages;
@synthesize fuzzyImages;

-(void) getRecentImages:(BOOL) forFuzzy {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [PXRequest requestForPhotoFeature:kPXAPIHelperDefaultFeature resultsPerPage:10 page:10 photoSizes:PXPhotoModelSizeSmallThumbnail | PXPhotoModelSizeLarge completion:^(NSDictionary *results, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (results)
        {
            [self setNewObjects:[results valueForKey:@"photos"] forFuzzy: forFuzzy];
        }
    }];
}

-(void) getSearchResultForCrit:(Criteria *)crit {
    
    NSString *term = crit.freeText;
    [PXRequest requestForSearchTerm:term completion:^(NSDictionary *results, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (results)
        {
            [self setNewObjects:[results valueForKey:@"photos"] forFuzzy: NO];
        }
    }];
}

-(void) setNewObjects:(NSArray *) results forFuzzy:(BOOL) forFuzzy{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< [results count]; i++) {
        NSDictionary *photo = (NSDictionary *) [results objectAtIndex:i];
        
        ImageObject *image = [[ImageObject alloc] initWithDataFromPX:photo];
        [returnArray addObject:image];
    }
    if(!forFuzzy) {
        if ([delegate respondsToSelector:@selector(pxResponseReceived:)]) {
            [delegate pxResponseReceived:returnArray];
        }
    }
    else {
        //NSLog(@"returning: %d", [returnArray count]);
        if([returnArray count] < 6)
            [self getRecentImages:YES];
        else {
            if ([delegate respondsToSelector:@selector(pxResponseReceivedFuzzy:)]) {
                [delegate pxResponseReceivedFuzzy:returnArray];
            }
        }
    }
}

-(void) getImageInfo:(NSString *)imageID forFuzzy:(BOOL) isFuzzy {
    
    NSInteger id = [imageID integerValue];
    //NSLog(@"px getting image info for %d", id);
    [PXRequest requestForPhotoID:id completion:^(NSDictionary *results, NSError *error) {
        //NSLog(@"px results is: %@", results);
        if (results)
        {
            NSDictionary *photo = [results valueForKey:@"photo"];
            if(isFuzzy) {
                if ([delegate respondsToSelector:@selector(pxResponseReceivedImageInfoForFuzzy:)]) {
                    [delegate pxResponseReceivedImageInfoForFuzzy:photo];
                }
            }
            else {
                if ([delegate respondsToSelector:@selector(pxResponseReceivedImageInfo:)]) {
                    [delegate pxResponseReceivedImageInfo:photo];
                }
            }
        }
    }];
}

-(void) getImageExif:(NSString *)imageID {
    
    NSInteger id = [imageID integerValue];
    //NSLog(@"px getting image exif for %d", id);
    [PXRequest requestForPhotoID:id completion:^(NSDictionary *results, NSError *error) {
        //NSLog(@"px results is: %@", results);
        if (results)
        {
            NSDictionary *photo = [results valueForKey:@"photo"];
            if ([delegate respondsToSelector:@selector(pxResponseReceivedImageInfoForFuzzy:)]) {
                [delegate pxResponseReceivedImageInfoExif:photo];
            }
        }
    }];
}

- (void) sendImage:(NSDictionary *) photo {
    if ([delegate respondsToSelector:@selector(pxResponseReceivedImageInfo:)]) {
        [delegate pxResponseReceivedImageInfo:photo];
    }
    
}

-(void) getFuzzyRelatedImagesFor:(NSArray *)tags {
    //NSLog(@"px getFuzzyRelatedImages");
    NSString *tagsString = [tags componentsJoinedByString:@","];

    [PXRequest requestForSearchTag:tagsString page:10 resultsPerPage:10 photoSizes:kPXAPIHelperDefaultPhotoSize completion:^(NSDictionary *results, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (results)
        {
            //NSLog(@"Exit getFuzzyRelatedImages px");
            [self setNewObjects:[results valueForKey:@"photos"] forFuzzy: YES];
        }
    }];
}

@end
