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

#import "MHCustomTabBarController.h"
//#import "SWRevealViewController.h"
#import "MHTabBarSegue.h"
#import "CGlobal.h"
#import "CellMenuItem.h"
#import "CellPlaceName.h"
#import "CellSubMenuReviewHeader.h"
#import "CellGeneral.h"
#import "AppDelegate.h"
#import "NetworkParser.h"
NSString *const MHCustomTabBarControllerViewControllerChangedNotification = @"MHCustomTabBarControllerViewControllerChangedNotification";
NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification = @"MHCustomTabBarControllerViewControllerAlreadyVisibleNotification";

@interface MHCustomTabBarController ()

@property (strong,nonatomic) NSArray*strarray_menuitems;
@property (strong, nonatomic) NSString *destinationIdentifier;
@property (assign,nonatomic) BOOL bl_showMenu;
@property (assign,nonatomic) BOOL bl_showSubMenu;
@property (strong,nonatomic) UIFont *sampleFont;
@property (strong,nonatomic) UIFont *bigFont;
@end

@implementation MHCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initControls];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivenoti:) name:GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS object:nil];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    if (delegate.cl_location!=nil) {
//        // location is not nil
//        if (self.childViewControllers.count < 1) {
//            [self performSegueWithIdentifier:@"viewController2" sender:self];
//        }
//    }else{
//        //
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivenoti:) name:GLOBALNOTIFICATION_RECEIVE_LOCATION_UPDATE object:nil];
//    }
    
    [CGlobal showIndicator:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected:) name:GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failed:) name:GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL object:nil];
    
    delegate.cl_locationManager = [[CLLocationManager alloc] init];
    delegate.cl_locationManager.delegate = self;
    delegate.cl_locationManager.distanceFilter = kCLDistanceFilterNone;
    delegate.cl_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [delegate.cl_locationManager requestWhenInUseAuthorization];
    
    [delegate.cl_locationManager startUpdatingLocation];
    
    
}
-(void)connected:(NSNotification*)notification{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    // request location information
    if (delegate.cl_location != nil) {
        //get addresss from cl_location;
        [CGlobal showIndicator:self];
        NSString* latlng = [NSString stringWithFormat:@"%f,%f", delegate.cl_location.coordinate.latitude,delegate.cl_location.coordinate.longitude];
        NetworkParser *manager = [NetworkParser sharedManager];
        [manager onGetMyLocationAddress:latlng withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                NSArray*results = [dict objectForKey:@"results"];
                NSDictionary*result =  [results objectAtIndex:0];
                
                EftGooglePlace*place = [[EftGooglePlace alloc] initWithDictionary:result];
                
                EftRegion *region = [[EftRegion alloc] init];
                [region setGooglePlace:place];
                
                g_curRegion = region;
                
                //go to screen 2
                [self gotoScreen2];
            }
            
            [CGlobal stopIndicator:self];
        }];
    }else{
        [delegate.cl_locationManager startUpdatingLocation];
    }
}
-(void) gotoScreen2{
    AppDelegate*delegate = [[UIApplication sharedApplication] delegate];
    
    g_curRegion.isSavedToDb = [delegate hasThisRegion:g_curRegion];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController2",@"reset":@"1"}];
    
    NSString*idd = @"viewController2";
    [self.viewControllersByIdentifier removeObjectForKey:idd];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:idd sender:nil];
    });
    //
}
-(void) failed:(NSNotification*)notification{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Server not Responding"
                          message:@"Request Login again?"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok",nil];
    alert.tag = 100;
    [CGlobal stopIndicator:self];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int tag = alertView.tag;
    if (tag == 100) {
        if (buttonIndex == 1) {
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [CGlobal showIndicator:self];
            [delegate performLogin];
        }
    }else if (tag == 101){
        //add new place
        [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController6",@"reset":@"1"}];
    }
    else if (tag == 102){
    }
    
}
-(void) receivenoti:(NSNotification*)noti{
    NSNotificationName name = noti.name;
    
    if(noti.userInfo!=nil){
        NSString*idd = [noti.userInfo objectForKey:@"id"];
        if ([idd isEqualToString:GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS]) {
            if (_bl_showSubMenu && _menu_mode == 1) {
                [_tableview_leftsubmenu reloadData];
            }
        }
    }
    
}
-(void)initData{
    _menu_mode = 0;
    _bl_showMenu = false;
    _bl_showSubMenu = false;
    self.viewControllersByIdentifier = [NSMutableDictionary dictionary];
    
    _sampleFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    _bigFont = [UIFont fontWithName:@"Helvetica" size:17.0];
}
-(void)initControls{
    _img_menu.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_img_menu addGestureRecognizer:gesture];
    _img_menu.tag = 100;
    
    _img_home.userInteractionEnabled = true;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_img_home addGestureRecognizer:gesture];
    _img_home.tag = 101;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificaton:) name:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil];
    
    _strarray_menuitems = [[NSArray alloc] initWithObjects:@"Help",@"My Saved Places",@"My Reviews", nil];
    
    [_tableview_leftmenu registerNib:[UINib nibWithNibName:@"CellMenuItem" bundle:nil] forCellReuseIdentifier:@"CellMenuItem"];
    [_tableview_leftmenu registerNib:[UINib nibWithNibName:@"CellPlaceName" bundle:nil] forCellReuseIdentifier:@"CellPlaceName"];
    
    [_tableview_leftmenu setDelegate:self];
    [_tableview_leftmenu setDataSource:self];
    
    [_tableview_leftsubmenu setDelegate:self];
    [_tableview_leftsubmenu setDataSource:self];
    
    [_tableview_leftsubmenu registerNib:[UINib nibWithNibName:@"CellSubMenuReviewHeader" bundle:nil] forCellReuseIdentifier:@"CellSubMenuReviewHeader"];
    [_tableview_leftsubmenu registerNib:[UINib nibWithNibName:@"CellPlaceName" bundle:nil] forCellReuseIdentifier:@"CellPlaceName"];
    
    [self.view sendSubviewToBack:_view_menuright];
    
    _view_menuright.userInteractionEnabled = true;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_view_menuright addGestureRecognizer:gesture];
    _view_menuright.tag = 102;
    
}
-(void)receiveNotificaton:(NSNotification*)noti{
    if(noti.userInfo !=nil){
        NSString*idd = [noti.userInfo objectForKey:@"id"];
        if ([noti.userInfo objectForKey:@"reset"] != nil) {
            [self.viewControllersByIdentifier removeObjectForKey:idd];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:idd sender:nil];
        });
    };
}
-(void)ClickGesture:(UITapGestureRecognizer*)sender{
    int tag = sender.view.tag;
    if (tag == 100) {
        //        [self.view bringSubviewToFront:_tableview_leftmenu];
        [self toggleMenu];
    }else if (tag == 101){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"viewController1" sender:nil];
        });
        
    }else if(tag == 102){
        [self toggleMenu];
    }
    else if (tag == 1001){
        
        [self resetMenu];
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (self.childViewControllers.count < 1) {
//        [self performSegueWithIdentifier:@"viewController1" sender:self];
//    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.destinationViewController.view.frame = self.container.bounds;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (![segue isKindOfClass:[MHTabBarSegue class]]) {
        [super prepareForSegue:segue sender:sender];
        return;
    }
    
    self.oldViewController = self.destinationViewController;
    
    if (![self.viewControllersByIdentifier objectForKey:segue.identifier]) {
        [self.viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
    }
    
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [self.viewControllersByIdentifier objectForKey:self.destinationIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerChangedNotification object:nil];
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
        return NO;
    }
    
    return YES;
}
-(void) toggleSubmenu{
    _bl_showSubMenu = !_bl_showSubMenu;
    UIViewAnimationOptions option;
    if (_bl_showSubMenu) {
        _constraint_submenu_traling.constant = 240;
        option = UIViewAnimationOptionCurveEaseIn;
    }else{
        _constraint_menu_leading.constant = 0;
        option = UIViewAnimationOptionCurveLinear;
    }
    
    [_tableview_leftsubmenu setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2 delay:0 options:option animations:^{
        [_tableview_leftsubmenu layoutIfNeeded];
        
    } completion:^(BOOL finished){
        if (_bl_showSubMenu) {
            
        }else{
            
        }
    }];
}
-(void) showSubmenu{
    UIViewAnimationOptions option = UIViewAnimationOptionCurveLinear;
    
    _constraint_submenu_traling.constant = 240;
    [_tableview_leftsubmenu setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2 delay:0.05 options:option animations:^{
        [_tableview_leftsubmenu layoutIfNeeded];
        _bl_showSubMenu = true;
    } completion:^(BOOL finished){
        
    }];
}
-(void)resetMenu{
    
    _constraint_submenu_traling.constant = 0;
    _constraint_menu_leading.constant = -240;
    
    [_tableview_leftmenu setNeedsUpdateConstraints];
    [_tableview_leftsubmenu setNeedsUpdateConstraints];
    
    [self.view sendSubviewToBack:_view_menuright];
    
    [_tableview_leftmenu layoutIfNeeded];
    [_tableview_leftsubmenu layoutIfNeeded];
    
    _bl_showSubMenu = false;
    _bl_showMenu = false;
}
-(void) toggleMenu{
    if (_bl_showSubMenu) {
        //hide submenu
        UIViewAnimationOptions option;
        option = UIViewAnimationOptionCurveLinear;
        
        _constraint_submenu_traling.constant = 0;
        [_tableview_leftsubmenu setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.2 delay:0.05 options:option animations:^{
            [_tableview_leftsubmenu layoutIfNeeded];
            _bl_showSubMenu = false;
        } completion:^(BOOL finished){
            
        }];
        
        
    }else{
        // toggle menu
        _bl_showMenu = !_bl_showMenu;
        UIViewAnimationOptions option;
        if (_bl_showMenu) {
            
            _constraint_menu_leading.constant = 0;
            option = UIViewAnimationOptionCurveEaseIn;
        }else{
            _constraint_menu_leading.constant = -240;
            option = UIViewAnimationOptionCurveLinear;
            
            [self.view sendSubviewToBack:_view_menuright];
        }
        
        [_tableview_leftmenu setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:0.2 delay:0.05 options:option animations:^{
            [_tableview_leftmenu layoutIfNeeded];
            
        } completion:^(BOOL finished){
            if (_bl_showMenu) {
                [self.view bringSubviewToFront:_view_menuright];
            }else{
                
            }
        }];
        
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.2];
        if (_bl_showMenu) {
            _img_menu.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
        }else{
            _img_menu.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
        }
        
        [UIView commitAnimations];
    }
    
    
    
    
}
#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [[self.viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [self.viewControllersByIdentifier removeObjectForKey:key];
        }
    }];
    [super didReceiveMemoryWarning];
}
#pragma mark - Tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableview_leftmenu) {
        return [_strarray_menuitems count];
    }else{
        if (_menu_mode == 0) {
            return [g_savedLocations count];
        }else{
            EftPlace*place = [g_myplaces objectAtIndex:section];
            return  [place.ep_reviews count]+1;
        }
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableview_leftsubmenu) {
        if (_menu_mode == 1) {
            return [g_myplaces count];
        }
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int row = indexPath.row;
    int section = indexPath.section;
    if (tableView == _tableview_leftmenu) {
        static NSString *cellIdentifier = @"CellMenuItem";
        CellMenuItem *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (row == 0) {
            cell.img_left.image = [UIImage imageNamed:@"ic_info"];
        }else if(row == 1){
            cell.img_left.image = [UIImage imageNamed:@"ic_info_outline"];
        }else if(row == 2){
            cell.img_left.image = [UIImage imageNamed:@"ic_comment"];
        }
        cell.lbl_content.text = [_strarray_menuitems objectAtIndex:row];
        return cell;
    }else{
        if (_menu_mode == 0) {
            static NSString *cellIdentifier = @"CellPlaceName";
            CellPlaceName *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            EftRegion*region =  [g_savedLocations objectAtIndex:row];
            
            [cell setDataForMenu:region];
            
            return cell;
        }else{
            
            EftPlace*place = [g_myplaces objectAtIndex:section];
            if (row == 0) {
                CellSubMenuReviewHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSubMenuReviewHeader"];
                [cell setData:place];
                
                return cell;
            }else{
                EftReview*review =  [place.ep_reviews objectAtIndex:row-1];
                CellPlaceName *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPlaceName"];
                [cell setDataReview:review IndexPath:indexPath];
                [cell setDelegate:self];
                
                return cell;
            }
        }
    }
}
-(void) ClickReviewDelete:(NSIndexPath*)indexPath{
    int row = indexPath.row;
    int section = indexPath.section;
    
    [CGlobal showIndicator:self];
    EftPlace*place = [g_myplaces objectAtIndex:section];
    EftReview *review = [place.ep_reviews objectAtIndex:row-1];
    
    NetworkParser *manager = [NetworkParser sharedManager];
    [manager onDeleteReview:review withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            NSString*deleteplace = [dict objectForKey:@"deleteplace"];
            if ([deleteplace isEqualToString:@"1"]) {
                [g_myplaces removeObjectAtIndex:section];
                
                
            }else if([deleteplace isEqualToString:@"0"]){
                [place.ep_reviews removeObjectAtIndex:row-1];
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS object:self userInfo:@{@"id":GLOBALNOTIFICATION_DATACHANGE_MYREVIEWS}];
        }else{
            [CGlobal AlertMessage:@"Fail to Delete" Title:nil];
        }
        
        [CGlobal stopIndicator:self];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if (tableView == _tableview_leftmenu) {
        switch (row) {
            case 0:{
                [self toggleMenu];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"viewController4" sender:nil];
                });
                break;
            }
            case 1:{
                _menu_mode = 0;
                
                [_tableview_leftsubmenu reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSubmenu];
                });
                
                break;
            }
            case 2:{
                _menu_mode = 1;
                [_tableview_leftsubmenu reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSubmenu];
                });
                break;
            }
            default:
                break;
        }
    }else{
        if (_menu_mode == 0) {
            EftRegion*region =  [g_savedLocations objectAtIndex:row];
            g_curRegion = region;
            
            AppDelegate*delegate = [[UIApplication sharedApplication] delegate];
            g_curRegion.isSavedToDb = [delegate hasThisRegion:g_curRegion];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController2",@"reset":@"1"}];
            
            [self resetMenu];
        }else{
            // nothing yet.
        }
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    int section = indexPath.section;
    CGFloat height = 60.0;
    CGFloat tablewidth = 240.0;
    if (tableView == _tableview_leftsubmenu) {
        if (_menu_mode == 0) {
            EftRegion *region =  [g_savedLocations objectAtIndex:row];
            
            height = MAX([CGlobal heightForView:[region getAddress] Font:_sampleFont Width:[CellPlaceName getLabelWidth:tablewidth]]+39,60);
        }else{
            EftPlace*place = [g_myplaces objectAtIndex:section];
            if (row == 0) {
                height = [place getHeightForSubMenuForAddress] + [place getHeightForSubMenuForName] + 30;
                
            }else{
                EftReview*review =  [place.ep_reviews objectAtIndex:row-1];
                height = MAX(60, [review getHeightForSubMenuForReviewText]+39);
            }
        }
    }
    return  height;
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.cl_location = [locations lastObject];
    [delegate.cl_locationManager stopUpdatingLocation];
    
    NSLog(@"location %f %f",delegate.cl_location.coordinate.latitude,delegate.cl_location.coordinate.longitude);
    // 41.757410, 123.422945
    delegate.cl_location = [[CLLocation alloc] initWithLatitude:41.757410f longitude:123.422945f];
//    delegate.cl_location.coordinate.latitude = 41.757410f;
    
    
    [delegate performLogin];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_RECEIVE_LOCATION_UPDATE object:nil];
}

@end

