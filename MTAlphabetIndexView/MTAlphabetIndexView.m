//
//  MTAlphabetIndexView.m
//  TestTransform
//
//  Created by jesse on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MTAlphabetIndexView.h"
#import <QuartzCore/QuartzCore.h>

#define length 28

@interface MTAlphabetIndexView ()
{
    CALayer     *_alphabetLayers[length];
    BOOL         _status[length];
}

@end


@implementation MTAlphabetIndexView

@synthesize delegate = _delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self disableAllIndexes];
        
    }
    return self;
}



#pragma mark - private method

- (void)initLayers
{
    for (int i = 0; i < length / 4; i ++)
    {
        
        float scale = [self contentScaleFactor];
        CGRect bounds = CGRectMake(15.0f, 8.0f + i * 65.0f, 290.0f * scale, 55.0f * scale);
        CALayer *layer = [CALayer layer];
        layer.frame = bounds;
        layer.contentsScale = [[UIScreen mainScreen] scale];
        
        for (int j = 0; j < 4; j ++)
        {
            NSInteger index = i * 4 + j;
            
            CALayer *alphabetLayer = [CALayer layer];
            alphabetLayer.frame = CGRectMake(j * 75.0f, 0.0f, 65.0f, 55.0f);
            alphabetLayer.backgroundColor = [UIColor redColor].CGColor;
            alphabetLayer.contentsScale = [[UIScreen mainScreen] scale];
            if (![layer.sublayers containsObject:alphabetLayer])
            {
                [layer addSublayer:alphabetLayer];
            }
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(7.0f, 22.0f, 30.0f, 30.0f);
            textLayer.string = [self alphabetAtIndex:index];
            textLayer.font = @"SourceSansPro-Semibold";
            textLayer.fontSize = 25.0f;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
            if (![alphabetLayer.sublayers containsObject:textLayer])
            {
                [alphabetLayer addSublayer:textLayer];
            }
            
            
            _alphabetLayers[index] = alphabetLayer;
        }
        
        
        [self.layer addSublayer:layer];
    }
}


- (void)reloadData
{
    for (int i = 0; i < length; i ++)
    {
        if (_status[i])
        {
            CALayer *layer = _alphabetLayers[i];
            UIColor *def = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"accentColor"]];
            layer.backgroundColor = def.CGColor;
            layer.contentsScale = [[UIScreen mainScreen] scale];
            
            CATextLayer *textLayer = layer.sublayers.lastObject;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
        }
        else if (i == 0)
        {
            CALayer *layer = _alphabetLayers[i];
            UIColor *def = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"accentColor"]];
            layer.backgroundColor = def.CGColor;
            layer.contentsScale = [[UIScreen mainScreen] scale];
            
            CATextLayer *textLayer = layer.sublayers.lastObject;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
        }
        else
        {
            CALayer *layer = _alphabetLayers[i];
            UIColor *current = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"accentColor"]];
            UIColor *augmented = [current colorWithAlphaComponent:0.5];
            layer.backgroundColor = augmented.CGColor;
            layer.contentsScale = [[UIScreen mainScreen] scale];
    
            CATextLayer *textLayer = layer.sublayers.lastObject;
            textLayer.foregroundColor = augmented.CGColor;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
        }
    }
}


- (void)disableAllIndexes
{
    for (int i = 0; i < length; i ++)
    {
        _status[i] = NO;
    }
}


#pragma mark - public method

- (NSString *)alphabetAtIndex:(NSInteger)index
{
    if (index > 0 && index < 27)
    {
        return [[NSString stringWithFormat:@"%c", 'A' + index - 1] lowercaseString];
    }
    else if (index == 0)
    {
        return @"#";
    }
    else
    {
        return nil;
    }
}


- (void)setIndex:(NSInteger)index enabled:(BOOL)enabled
{
    _status[index] = enabled;
}


- (void)setEnabledIndexes:(NSArray *)indexes
{
    [self disableAllIndexes];
    
    for (NSNumber *indexValue in indexes)
    {
        _status[[indexValue integerValue]] = YES;
    }
}


- (void)show
{
    [self initLayers];
    [self reloadData];
    
    CATransform3D transform = CATransform3DIdentity;
    float zDistance = 500.0f;
    transform.m34 = 1.0f / zDistance;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform,-0.8f ,1.0f,0.0f,0.0f)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform,0.0f,1.0f,0.0f,0.0f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setDuration:0.2f];
    button = [[UIButton alloc] initWithFrame:[[self superview] bounds]];
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [[self superview] addSubview:button];
    for (int gd = 0; gd<[[[self superview] subviews] count]; gd++)
    {
        NSArray *a = [[self superview] subviews];
        UIView *sub = a[gd];
        if (sub != self)
        {
            [sub setAlpha:0];
        }
    }
    [CATransaction begin];
    
    for (CALayer *layer in self.layer.sublayers)
    {
        [layer addAnimation:animation forKey:nil];
    }
    
    [CATransaction commit];
    
}

- (void)hide
{
    CATransform3D transform = CATransform3DIdentity;
    float zDistance = 500.0f;
    transform.m34 = 1.0f / zDistance;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, 0.0f, 1.0f, 0.0f, 0.0f)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, 1.5f , 1.0f, 0.0f, 0.0f)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setDuration:0.15f];
    [[self superview] setAlpha:1];
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];
    for (CALayer *layer in self.layer.sublayers)
    {
        [layer addAnimation:animation forKey:nil];
        layer.opacity = 0;
    }
    
    for (int gd = 0; gd<[[[self superview] subviews] count]; gd++)
    {
        NSArray *a = [[self superview] subviews];
        UIView *sub = a[gd];
        if (sub != self)
        {
           [sub setAlpha:1]; 
        }
    }
    [button removeFromSuperview];
    [CATransaction setCompletionBlock:^{

        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
        
    }];
    
    [CATransaction commit];
}

#pragma mark - UIView delegate

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger index = [self calIndexWithPoint:touchPoint];
    
    if (index > -1 && _status[index])
    {
        [self.delegate alphabetIndexView:self alphabetDidSelect:index];
        [self hide];
    }
    else if (index == 0)
    {
        [self.delegate alphabetIndexView:self alphabetDidSelect:index];
        [self hide];
    }
}

- (NSInteger)calIndexWithPoint:(CGPoint)point
{
    if (point.x > 15.0f && point.x < 305.0f && point.y > 8.0f && point.y < 453.0f)
    {
        NSInteger col = ((NSInteger)(point.x -  15.0f)) / 75;
        NSInteger row = ((NSInteger)(point.y - 8.0f)) / 65;
        
        if (point.x < col * 75 + 15 + 65 && point.y < row * 65 + 8 + 55)
        {
            return row * 4 + col;
        }
        else 
            return -1;
    }
    
    return -1;
}


@end




