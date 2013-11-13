//
//  PAPhotoDetailViewController.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/23/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAPhotoDetailViewController.h"
#import "PAEditPhotoViewController.h"
#import "CoreDataHelper.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "PAFilterPhotosCollectionViewController.h"

@interface PAPhotoDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet FUIButton *editButton;
@property (weak, nonatomic) IBOutlet FUIButton *deleteButton;

@end

@implementation PAPhotoDetailViewController

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
    [self setupButtons];
    
	// Do any additional setup after loading the view.
}

- (void)setupButtons
{
    self.editButton.buttonColor = [UIColor turquoiseColor];
    self.editButton.shadowColor = [UIColor greenSeaColor];
    self.editButton.shadowHeight = 3.0f;
    self.editButton.cornerRadius = 6.0f;
    [self.editButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.deleteButton.buttonColor = [UIColor alizarinColor];
    self.deleteButton.shadowColor = [UIColor pomegranateColor];
    self.deleteButton.shadowHeight = 3.0f;
    self.deleteButton.cornerRadius = 6.0f;
    [self.deleteButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

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

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[CoreDataHelper managedObjectContext] deleteObject:self.photo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PAEditPhotoViewController class]]) {
        PAEditPhotoViewController *targetViewController = segue.destinationViewController;
        targetViewController.photo = self.photo;
    }
    
    if ([segue.destinationViewController isKindOfClass:[PAFilterPhotosCollectionViewController class]]) {
        PAFilterPhotosCollectionViewController *targetViewController = segue.destinationViewController;
        targetViewController.photo = self.photo;
    }
}

@end
