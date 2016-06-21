#import "NSImage+DrawAttributedString.h"

@implementation NSImage (DrawAttributedString)


// http://stackoverflow.com/questions/22515480/core-text-in-cocoa-app
+ (NSImage *)drawRect:(NSRect)dirtyRect withString:(NSAttributedString*) str
{
    NSColor *backgroundColor = [NSColor clearColor];
    
    NSImage *image = [[NSImage alloc] initWithSize:dirtyRect.size];
    
    [image lockFocus];
    
    [backgroundColor set];
    NSRectFill(dirtyRect);
    
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    CFStringRef font_name = CFStringCreateWithCString(NULL, "Courier", kCFStringEncodingMacRoman);
    
    CTFontRef font = CTFontCreateWithName(font_name, 36.0, NULL);
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    CFDictionaryRef font_attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys, (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFRelease(font_name);
    
    CFRelease(font);
    
    int x = 0;
    int y = 0;
    
    CFAttributedStringRef attr_string = (__bridge CFAttributedStringRef)(str);
    //CFAttributedStringCreate(NULL, CFSTR("Hello World!"), font_attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attr_string);
    
    // You need to set the text matrix at least to CGAffineTransformIdentity
    // Here we translate to the desired position
    CGContextSetTextMatrix(context, CGAffineTransformMakeTranslation(x,y));
    
    CTLineDraw(line, context);
    
    CFRelease(line);
    
    CFRelease(attr_string);
    
    
    CGContextRestoreGState(context);
    
    [image unlockFocus];
    
    return image ;
}

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