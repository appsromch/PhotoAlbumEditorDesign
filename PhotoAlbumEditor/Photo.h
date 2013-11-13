//
//  Photo.h
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/25/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) Album *albumBook;

@end
