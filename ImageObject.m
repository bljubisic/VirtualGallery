//
//  ImageObject.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 01/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ImageObject.h"
#import <QuartzCore/QuartzCore.h>


@implementation ImageObject

@synthesize imageURLLarge;
@synthesize imageURLSmall;
@synthesize position;
@synthesize imageView;
@synthesize positionIndex;
@synthesize category;
@synthesize description;
@synthesize title;
@synthesize author;
@synthesize authorID;
@synthesize year;
@synthesize tags;
@synthesize moved;
@synthesize stX;
@synthesize stY;
@synthesize imageID;
@synthesize origin;
@synthesize imageURL;
@synthesize camera;
@synthesize exposure;
@synthesize aperture;
@synthesize iso;
@synthesize focalLength;
@synthesize authorFirstName;
@synthesize authorLastName;
@synthesize authorPicUrl;

-(id) initWithDataFromFlickr: (NSDictionary *) photo {
    
    self = [super init];
    //NSDictionary *photo = tmpPhoto[@"photo"];
    
    // Save the title to the photo titles array
    
    // Build the URL to where the image is stored (see the Flickr API)
    // In the format http://farmX.static.flickr.com/server/id_secret.jpg
    // Notice the "_s" which requests a "small" image 75 x 75 pixels
    NSString *photoURLStringSmall =
    [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg",
     photo[@"farm"], photo[@"server"],
     photo[@"id"], photo[@"secret"]];
    
    // The performance (scrolling) of the table will be much better if we
    // build an array of the image data here, and then add this data as
    // the cell.image value (see cellForRowAtIndexPath:)
    
    // Build and save the URL to the large image so we can zoom
    // in on the image if requested
    NSString *photoURLStringLarge =
    [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_z.jpg",
     photo[@"farm"], photo[@"server"],
     photo[@"id"], photo[@"secret"]];
    
    [self setImageID:photo[@"id"]];
    if(photo[@"title"])
        [self setTitle: photo[@"title"]];
    [self setAuthor: photo[@"username"]];
    if([photo[@"owner"] isKindOfClass:[NSDictionary class]]) {
        [self setAuthorID: photo[@"owner"][@"nsid"]];
        self.authorFirstName = [[NSString alloc] initWithString:photo[@"owner"][@"realname"]];
        NSString *authorFarm = photo[@"owner"][@"iconfarm"];
        NSString *authorServer = photo[@"owner"][@"iconserver"];
        [self setAuthorPicUrl:[NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg",
                               authorFarm, authorServer,
                           authorID]];
    }
    if([photo objectForKey:@"urls"])
        [self setImageURL: photo[@"urls"][@"url"][0][@"_content"]];
    [self setImageURLLarge: photoURLStringLarge];
    [self setImageURLSmall:photoURLStringSmall];
    [self setMoved: 0];
    [self setOrigin: [[NSNumber alloc] initWithInt:0]];
    imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    [imageView setBackgroundColor: [UIColor clearColor]];
    //[view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
    //view.center = CGPointMake(startX, startY);
    
    NSURL * tmpImageURL = [NSURL URLWithString:imageURLSmall];
    imageView.contentMode = UIViewContentModeScaleToFill;
    //NSData * imageData = [NSData dataWithContentsOfURL:tmpImageURL];
    
    
    
    //UIImage * image = [UIImage imageWithData:imageData];
    //self.image = image;
    AsyncImageView * myImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 10, 110, 110)];
    [myImageView loadImageFromURL:tmpImageURL];
    [myImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin)];
    //self.image = myImageView.image;
    
    //myImageView.center = CGPointMake(startX, startY);
    myImageView.contentMode  = UIViewContentModeScaleToFill;
    CALayer * l = [myImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    // You can even add a border
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [imageView addSubview:myImageView];
    imageView.autoresizesSubviews = YES;
    return self;
    
}

-(id) initWithDataFromPX:(NSDictionary *)photo {
    self = [super init];
    NSNumber *tmpNumb = photo[@"id"];
    [self setImageID:[tmpNumb stringValue]];
    [self setTitle: photo[@"name"]];
    [self setAuthor: photo[@"user"][@"username"]];
    [self setAuthorFirstName: photo[@"user"][@"firstname"]];
    [self setAuthorLastName: photo[@"user"][@"lastname"]];
    [self setAuthorPicUrl: photo[@"user"][@"userpic_url"]];
    [self setImageURLSmall:photo[@"image_url"][0]];
    [self setImageURLLarge:photo[@"image_url"][1]];
    [self setDescription:photo[@"description"]];
    [self setCategory:photo[@"category"]];
    [self setMoved: 0];
    [self setOrigin: [[NSNumber alloc] initWithInt:1]];
    NSString *tmpPartUrl = @"http://500px.com/photo/";
    NSString *tmpImageURL =[tmpPartUrl stringByAppendingString:imageID];
    [self setImageURL: tmpImageURL];
    imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    [imageView setBackgroundColor: [UIColor clearColor]];
    //[view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
    //view.center = CGPointMake(startX, startY);
    imageView.contentMode = UIViewContentModeScaleToFill;
    NSURL * tmpURLImage = [NSURL URLWithString:imageURLSmall];
    //NSData * imageData = [NSData dataWithContentsOfURL:tmpURLImage];
    
    
    
    //UIImage * image = [UIImage imageWithData:imageData];
    //self.image = image;
    
    AsyncImageView * myImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10, 10, 110, 110)];
    [myImageView loadImageFromURL:tmpURLImage];
    [myImageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin)];
    //self.image = myImageView.image;
    //myImageView.center = CGPointMake(startX, startY);
    myImageView.contentMode  = UIViewContentModeScaleToFill;
    CALayer * l = [myImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    
    // You can even add a border
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [imageView addSubview:myImageView];
    imageView.autoresizesSubviews = YES;
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
    
    imageView.center = CGPointMake(startX, startY);

    //NSLog(@"create image view on position %d with url: %@", [positionIndexM intValue], imageURLSmall);
    return imageView;
}

-(UIView *) createImageViewiPadOn:(NSNumber *)positionIndexM withColor:(UIColor *) color {
    
    int startX = 0;
    int startY = 0;
    int positionIndexInt = [positionIndexM intValue];
    
    if(positionIndexInt < 3)
        startY = STARTY;
    else if(positionIndexInt < 6 && positionIndexInt > 2)
        startY = MIDYP;
    else
        startY = ENDYP;
    
    if(positionIndexInt == 0 || positionIndexInt == 3 || positionIndexInt == 6)
        startX = STARTX;
    else if(positionIndexInt == 1 || positionIndexInt == 4 || positionIndexInt == 7)
        startX = MIDXP;
    else
        startX = ENDXP;
    
    
    stX = @(startX);
    stY = @(startY);
    CGRect imageViewFrame = imageView.frame;
    
    imageViewFrame.size.height = 312;
    imageViewFrame.size.width = 312;
    
    [imageView setFrame:imageViewFrame];
    [imageView setBackgroundColor:[UIColor clearColor]];
    
    imageView.center = CGPointMake(startX, startY);
    
    //NSLog(@"create image view on position %d with url: %@", [positionIndexM intValue], imageURLSmall);
    return imageView;
}
- (BOOL) isEqualTo:(ImageObject *)object {
    if ([self.imageID isEqual:object.imageID])
        return YES;
    return NO;
}

@end
