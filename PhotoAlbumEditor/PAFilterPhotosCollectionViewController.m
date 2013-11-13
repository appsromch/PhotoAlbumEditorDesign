//
//  PAFilterPhotosCollectionViewController.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/26/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAFilterPhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "CoreDataHelper.h"

@interface PAFilterPhotosCollectionViewController ()

@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) NSMutableArray *photos; //Of UIImages

@end

@implementation PAFilterPhotosCollectionViewController

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
    
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //UIImage *image = self.photo.image;
    
    
    //[self.photos addObject:image];

    
//    for (CIFilter *filter in [[self class] photoFilters]) {
//        [self.photos addObject:[self imageFromImage:image andFilter:filter]];
//    }
    
    for (CIFilter *filter in [[self class] photoFilters]) {
        [self.photos addObject:filter];
    }
    
    
}

- (NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
    return _photos;
}


+ (NSArray *)photoFilters;
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputRadiusKey, @1, nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControl, transfer, unsharpen, monochrome];
    return allFilters;
    
}

- (UIImage *)imageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];
    
    CGRect extent = [filteredImage extent];
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    NSLog(@"Look at all this data: %@", UIImagePNGRepresentation(finalImage));
    
    return finalImage;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure the cell
    cell.backgroundColor = [UIColor whiteColor];
    //Photo *photoForCell = self.photos[indexPath.row];
    
    cell.imageView.image = nil;
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    dispatch_async(filterQueue, ^{
        UIImage *filterImage = [self imageFromImage:self.photo.image andFilter:self.photos[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImage;
        });
    });

    
    //cell.imageView.image = self.photos[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // There is a chance that the user taps too early
    // Put everything in an if statement!
    
    PhotoCollectionViewCell *selectedCell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;
    
    NSError *error = nil;
    
    if (![[self.photo managedObjectContext] save:&error]) {
        // Handle Error
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

@end
