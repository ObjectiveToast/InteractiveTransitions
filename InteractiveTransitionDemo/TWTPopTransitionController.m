//
//  TWTPopTransitionController.m
//  InteractiveTransitionDemo
//
//  Created by Andrew Hershberger on 4/1/14.
//  Copyright (c) 2014 Two Toasters, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TWTPopTransitionController.h"


@implementation TWTPopTransitionController
@synthesize interactive = _interactive;
@synthesize delegate = _delegate;


- (id)init
{
    self = [super init];
    if (self) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] init];
        [_pinchGestureRecognizer addTarget:self action:@selector(handlePinchGesture:)];
    }
    return self;
}


- (void)dealloc
{
    [_pinchGestureRecognizer removeTarget:self action:@selector(handlePinchGesture:)];
}


- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGFloat scale = pinchGestureRecognizer.scale;
    CGFloat velocity = pinchGestureRecognizer.velocity;

    switch (pinchGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            [self.delegate transitionControllerInteractionDidStart:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percentComplete = 1.0 - scale;
            [self updateInteractiveTransition:percentComplete];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGFloat scaleInOneTenthSecond = scale + 0.1 * velocity;
            if (scaleInOneTenthSecond <= 0.5) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
            self.interactive = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            [self cancelInteractiveTransition];
            self.interactive = NO;
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 3.0;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [toViewController.view layoutIfNeeded];

    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view atIndex:0];

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.3, 0.3);
        fromViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        BOOL completed = ![transitionContext transitionWasCancelled];
        if (completed) {
            [fromViewController.view removeFromSuperview];
        }
        else {
            [toViewController.view removeFromSuperview];
        }
        [transitionContext completeTransition:completed];
    }];
}

@end
