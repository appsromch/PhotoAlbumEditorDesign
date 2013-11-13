//
//  PAPictureDataTransformer.m
//  PhotoAlbumEditor
//
//  Created by Teddy Wyly on 10/24/13.
//  Copyright (c) 2013 Teddy Wyly. All rights reserved.
//

#import "PAPictureDataTransformer.h"

@implementation PAPictureDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}

@end
