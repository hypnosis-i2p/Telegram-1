#import "TGPopoverController.h"

@interface TGPopoverBackgroundView : UIPopoverBackgroundView
{
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

@end

@implementation TGPopoverBackgroundView

+ (CGFloat)arrowHeight
{
    return 20.0f;
}

+ (CGFloat)arrowBase
{
    return 20.0f;
}

+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

- (CGFloat)arrowOffset
{
    return _arrowOffset;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

- (UIPopoverArrowDirection)arrowDirection
{
    return _arrowDirection;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return false;
}

@end

@implementation TGPopoverController

- (instancetype)initWithContentViewController:(UIViewController *)viewController
{
    self = [super initWithContentViewController:viewController];
    if (self != nil)
    {
        //if (iosMajorVersion() < 7)
        //    self.popoverBackgroundViewClass = [TGPopoverBackgroundView class];
    }
    return self;
}

@end