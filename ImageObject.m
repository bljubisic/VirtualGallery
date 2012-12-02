//
//  ImageObject.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 01/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ImageObject.h"



@implementation ImageObject

@synthesize imageURLLarge;
@synthesize imageURLSmall;
@synthesize position;
@synthesize imageView;
@synthesize positionIndex;
@synthesize description;
@synthesize title;
@synthesize author;
@synthesize year;
@synthesize tags;
@synthesize moved;
@synthesize stX;
@synthesize stY;
@synthesize imageID;


-(id) initWithData: (NSDictionary *) photo {
    
    self = [super init];
    
    // Save the title to the photo titles array
    
    // Build the URL to where the image is stored (see the Flickr API)
    // In the format http://farmX.static.flickr.com/server/id_secret.jpg
    // Notice the "_s" which requests a "small" image 75 x 75 pixels
    NSString *photoURLStringSmall =
    [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
     photo[@"farm"], photo[@"server"],
     photo[@"id"], photo[@"secret"]];
    
    // The performance (scrolling) of the table will be much better if we
    // build an array of the image data here, and then add this data as
    // the cell.image value (see cellForRowAtIndexPath:)
    
    // Build and save the URL to the large image so we can zoom
    // in on the image if requested
    NSString *photoURLStringLarge =
    [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg",
     photo[@"farm"], photo[@"server"],
     photo[@"id"], photo[@"secret"]];
    
    [self setImageID:photo[@"id"]];
    [self setTitle: photo[@"title"]];
    [self setAuthor: photo[@"username"]];
    [self setImageURLLarge: photoURLStringLarge];
    [self setImageURLSmall:photoURLStringSmall];
    [self setMoved: 0];
    return self;
    
}

-(UIView *) createImageViewOn:(NSNumber *)positionIndexM withColor:(UIColor *) color {
    
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
    
    
    stX = @(startX);
    stY = @(startY);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    [view setBackgroundColor: [UIColor clearColor]];
    //[view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
    view.center = CGPointMake(startX, startY);
    
    NSURL * imageURL = [NSURL URLWithString:imageURLLarge];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    

    UIImageView *imgView = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageWithData:imageData];
    UIGraphicsBeginImageContextWithOptions(imgView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imgView.bounds
                                cornerRadius:10.0] addClip];
    [image drawInRect:imgView.bounds];
    imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView * myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 110, 110)];
    myImageView.image = image;
    //myImageView.center = CGPointMake(startX, startY);
    myImageView.contentMode  = UIViewContentModeScaleAspectFit;
    [view addSubview:myImageView];
    NSLog(@"create image view on position %d with url: %@", [positionIndexM intValue], imageURL);
    return view;
}

@end
