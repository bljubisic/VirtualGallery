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
    BOOL movedOuterImage;
    BOOL imageDetails;
}

@synthesize delegate;

- (id) init {
    self = [super init];
    
    movedImage = nil;
    
    flickrModel = [[FlickrModel alloc] initWithAPIKey:@"78a1801bf9c641dd87aa8849e0c4c693" sharedSecret:@"ada295f6d089a2bf"];
    movedOuterImage = NO;
    imageDetails = NO;
    
	[flickrModel setDelegate:self];
    
    if(centralImages == nil)
        centralImages = [[NSMutableArray alloc] init];
    if(returnArray == nil)
        returnArray = [[NSMutableArray alloc] initWithCapacity:9];

    return self;
}

- (void) getImagesWithCriteria:(Criteria *)crit {
    
    central = YES;
    fuzzy = NO;
    centralImages = [[NSMutableArray alloc] init];
    returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    if(crit == nil)
        [flickrModel getRecentImages];
    else
        [flickrModel getSearchResultFor:crit];
        
}


- (void) flickrResponseReceived:(NSDictionary *)inResponseDictionary {
    
    if([inResponseDictionary objectForKey:@"photos"]) {
        NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:[inResponseDictionary valueForKeyPath:@"photos.photo"]];
        if(movedImage) {
            NSDictionary *tmpDict = [photos objectAtIndex:0];
            if(![movedImage isEqualToDictionary:tmpDict])
                [photos insertObject:movedImage atIndex:0];
            movedImage = nil;
        }
        if([photos count] > 0)
            [self processImages: photos];
        else
            [flickrModel getRecentImages];
    }
    else if([inResponseDictionary objectForKey:@"photo"]) {
        NSDictionary *photo = [inResponseDictionary valueForKeyPath:@"photo"];
        if(imageDetails) {
            imageDetails = NO;
            if ([delegate respondsToSelector:@selector(imageInfoReceived:)]) {
                [delegate imageInfoReceived:photo];
            }
        }
        else if(movedOuterImage)
            [self fillCentralRowWithImage:photo];
        else
            [self processImage:(NSDictionary *) photo];
    }

}

- (void) processImage: (NSDictionary *) photo {

    NSDictionary *tags = [photo objectForKey:@"tags"];
    NSArray *tag = [tags objectForKey:@"tag"];
    NSMutableArray *tagsRaw = [[NSMutableArray alloc] init];
    int tagCount = [tag count];
    for(int i = 0; i < ((tagCount > 10)? 10 : tagCount); i++) {
        NSDictionary *tmpDict = (NSDictionary *) [tag objectAtIndex:i];
        [tagsRaw addObject:[tmpDict objectForKey:@"raw"]];
    }
    if([tagsRaw count] > 0)
        [flickrModel getFuzzyRelatedImagesFor:tagsRaw];
    else
        [flickrModel getRecentImages];
    
}


- (void) processImages: (NSArray *) tmpArray {

    NSArray *partCentralImages;
    if(central == YES) {
        partCentralImages = [self processCentral: tmpArray];
        for(int i = 0; i < 3; i++)
            [returnArray addObject:[partCentralImages objectAtIndex:i]];
        central = NO;
        [flickrModel getImageInfo: (NSDictionary *) [returnArray objectAtIndex:1]];
    }
    else {
        for(int i = 0; i < 3; i++)
            [returnArray insertObject:[tmpArray objectAtIndex:i] atIndex:i];
        for(int i = 3; i < 6; i++)
            [returnArray addObject:[tmpArray objectAtIndex:i]];
        // add delegate call on main controller
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadFinished" object:[[NSArray alloc] initWithArray:returnArray]];
    }
    
}

- (NSArray *) processCentral: (NSArray *) tmpArray {
    
    [centralImages addObject:[tmpArray lastObject]];
    for(int i = 0; i < ([tmpArray count] -1); i++) {
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


-(void) moveCentralImageWithIndex: (int) changeIndex {
    
    returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    int count = 0;
    int changeFactor = changeIndex;
    while (count < 3) {
        if(changeFactor < 0) {
            changeFactor = [centralImages count] + changeFactor;
        }
        if(changeFactor > ([centralImages count] - 1)) {
            changeFactor = 0 + (changeFactor - [centralImages count] );
        }
        [returnArray addObject:[centralImages objectAtIndex:changeFactor]];
        changeFactor++;
        count++;
    }
    central = NO;
    [flickrModel getImageInfo: (NSDictionary *) [returnArray objectAtIndex:1]];
}

-(void) moveOuterImageFromPosition:(int) position {
    movedImage = [returnArray objectAtIndex:position];
    movedOuterImage = YES;
    [flickrModel getImageInfo:movedImage];
}

-(void) fillCentralRowWithImage:(NSDictionary *) imageInfo {
    
    movedOuterImage = NO;
    central = YES;
    centralImages = [[NSMutableArray alloc] init];
    returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    NSDictionary *tags = [imageInfo objectForKey:@"tags"];
    NSArray *tag = [tags objectForKey:@"tag"];
    if([tag count] > 0) {
        NSMutableArray *searchString = [[NSMutableArray alloc] init];
        for(int i = 0; i < [tag count]; i++) {
            NSDictionary *tmpDict = [tag objectAtIndex:i];
            [searchString addObject:[tmpDict objectForKey:@"raw"]];
        }
        Criteria *crit = [[Criteria alloc] initWithData:searchString];
    
        [flickrModel getSearchResultFor:crit];
    }
    else
        [flickrModel getRecentImages];
}

- (void) getImageInfo:(NSString *)imageID {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    
    [tmpDict setValue:imageID forKey:@"id"];
    imageDetails = YES;
    [flickrModel getImageInfo:tmpDict];
}
@end
