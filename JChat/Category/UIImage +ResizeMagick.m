//
//  UIImage+ResizeMagick.m
//
//
//  Created by Vlad Andersen on 1/5/13.
//
//

#import "UIImage+ResizeMagick.h"

@implementation UIImage (ResizeMagick)

- (NSData *) resizedAndReturnData
{
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"
    UIImage *newImage = [self  resizedImageByMagick:@"1024x1024"];
    NSData *imgData1 = UIImageJPEGRepresentation(newImage, 1.0f);
    NSData *imgData2 = UIImageJPEGRepresentation(newImage, 0.7f);
    NSData *imgData3 = UIImageJPEGRepresentation(newImage, 0.4f);
    NSData *imgData4 = UIImageJPEGRepresentation(newImage, 0.0f);
    return imgData3;
#pragma clang diagnostic pop
}

- (NSString *) resizedAndReturnPath
{
    return @"";
}

#pragma mark--压缩图片200x200
+(UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}


#pragma mark --按比例缩小
+(UIImage *) imageWithImageSimple:(UIImage*)image scaled:(float) scaled {
    CGSize newSize = CGSizeZero;
    newSize.height=image.size.height*scaled;
    newSize.width = image.size.width*scaled;
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

// width	Width given, height automagically selected to preserve aspect ratio.
// xheight	Height given, width automagically selected to preserve aspect ratio.
// widthxheight	Maximum values of height and width given, aspect ratio preserved.
// widthxheight^	Minimum values of width and height given, aspect ratio preserved.
// widthxheight!	Exact dimensions, no aspect ratio preserved.
// widthxheight#	Crop to this exact dimensions.

- (UIImage *) resizedImageByMagick: (NSString *) spec
{
    if([spec hasSuffix:@"!"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = (unsigned int)[[widthAndHeight objectAtIndex: 0] longLongValue];
        NSUInteger height = (unsigned int)[[widthAndHeight objectAtIndex: 1] longLongValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage drawImageInBounds: CGRectMake (0, 0, width, height)];
    }

    if([spec hasSuffix:@"#"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = (unsigned int)[[widthAndHeight objectAtIndex: 0] longLongValue];
        NSUInteger height = (unsigned int)[[widthAndHeight objectAtIndex: 1] longLongValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage croppedImageWithRect: CGRectMake ((newImage.size.width - width) / 2, (newImage.size.height - height) / 2, width, height)];
    }

    if([spec hasSuffix:@"^"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        return [self resizedImageWithMinimumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                              [[widthAndHeight objectAtIndex: 1] longLongValue])];
    }

    NSArray *widthAndHeight = [spec componentsSeparatedByString: @"x"];
    if ([widthAndHeight count] == 1) {
        return [self resizedImageByWidth:(unsigned int)[spec longLongValue]];
    }
    if ([[widthAndHeight objectAtIndex: 0] isEqualToString: @""]) {
        return [self resizedImageByHeight:(unsigned int)[[widthAndHeight objectAtIndex: 1] longLongValue]];
    }
    return [self resizedImageWithMaximumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                          [[widthAndHeight objectAtIndex: 1] longLongValue])];
}

- (CGImageRef) CGImageWithCorrectOrientation
{
    if (self.imageOrientation == UIImageOrientationDown) {
        //retaining because caller expects to own the reference
        CGImageRetain([self CGImage]);
        return [self CGImage];
    }
    UIGraphicsBeginImageContext(self.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 180 * M_PI/180);
    }

    [self drawAtPoint:CGPointMake(0, 0)];

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();

    return cgImage;
}

- (UIImage *) resizedImageByWidth:(NSUInteger) width {
    if (self.size.width <width) {
        return self;
    }
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = width/original_width;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, width, round(original_height * ratio))];
}

- (UIImage *) resizedImageByHeight:  (NSUInteger) height {
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = height/original_height;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * ratio), height)];
}

- (UIImage *) resizedImageWithMinimumSize: (CGSize) size {
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio > height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) resizedImageWithMaximumSize: (CGSize) size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio < height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) drawImageInBounds: (CGRect) bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    [self drawInRect: bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage*) croppedImageWithRect: (CGRect) rect {

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return subImage;
}


@end
