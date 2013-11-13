//
//  PAPhotosCollectionViewController.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAPhotosCollectionViewController.h"
#import "Photo.h"
#import "CoreDataHelper.h"
#import "PhotoCollectionViewCell.h"
#import "PAPhotoDetailViewController.h"

@interface PAPhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos; //Of NSManagedObject Photo

@end

@implementation PAPhotosCollectionViewController

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
    self.photos = [[self.album.photos allObjects] mutableCopy];
    
    for (Photo *photo in self.photos) {
        NSLog(@"%@", photo.image);
    }
    
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PAPhotoDetailViewController class]]) {
        PAPhotoDetailViewController *targetViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        targetViewController.photo = self.photos[indexPath.row];
    }
}


- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (Photo *)createPhotoWithImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.albumBook = self.album;
    
    NSError *error = nil;
    
    if (![[CoreDataHelper managedObjectContext] save:&error]) {
        NSLog(@"Handle error!");
    }
    
    return photo;
}

# pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Picked!");
    
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:[self createPhotoWithImage:pickedImage]];
    NSLog(@"%@", self.photos);
    
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure the cell
    Photo *photoForCell = self.photos[indexPath.row];
    cell.imageView.image = photoForCell.image;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

@end
