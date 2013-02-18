//
//  ImageDetailsViewController.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 24/12/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ImageDetailsViewController.h"

@interface ImageDetailsViewController () {
    BOOL shownOverlay;
    int startX;
    int startY;
}

@end

@implementation ImageDetailsViewController

@synthesize delegate;
@synthesize imageView;
@synthesize image;
@synthesize model;
@synthesize imageScrollView;
@synthesize shareToolbar;
@synthesize detailsView;
@synthesize aperture;
@synthesize iso;
@synthesize camera;
@synthesize licence;
@synthesize exposure;
@synthesize name;
@synthesize focalLength;
@synthesize authorFirstName;
@synthesize authorLastName;
@synthesize authorImage;
@synthesize description;
@synthesize spinner;
@synthesize tempImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [model setDelegate:self];
    shownOverlay = NO;
    /*
    NSURL * tmpURLImage = [NSURL URLWithString:image.imageURLLarge];
    NSData * imageData = [NSData dataWithContentsOfURL:tmpURLImage];
     */
    
    imageView.image = tempImage;
     
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)];
    [tapRecognizer setDelegate:self];
    //CGRect imageViewFrame = imageView.frame;
    //imageViewFrame.size.width = imageView.image.size.width;
    //imageViewFrame.size.height = imageView.image.size.height;
    //NSLog(@"image size: %f:%f", imageView.image.size.width, imageView.image.size.height);
    //NSLog(@"image view size: %f:%f", imageView.frame.size.width, imageView.frame.size.height);
    //[imageView setFrame:imageViewFrame];
    //NSLog(@"image view size: %f:%f", imageView.frame.size.width, imageView.frame.size.height);
    //self.imageScrollView.contentSize = imageView.image.size;
    self.imageScrollView.delegate = self;
    self.imageScrollView.minimumZoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 10.0;
    [self.imageScrollView setShowsHorizontalScrollIndicator:NO];
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.name.text = self.image.title;
    if([self.image.origin intValue] == 0)
        self.name.text = [self.name.text stringByAppendingString:@"flickr"];
    else
        self.name.text = [self.name.text stringByAppendingString:@"500px"];
    [self.view bringSubviewToFront:imageScrollView];
    [self.view bringSubviewToFront:detailsView];
    authorFirstName.text = self.image.authorFirstName;
    authorLastName.text = self.image.authorLastName;
    description.text = self.image.description;
    NSURL *tmpAuthorImgUrl = [NSURL URLWithString:self.image.authorPicUrl];
    NSData *authorImgData = [NSData dataWithContentsOfURL:tmpAuthorImgUrl];
    
    authorImage.image = [[UIImage alloc] initWithData:authorImgData];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [model getImageInfo:image];
    if([self.image.origin intValue] == 1)
        [model getImageExif:self.image];
    [detailsView addGestureRecognizer:panRecognizer];
    [imageScrollView addGestureRecognizer:(UITapGestureRecognizer *) tapRecognizer];
    [spinner stopAnimating];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void) touchImage:(id) sender {
    if(!shownOverlay) {
        shareToolbar.hidden = NO;
        detailsView.hidden = NO;
        detailsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view bringSubviewToFront:detailsView];
        [self.view bringSubviewToFront:shareToolbar];
        shownOverlay = YES;
    }
    else {
        shareToolbar.hidden = YES;
        detailsView.hidden = YES;
        shownOverlay = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setView:nil];
    [super viewDidUnload];
}
- (IBAction)doneTouched:(id)sender {
    if ([delegate respondsToSelector:@selector(doneButtonPressed)]) {
        [delegate doneButtonPressed];
    }
    
}

-(void) imageInfoReceived:(ImageObject *) photo {
    authorFirstName.text = photo.authorFirstName;
    authorLastName.text = photo.authorLastName;
    description.text = photo.description;
    NSURL *tmpAuthorImgUrl = [NSURL URLWithString:photo.authorPicUrl];
    NSData *authorImgData = [NSData dataWithContentsOfURL:tmpAuthorImgUrl];
    
    authorImage.image = [[UIImage alloc] initWithData:authorImgData];
    self.image = photo;
    [model getImageExif:image];
}

- (void) imageInfoExifReceived: (ImageObject *) photo {
    if(photo.aperture != nil)
        aperture.text = photo.aperture;
    if(photo.iso != nil)
        iso.text = photo.iso;
    if(photo.exposure != nil)
        exposure.text = photo.exposure;
    if(photo.camera != nil)
        camera.text = photo.camera;
    if(photo.title != nil)
        name.text = photo.title;
    if(photo.focalLength != nil)
        focalLength.text = photo.focalLength;
}

-(void)move:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    
    CGPoint translatedPoint = [recognizer translationInView:detailsView];

    
    //NSLog(@"new central point is: %f %f", translatedPoint.x, translatedPoint.y);
    // [self viewIntersectsWithAnotherView:[sender view]];
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        startX = [[sender view] center].x;
        startY = [[sender view] center].y;
    }
    translatedPoint = CGPointMake(startX, startY + translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
}

- (IBAction)pressedShareButton:(id)sender {
    NSArray *activityItems;
    NSString *postText = @"Seen on #virtualgallery: ";
    postText = [postText stringByAppendingString:image.title];
    postText = [postText stringByAppendingString:@" by "];
    postText = [postText stringByAppendingString:image.author];
    NSURL *sentURL = [NSURL URLWithString:image.imageURL];
        activityItems = @[postText, sentURL];
    
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    activityController.excludedActivityTypes  = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

@end
