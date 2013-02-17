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
    BOOL flickrReceived;
    BOOL preparedCentral;
    BOOL preparedFuzzy;
    ImageObject *tmpObject;
}

@synthesize delegate;

- (id) init {
    self = [super init];
    
    movedImage = nil;
    movedImageBool = NO;
    flickrModel = [[FlickrModel alloc] initWithAPIKey:@"78a1801bf9c641dd87aa8849e0c4c693" sharedSecret:@"ada295f6d089a2bf"];
    pxModel = [[PXModel alloc] init];
    
    movedOuterImage = NO;
    imageDetails = NO;
    flickrReceived = NO;
    
	[flickrModel setDelegate:self];
    [pxModel setDelegate:self];
    
    if(centralImages == nil)
        centralImages = [[NSMutableArray alloc] init];
    if(returnArray == nil)
        returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    preparedCentral = NO;
    preparedFuzzy = NO;
    
    return self;
}

- (void) getImagesWithCriteria:(Criteria *)crit {
    
    central = YES;
    fuzzy = NO;
    centralImages = [[NSMutableArray alloc] init];
    returnArray = [[NSMutableArray alloc] initWithCapacity:9];
    flickrReceived = NO;
    preparedCentral = NO;
    preparedFuzzy = NO;
    
    if(crit == nil) {
        [flickrModel getRecentImages:NO];
        [pxModel getRecentImages:NO];
    }
    else {
        [flickrModel getSearchResultFor:crit];
        [pxModel getSearchResultForCrit:crit];
    }
    
}

-(void) pxResponseReceived:(NSArray *)arrayResults {
    //[centralImages addObjectsFromArray:arrayResults];
    //NSLog(@"px central array received: %d", [arrayResults count]);
    [self randomizeImages: arrayResults];
}

-(void) receivedCentralFromFlickr:(NSArray *)arrayResults {
    if(!flickrReceived) {
        flickrReceived = YES;
        //NSLog(@"flickr received central images: %d", [arrayResults count]);
        //[centralImages addObjectsFromArray:arrayResults];
        [self randomizeImages: arrayResults];

    }
}


- (void) randomizeImages: (NSArray *) arrayResults {
    @synchronized(centralImages) {
        if(!preparedCentral) {
            //NSLog(@"randomizeImages: %d preparedImages", [arrayResults count]);
            preparedCentral = YES;
            //NSArray *tmpArray = [NSArray arrayWithArray:centralImages];
            centralImages = [[NSMutableArray alloc] initWithArray:[self shuffleArray:arrayResults]];
            if(movedImage) {
                ImageObject *tmpImg = [centralImages objectAtIndex:0];
                if(![movedImage isEqualTo: tmpImg])
                    [centralImages insertObject:movedImage atIndex:0];
                movedImage = nil;
                movedImageBool = NO;
            }
            ImageObject *tmpImage = (ImageObject *) [centralImages objectAtIndex:0];
            if([tmpImage.origin intValue] == 0)
                [flickrModel getImageInfoForFuzzy: tmpImage.imageID];
            else
                [pxModel getImageInfo:tmpImage.imageID forFuzzy:YES];
        }
        else {
            [centralImages addObjectsFromArray:arrayResults];
            //preparedCentral = NO;
        }
    }
}

-(void) pxResponseReceivedImageInfoForFuzzy:(NSDictionary *)response {
    NSArray *tag = [response objectForKey:@"tags"];
    
    fuzzyImages = [[NSMutableArray alloc] init];
    if([tag count] > 0) {
        [flickrModel getFuzzyRelatedImagesFor:tag];
        [pxModel getFuzzyRelatedImagesFor:tag];
    }
    else {
        [flickrModel getRecentImages:YES];
        [pxModel getRecentImages:YES];
    }
}

-(void) pxResponseReceivedImageInfoExif:(NSDictionary *)response {
    [tmpObject setCamera: response[@"camera"]];
    [tmpObject setExposure: response[@"shutter_speed"]];
    [tmpObject setAperture: response[@"aperture"]];
    [tmpObject setIso: response[@"iso"]];
    [tmpObject setTitle: response[@"name"]];
    [tmpObject setFocalLength: response[@"focal_length"]];
    if ([delegate respondsToSelector:@selector(imageInfoExifReceived:)]) {
        [delegate imageInfoExifReceived:tmpObject];
    }
}

-(void) receivedImageInfoForFuzzyForFlickr:(NSDictionary *)response {
    
    NSDictionary *tags = [response objectForKey:@"tags"];
    NSArray *tag = [tags objectForKey:@"tag"];
    NSMutableArray *tagsRaw = [[NSMutableArray alloc] init];
    int tagCount = [tag count];
    for(int i = 0; i < ((tagCount > 10)? 10 : tagCount); i++) {
        NSDictionary *tmpDict = (NSDictionary *) [tag objectAtIndex:i];
        [tagsRaw addObject:[tmpDict objectForKey:@"raw"]];
    }
    fuzzyImages = [[NSMutableArray alloc] init];
    if([tagsRaw count] > 0) {
        [flickrModel getFuzzyRelatedImagesFor:tagsRaw];
        [pxModel getFuzzyRelatedImagesFor:tagsRaw];
    }
    else {
        [flickrModel getRecentImages:YES];
        [pxModel getRecentImages:YES];
    }
    
}

-(void) receivedFuzzyFromFlickr:(NSArray *)arrayResults {
    //NSLog(@"flickr received fuzzy: %d", [arrayResults count]);
    //NSLog(movedImageBool? @"YES" : @"NO");
    if(movedImageBool) {
        //[centralImages addObjectsFromArray:arrayResults];
        [self randomizeImages: arrayResults];
    }
    else {
        if([arrayResults count] == 0)
            [flickrModel getRecentImages:YES];
        else {
            [fuzzyImages addObjectsFromArray:arrayResults];
            [self prepareImages];
        }
    }
}

-(void) pxResponseReceivedFuzzy:(NSArray *)arrayResults {
    //NSLog(@"flickr received fuzzy: %d", [arrayResults count]);
    if(movedImageBool) {
       // [centralImages addObjectsFromArray:arrayResults];
        [self randomizeImages: arrayResults];
    }
    else {
        [fuzzyImages addObjectsFromArray:arrayResults];
        [self prepareImages];
    }
}

-(void) prepareImages {
    //NSLog(@"prepareImages: %d preparedFuzzy", [fuzzyImages count]);
    @synchronized(fuzzyImages) {
        if(!preparedFuzzy && [fuzzyImages count] >= 6) {
            
            preparedFuzzy = YES;
            NSArray *tmpFuzzy = [self shuffleArray:fuzzyImages];
            fuzzyImages = [NSMutableArray arrayWithArray:tmpFuzzy];
        
            if(returnArray == nil || [returnArray count] == 0) {
                NSArray *tmpArray = [NSArray arrayWithArray:centralImages];
                NSArray *tmpCentral = [self processCentral:tmpArray];
                returnArray = [NSMutableArray arrayWithArray:tmpCentral];
            }
            for(int i = 0; i < 3; i++)
                [returnArray insertObject:[fuzzyImages objectAtIndex:i] atIndex:i];
            for(int i = 3; i < 6; i++)
                [returnArray addObject:[fuzzyImages objectAtIndex:i]];
            if(movedImage != nil) {
                movedImage = nil;
                movedImageBool = NO;
            }
            NSArray *sentArray = [NSArray arrayWithArray:returnArray];
            //returnArray = nil;
            //NSLog(@"prepareImages finished");
            if ([delegate respondsToSelector:@selector(loadFinished:)]) {
                [delegate loadFinished:sentArray];
            }
        }
    }
}

- (NSArray*) shuffleArray:(NSArray*)array {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
}


- (NSArray *) processCentral: (NSArray *) tmpArray {
    NSMutableArray *tmpCentralArray = [[NSMutableArray alloc] init];
    [tmpCentralArray addObject:[tmpArray lastObject]];
    for(int i = 0; i < ([tmpArray count] -1); i++) {
        [tmpCentralArray addObject:[tmpArray objectAtIndex:i]];
    }
    centralImages = [NSMutableArray arrayWithArray:tmpCentralArray];
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
    preparedFuzzy = NO;
    ImageObject *tmpImage = [returnArray objectAtIndex:1];
    if([tmpImage.origin intValue] == 0)
        [flickrModel getImageInfoForFuzzy: tmpImage.imageID];
    else
        [pxModel getImageInfo:tmpImage.imageID forFuzzy:YES];
}

-(void) moveOuterImageFromPosition:(int) position {
    movedImage = [returnArray objectAtIndex:position];
    returnArray = [[NSMutableArray alloc] init];
    movedOuterImage = YES;
    centralImages = [[NSMutableArray alloc] init];
    flickrReceived = NO;
    preparedCentral = NO;
    preparedFuzzy = NO;
    movedImageBool = YES;
    if([movedImage.origin intValue] == 0)
        [flickrModel getImageInfoForFuzzy:movedImage.imageID];
    else
        [pxModel getImageInfo:movedImage.imageID forFuzzy:YES];
}
/*
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
        [flickrModel getRecentImages:NO];
}
*/
- (void) getImageInfo:(ImageObject *) image {

    imageDetails = YES;
    if([image.origin intValue] == 0)
        [flickrModel getImageInfo:image.imageID];
    else
        [pxModel getImageInfo:image.imageID forFuzzy:NO];
}

-(void) getImageExif:(ImageObject *) image {
    tmpObject = image;
    if([image.origin intValue] == 0)
        [flickrModel getImageExif: image.imageID];
    else
        [pxModel getImageExif:image.imageID];
}


- (void) flickrResponseReceivedImageInfo:(NSDictionary *) photo {
    if(imageDetails) {
        imageDetails = NO;
        ImageObject *tmpImage = [[ImageObject alloc] initWithDataFromFlickr:photo];
        tmpImage.title = photo[@"title"][@"_content"];
        if ([delegate respondsToSelector:@selector(imageInfoReceived:)]) {
            [delegate imageInfoReceived:tmpImage];
        }
    }
}

- (void) flickrResponseReceivedImageInfoForExif:(NSDictionary *) photo {
    NSString *camera = (NSString *) [photo objectForKey:@"camera"];
    [tmpObject setCamera:camera];
    NSArray *exif = (NSArray *) [photo objectForKey:@"exif"];
    for(int i = 0; i < [exif count]; i++) {
        NSDictionary *tmpDict = (NSDictionary *) [exif objectAtIndex:i];
        NSString *label = (NSString *) [tmpDict objectForKey:@"label"];
        NSString *value = (NSString *) tmpDict[@"raw"][@"_content"];
        if(label != nil && [label isEqualToString:@"Exposure"]) {
            [tmpObject setExposure:value];
        }
        else if(label != nil && [label isEqualToString:@"Aperture"]) {
            [tmpObject setAperture:value];
        }
        else if(label != nil && [label isEqualToString:@"ISO Speed"]) {
            [tmpObject setIso:value];
        }
        else if(label != nil && [label isEqualToString:@"Focal Length"]) {
            [tmpObject setFocalLength:value];
        }
    }
    if ([delegate respondsToSelector:@selector(imageInfoExifReceived:)]) {
        [delegate imageInfoExifReceived:tmpObject];
    }
}

- (void) pxResponseReceivedImageInfo:(NSDictionary *) photo {
    if(imageDetails) {
        imageDetails = NO;
        ImageObject *tmpImage = [[ImageObject alloc] initWithDataFromPX:photo];
        if ([delegate respondsToSelector:@selector(imageInfoReceived:)]) {
            [delegate imageInfoReceived:tmpImage];
        }
    }
}


- (void) addImages:(NSArray *)images toFlickrAccount:(NSString *)username {
    
}

- (void) addImages:(NSArray *)images to500pxAccount:(NSString *)username {
    
}

- (void) flickrError {
    NSLog(@"Error in Flickr");
}

@end
