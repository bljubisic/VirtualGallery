//
//  ImageObject.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 01/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncImageView.h"

#define STARTX 0
#define STARTY 0
#define MIDX 240
#define MIDXP 512
#define MIDY 138
#define MIDYP 384
#define ENDX 480
#define ENDXP 1024
#define ENDY 276
#define ENDYP 768

@interface ImageObject : NSObject

@property (nonatomic, retain) NSString *imageURLLarge;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *imageURLSmall;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) UIView   *imageView;
@property (nonatomic, retain) NSNumber *positionIndex;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSNumber *category;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *authorID;
@property (nonatomic, retain) NSNumber *year;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *moved;
@property (nonatomic, retain) NSNumber *stX;
@property (nonatomic, retain) NSNumber *stY;
@property (nonatomic, retain) NSNumber *origin; //0 - Flickr, 1 - 500px
@property (nonatomic, retain) NSString *imageID;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *exposure;
@property (nonatomic, retain) NSString *camera;
@property (nonatomic, retain) NSString *aperture;
@property (nonatomic, retain) NSString *licence;
@property (nonatomic, retain) NSString *iso;
@property (nonatomic, retain) NSString *focalLength;
@property (nonatomic, retain) NSString *authorFirstName;
@property (nonatomic, retain) NSString *authorLastName;
@property (nonatomic, retain) NSString *authorPicUrl;


- (id) initWithDataFromFlickr: (NSDictionary *) photo;
- (id) initWithDataFromPX: (NSDictionary *) photo;
- (UIView *) createImageViewOn: (NSNumber *)positionIndex withColor: (UIColor *) color;
- (UIView *) createImageViewiPadOn: (NSNumber *)positionIndex withColor: (UIColor *) color;
- (BOOL) isEqualTo:(ImageObject *) object;

@end
