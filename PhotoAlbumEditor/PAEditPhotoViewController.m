//
//  PAEditPhotoViewController.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/23/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAEditPhotoViewController.h"

@interface PAEditPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) CIFilter *filterOne;
@property (strong, nonatomic) CIContext *context;

@end

@implementation PAEditPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (IBAction)filterOneSlider:(UISlider *)sender
{
    
    
}

- (void)setupFilters
{
    self.filterOne = [CIFilter filterWithName:@"nameOfFilter"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photoImageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
