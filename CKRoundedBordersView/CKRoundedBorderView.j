/*
 * Copyright (c) 2010 Chandler Kent
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
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
