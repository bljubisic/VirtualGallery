//
//  ImageModel.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 17/09/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObject.h"
#import "FlickrModel.h"
#import "PXModel.h"
#import "Criteria.h"

@protocol ImageModelDelegate <NSObject>

@optional

- (void) imageInfoReceived:(ImageObject *) photo;
- (void) loadFinished:(NSArray *) results;
- (void) imageInfoExifReceived:(ImageObject *) photo;

@end

@interface ImageModel : NSObject <FlickrModelDelegate, PXModelDelegate> {
    id <ImageModelDelegate> delegate;
    NSMutableArray *centralImages;
    NSMutableArray *fuzzyImages;
    NSMutableArray *returnArray;
    ImageObject *movedImage;
    BOOL movedImageBool;
    FlickrModel *flickrModel;
    PXModel *pxModel;
}

@property (retain) id delegate;

// This method will get back array of nine elements (to be displayed on screen)
// Every move of images on main view will call this method to get new images
// This can be done either through web interface or from cache
-(void) getImagesWithCriteria: (Criteria *) crit;

// This will return array of central images
-(NSArray *) getCentralImages;


// Add image on flickr
-(void) addImages:(NSArray *) images toFlickrAccount: (NSString *) username;

// Add image on 500px
-(void) addImages:(NSArray *) images to500pxAccount: (NSString *) username;

-(void) moveCentralImageWithIndex: (int) changeIndex;

-(void) moveOuterImageFromPosition: (int) position;

-(void) getImageInfo:(ImageObject *) image;

-(void) getImageExif:(ImageObject *) image;

@end
