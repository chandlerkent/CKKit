@import <AppKit/CPView.j>

@implementation CKRoundedBorderView : CPView
{
    CPColor borderColor     @accessors;
    CGFloat borderRadius    @accessors;
    CGFloat borderWidth     @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    return [self initWithFrame:aFrame borderColor:[CPColor greenColor] borderRadius:1.0];
}

- (id)initWithFrame:(CGRect)aFrame borderColor:(CPColor)aColor borderRadius:(CGFloat)aRadius
{
    if(self = [super initWithFrame:aFrame])
    {
        borderColor = aColor;
        borderRadius = aRadius;
        borderWidth = 8.0;
    }
    return self;
}

- (void)drawRect:(CGRect)aRect
{
    var rect = [self bounds];
    var halfLineWidth = borderWidth / 2.0;
    rect.origin.x -= halfLineWidth;
    rect.origin.y -= halfLineWidth;
    rect.size.width -= borderWidth;
    rect.size.height -= borderWidth;
    
    var roundedRect = [CPBezierPath bezierPath];
    [roundedRect appendBezierPathWithRoundedRect:rect xRadius:borderRadius yRadius:borderRadius];
    
    [borderColor set];
    [roundedRect setLineWidth:borderWidth];
    
    [roundedRect stroke];
}

@end
