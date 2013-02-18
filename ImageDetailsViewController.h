//
//  ImageDetailsViewController.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 24/12/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObject.h"
#import "ImageModel.h"

#define MINIMUM_SCALE 1.0
#define MAXIMUM_SCALE 4.0


@protocol ImageDetailsDelegate <NSObject>

@optional

- (void) doneButtonPressed;

@end

@interface ImageDetailsViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, ImageModelDelegate> {
    id <ImageDetailsDelegate> delegate;
}
- (IBAction)doneTouched:(id)sender;

@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, retain) UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *aperture;
@property (weak, nonatomic) IBOutlet UILabel *camera;
@property (weak, nonatomic) IBOutlet UILabel *iso;
@property (weak, nonatomic) IBOutlet UILabel *licence;
@property (weak, nonatomic) IBOutlet UILabel *exposure;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *focalLength;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorFirstName;
@property (weak, nonatomic) IBOutlet UILabel *authorLastName;

@property (weak, nonatomic) IBOutlet UIToolbar *shareToolbar;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) ImageObject *image;
@property (strong, nonatomic) ImageModel *model;
@property (strong, nonatomic) UIImage *tempImage;

- (IBAction)pressedShareButton:(id) sender;


@end
