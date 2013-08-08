//
//  UIImage+Resize.h
//  
//
//  Created by Vlad Andersen on 1/5/13.
//
//



@interface UIImage (Resize)

- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;

@end
