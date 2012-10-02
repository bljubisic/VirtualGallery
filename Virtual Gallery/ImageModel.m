//
//  ImageModel.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 17/09/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel {
    BOOL central;
    BOOL fuzzy;

}

@synthesize centralImages;
@synthesize fuzzyImages;
@synthesize flickrModel;
@synthesize returnArray;

- (id) init {
    self = [super init];
    
    if(flickrModel == nil)
        flickrModel = [[FlickrModel alloc] init];
    if(centralImages == nil)
        centralImages = [[NSMutableArray alloc] init];
    if(returnArray == nil)
        returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    return self;
}

- (void) getImagesWithCriteria:(Criteria *)crit {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processImages:)
                                                 name:@"processImages"
                                               object:nil];
    central = YES;
    fuzzy = NO;
    if(crit == nil)
        [flickrModel getRecentImages];
        
}

- (void) processImages: (NSNotification *) notification {
    
    NSArray *tmpArray = (NSArray *) [notification object];
    NSArray *partCentralImages;
    if(central == YES) {
        partCentralImages = [self processCentral: tmpArray];
        for(int i = 0; i < 3; i++)
            [returnArray insertObject:[partCentralImages objectAtIndex:i] atIndex:i+3];
        central = NO;
        [self getFuzzyImagesForImage: (ImageObject *) [returnArray objectAtIndex:1]];
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"processImages" object:nil];
    }
    else 
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadFinished" object:[[NSArray alloc] initWithArray:returnArray]];
}

- (NSArray *) processCentral: (NSArray *) tmpArray {
    
    [centralImages addObject:[tmpArray lastObject]];
    for(int i = 1; i < [tmpArray count]; i++) {
        [centralImages addObject:[tmpArray objectAtIndex:i]];
    }
    return [centralImages subarrayWithRange:NSMakeRange(0, 3)];
}

- (void) centralFinished: (NSNotification *) notification {
    centralImages = [[NSMutableArray alloc] initWithArray:(NSArray *) [notification object]];
    
}

- (NSArray *) getCentralImages {
    NSRange theRange;
    
    theRange.location = 0;
    theRange.length = 3;
    
    NSArray *partCentralImages = [[NSArray alloc] initWithArray:[centralImages subarrayWithRange:theRange]];
    return partCentralImages;
}

- (void) getFuzzyImagesForImage:(ImageObject *)image {
    if(image.origin == 0) {
        
    }
    else {
        
    }
    
}


@end
