/*
 * Copyright (c) 2015 Martin Hartl
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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const MHCustomTabBarControllerViewControllerChangedNotification;
extern NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification;
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MHCustomTabBarController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (weak,nonatomic) UIViewController *destinationViewController;
@property (strong, nonatomic) UIViewController *oldViewController;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (assign, nonatomic) NSInteger selectedIndex;

@property (weak,nonatomic) IBOutlet UIImageView * img_menu;


@property (assign,nonatomic) CGRect containerRect;

@property (nonatomic, strong) NSMutableDictionary *viewControllersByIdentifier;


@property (weak,nonatomic) IBOutlet UIImageView *img_home;
@property (weak,nonatomic)  IBOutlet  UITableView*    tableview_leftmenu;
@property (weak,nonatomic)  IBOutlet  UITableView*    tableview_leftsubmenu;
@property (weak,nonatomic)  IBOutlet  UITableView*    view_menu;


@property (weak,nonatomic) IBOutlet NSLayoutConstraint *constraint_menu_leading;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *constraint_submenu_traling;
@property (weak,nonatomic) IBOutlet UIView *view_menuright;

@property (assign,nonatomic) int menu_mode;


//1     homeview
//2     category
//3     post detail
//4     help
//5     photo
//6     place add
@end
