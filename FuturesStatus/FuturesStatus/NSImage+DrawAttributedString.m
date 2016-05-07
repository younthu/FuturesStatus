#import "NSImage+DrawAttributedString.h"

@implementation NSImage (DrawAttributedString)

+ (NSImage *)imageWithAttributedString:(NSAttributedString *)attributedString
                       backgroundColor:(NSColor *)backgroundColor
{
    if (nil == attributedString || [@"" isEqualToString:attributedString.string]) {
        return nil;
    }
  NSSize boxSize = [attributedString size];
  NSRect rect = NSMakeRect(0.0, 0.0, ceil(boxSize.width) , ceil(boxSize.height));
  NSImage *image = [[NSImage alloc] initWithSize:rect.size];

  [image lockFocus];

  [backgroundColor set];
  NSRectFill(rect);

  [attributedString drawInRect:rect];

  [image unlockFocus];

  return image ;
}

+ (NSImage *)imageWithAttributedString:(NSAttributedString *)attributedString
{
  return [self imageWithAttributedString:attributedString
                         backgroundColor:[NSColor clearColor]];
}

+ (NSImage *)imageWithString:(NSString *)string
{
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string] ;
  return [self imageWithAttributedString:attrString];
}

- (NSData *) PNGRepresentationOfImage{
    // Create a bitmap representation from the current image
    
//    [self lockFocus];
//    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, self.size.width, self.size.height)];
//    [self unlockFocus];
//    return [bitmapRep representationUsingType:NSPNGFileType properties:Nil];

    CGImageRef cgRef = [self CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:[self size]];   // if you want the same resolution
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:@(YES) forKey:NSImageInterlaced];
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:options];
    return pngData;
    }

@end