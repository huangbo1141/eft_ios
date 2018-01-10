/*
 * Copyright (c) 2013 Martin Hartl
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

#import "MHTabBarSegue.h"
#import "MHCustomTabBarController.h"

@implementation MHTabBarSegue
- (void) perform {
    MHCustomTabBarController *tabBarViewController = (MHCustomTabBarController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) tabBarViewController.destinationViewController;

    CGRect rect = [UIScreen mainScreen].bounds;
    //remove old viewController
    if (tabBarViewController.oldViewController) {
        //
        if ([tabBarViewController.oldViewController respondsToSelector:@selector(clearContainerConstraints)]) {
            [tabBarViewController.oldViewController performSelector:@selector(clearContainerConstraints) withObject:nil];
        }
        
        [tabBarViewController.oldViewController willMoveToParentViewController:nil];
        [tabBarViewController.oldViewController.view removeFromSuperview];
        [tabBarViewController.oldViewController removeFromParentViewController];
    }
    CGFloat toppadding =  destinationViewController.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height + 100;
    CGFloat bottompadding = 0;
    
    CGRect destRect = CGRectMake(0, 0, rect.size.width, rect.size.height - toppadding - bottompadding);
    
    destinationViewController.view.frame = destRect;
    
    
    
    
    [tabBarViewController addChildViewController:destinationViewController];
    [tabBarViewController.container addSubview:destinationViewController.view];
    [destinationViewController didMoveToParentViewController:tabBarViewController];
    
    NSValue *rectValue = [NSValue valueWithCGRect:destRect];
    if ([destinationViewController respondsToSelector:@selector(setContainerConstraints:Parent:)]) {
        [destinationViewController performSelector:@selector(setContainerConstraints:Parent:) withObject:rectValue withObject:tabBarViewController.container];
    }
}

@end
