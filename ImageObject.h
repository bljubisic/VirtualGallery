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

@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) UIView *imageView;
@property (nonatomic, retain) NSNumber *positionIndex;

- (UIView *) createImageView: (NSNumber *)positionIndex withColor: (UIColor *) color;

@end
