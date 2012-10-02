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
#import "Criteria.h"

@interface ImageModel : NSObject

@property (nonatomic, retain) NSMutableArray *centralImages;
@property (nonatomic, retain) NSMutableArray *fuzzyImages;
@property (nonatomic, retain) NSMutableArray *returnArray;

@property (nonatomic, retain) FlickrModel *flickrModel;

// This method will get back array of nine elements (to be displayed on screen)
// Every move of images on main view will call this method to get new images
// This can be done either through web interface or from cache
-(void) getImagesWithCriteria: (Criteria *) crit;

// This will return array of central images
-(NSArray *) getCentralImages;

// This will return array of fuzzy images for central image
-(void) getFuzzyImagesForImage: (ImageObject *) image;

// Add image on flickr
-(void) addImages:(NSArray *) images toFlickrAccount: (NSString *) username;

// Add image on 500px
-(void) addImages:(NSArray *) images to500pxAccount: (NSString *) username;

@end
