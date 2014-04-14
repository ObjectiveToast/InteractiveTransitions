//
//  TWTViewController.m
//  InteractiveTransitionDemo
//
//  Created by Andrew Hershberger on 3/21/14.
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

#import "TWTViewController.h"

#import <TWTToast/TWTNavigationControllerDelegate.h>

#import "TWTPopTransitionController.h"
#import "UIColor+TWTNext.h"


@interface TWTViewController () <TWTTransitionControllerDelegate>

@property (nonatomic, strong) TWTPopTransitionController *popTransitionController;

@end


@implementation TWTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(pushViewController)];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor twt_nextColor];

    if (self.popTransitionController.pinchGestureRecognizer) {
        [self.view addGestureRecognizer:self.popTransitionController.pinchGestureRecognizer];
    }
}


- (void)pushViewController
{
    TWTViewController *viewController = [[TWTViewController alloc] init];
    viewController.popTransitionController = [[TWTPopTransitionController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)setPopTransitionController:(TWTPopTransitionController *)popTransitionController
{
    _popTransitionController = popTransitionController;
    self.twt_popAnimationController = popTransitionController;
    popTransitionController.delegate = self;
}


#pragma mark - TWTTransitionControllerDelegate

- (void)transitionControllerInteractionDidStart:(id<TWTTransitionController>)transitionController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
