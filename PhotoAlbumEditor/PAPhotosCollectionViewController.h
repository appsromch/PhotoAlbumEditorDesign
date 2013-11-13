//
//  PAPhotosCollectionViewController.h
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/22/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface PAPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

@end
