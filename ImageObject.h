//
//  ImageObject.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 01/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STARTX 0
#define STARTY 0
#define MIDX 240
#define MIDY 138
#define ENDX 480
#define ENDY 276

@interface ImageObject : NSObject

@property (nonatomic, retain) NSString *imageURLLarge;
@property (nonatomic, retain) NSString *imageURLSmall;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) UIView *imageView;
@property (nonatomic, retain) NSNumber *positionIndex;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSNumber *year;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *moved;
@property (nonatomic, retain) NSNumber *stX;
@property (nonatomic, retain) NSNumber *stY;
@property (nonatomic, retain) NSNumber *origin; //0 - Flickr, 1 - 500px
@property (nonatomic, retain) NSString *imageID;

- (id) initWithData: (NSDictionary *) photo;
- (UIView *) createImageViewOn: (NSNumber *)positionIndex withColor: (UIColor *) color;

@end
