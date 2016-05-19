//
//  HeaderView.m
//

#import "HeaderView.h"

@implementation HeaderView

@synthesize fillColor = _fillColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)dealloc
{
   
}

- (void)drawRect:(CGRect)rect
{
    //NSLog(@" -----  HeaderView(drawRect)");
    //draw gradient
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetLineWidth(context, 0.0);
    //CGContextReplacePathWithStrokedPath(context);
    CGContextSetLineWidth(context, .25);
    CGContextStrokePath(context);
    CGContextSetAlpha(context, 1);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetFillColorWithColor(context, [_fillColor CGColor]);
    
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    [self drawGlossyAndGradient:context rect:newRect startColor:[[UIColor lightGrayColor] CGColor] endColor:[_fillColor CGColor]];
    
}


- (void)drawLinearGradient:(CGContextRef)context rect:(CGRect)rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    //NSLog(@" -----  HeaderView(drawLinearGrad)");
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)CFBridgingRelease(startColor), (id)CFBridgingRelease(endColor), nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                        (CFArrayRef) CFBridgingRetain(colors), locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

- (void)drawGlossyAndGradient:(CGContextRef)context rect:(CGRect)rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    [self drawLinearGradient:context rect:rect startColor:startColor endColor:endColor];
    
    CGColorRef startGlossColor = [UIColor colorWithRed:1.0 green:1.0
                                                  blue:1.0 alpha:0.4].CGColor;
    CGColorRef endGlossColor = [UIColor colorWithRed:1.0 green:1.0
                                                blue:1.0 alpha:0.1].CGColor;
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y,
                                rect.size.width, rect.size.height/2);
    [self drawLinearGradient:context rect:topHalf startColor:startGlossColor endColor:endGlossColor];
    
}
@end
