//
//  ImageObject.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 01/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ImageObject.h"



@implementation ImageObject

@synthesize imageURL;
@synthesize position;
@synthesize imageView;
@synthesize positionIndex;
@synthesize description;
@synthesize title;
@synthesize author;
@synthesize year;
@synthesize tags;

-(UIView *) createImageView:(NSNumber *)positionIndexM withColor:(UIColor *) color {
    
    int startX = 0;
    int startY = 0;
    int positionIndexInt = [positionIndexM intValue];
    
    if(positionIndexInt < 3)
        startY = STARTY;
    else if(positionIndexInt < 6 && positionIndexInt > 2)
        startY = MIDY;
    else
        startY = ENDY;
    
    if(positionIndexInt == 0 || positionIndexInt == 3 || positionIndexInt == 6)
        startX = STARTX;
    else if(positionIndexInt == 1 || positionIndexInt == 4 || positionIndexInt == 7)
        startX = MIDX;
    else
        startX = ENDX;
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-9, -9, 120, 120)];
    [view setBackgroundColor: color];
    view.center = CGPointMake(startX, startY);
    NSLog(@"create image view on position %d on x: %d y:%d", [positionIndex intValue], startX, startY);
    return view;
}

@end
