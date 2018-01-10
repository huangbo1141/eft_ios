//
//  HomeViewController.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryViewController.h"
//#import "SWRevealViewController.h"
#import "MHCustomTabBarController.h"
#import "CGlobal.h"
#import "NSString+Common.h"
#import "NetworkParser.h"
#import "CellPlaceName.h"
#import "AppDelegate.h"
#import "CellGeneral.h"

#import "AFNetworking/AFNetworking.h"
#import "DataModels.h"
#import "CellGeneral.h"

#define GoogleDirectionAPI @"AIzaSyCmvC_H5S08MvkO-ixoQTpJQGXdu5qyVWg"

#define kGoogleAutoCompleteAPI @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray *items;
    NSMutableArray *items_placesforpostreview;
    int items_placesforpostreview_selindex;
}
@property (nonatomic,assign) CGRect cgrect_viewcontent;
@property (nonatomic,assign) CGRect cgrect_selectcategory;
@property (nonatomic,strong) UIView* viewforpost;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self calcRegion];
    [self initControls];
    [self initData];
    
    if (g_curUser == nil) {
        [CGlobal showIndicator:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected:) name:GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failed:) name:GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL object:nil];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mynotifications:) name:GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION object:nil];
    
}
-(void) initData{
    [_view_savedloc registerNib:[UINib nibWithNibName:@"CellPlaceName" bundle:nil] forCellReuseIdentifier:@"CellPlaceName"];
    [_autocompleteTable registerNib:[UINib nibWithNibName:@"CellGeneral" bundle:nil] forCellReuseIdentifier:@"CellGeneral"];
    [_tableview_severalfound registerNib:[UINib nibWithNibName:@"CellGeneral" bundle:nil] forCellReuseIdentifier:@"CellGeneral"];
    
    _view_savedloc.delegate = self;
    _view_savedloc.dataSource = self;
    
    _autocompleteTable.delegate = self;
    _autocompleteTable.dataSource = self;
    
    _tableview_severalfound.delegate = self;
    _tableview_severalfound.dataSource = self;
    
    _view_addnew.searchField.delegate = self;
    
        
    items_placesforpostreview_selindex = -1;
}

-(void)mynotifications:(NSNotification*)notification{
    NSDictionary *dict = notification.userInfo;
    if ([dict objectForKey:@"id"]) {
        NSString*nid = [dict objectForKey:@"id"];
        if ([nid isEqualToString:GLOBALNOTIFICATION_DATACHANGE_SAVEDLOCATION]) {
            //
            [_view_savedloc reloadData];
        }
    }
}
-(void)connected:(NSNotification*)notification{
    [CGlobal stopIndicator:self];
    
}
-(void)willPresentAlertView:(UIAlertView *)alertView{
    int tag = alertView.tag;
    if (tag == 102) {
        [alertView setFrame:CGRectMake(0, 0, 300, 500)];
    }
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
        // did select item
        if (buttonIndex == 1) {
            
            
            EftGooglePlace*googleplace =  (EftGooglePlace*)[items_placesforpostreview objectAtIndex:items_placesforpostreview_selindex];
            NSString*reference = googleplace.reference;
            
            [CGlobal showIndicator:self];
            NetworkParser *manager = [NetworkParser sharedManager];
            [manager onAddReview:g_curReview Reference:reference Category:g_selectedCategory withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                if (error == nil) {
                    EftPlace* place = [[EftPlace alloc] initWithDictionary:[dict objectForKey:@"row_place"]];
                    
                    EftReview *review = [[EftReview alloc] initWithDictionary:[dict objectForKey:@"ep_review"]];
                    //update my review table
                    BOOL found = false;
                    for (EftPlace*iplace in g_myplaces) {
                        if (iplace.ep_id == place.ep_id) {
                            
                            [iplace.ep_reviews addObject:review];
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        [g_myplaces addObject:place];
                    }
                    
                    [self resetFlyingViews];
                    
                }else{
                    [CGlobal AlertMessage:@"Failed to Post Review" Title:nil];
                }
//                UIButton* btn = (UIButton*)sender;
//                sender.enabled = true;
                
                [CGlobal stopIndicator:self];
            }];
            
            
        }
    }
    
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
-(void)setContainerConstraints:(NSValue*)rectValue Parent:(UIView*)container{
    CGRect rect = [rectValue CGRectValue];
    CGSize size = rect.size;
    _constraint_viewheight = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height];
    _constraint_viewwidth = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.width];
    _constraint_viewleading = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    _constraint_viewtop = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:_constraint_viewheight,_constraint_viewwidth,_constraint_viewleading,_constraint_viewtop, nil]];
    
    self.view.frame = rect;
    _view_content.frame = CGRectMake(0, 0, size.width, size.height - 80);
    
//    CGFloat padding = rect.size.height/4.0 - 23;
//    if (padding>0) {
//    }else{
//        padding = 0;
//    }
//    _constraint_autocomplete.constant = padding;
//    [_autocompleteTable setNeedsUpdateConstraints];
    
    [self.view layoutIfNeeded];
    
}
-(void)clearContainerConstraints{
    if (_constraint_viewheight!=nil && _constraint_viewwidth!=nil) {
        [self.view removeConstraints:[[NSArray alloc] initWithObjects:_constraint_viewheight,_constraint_viewwidth,_constraint_viewleading,_constraint_viewtop, nil]];
        _constraint_viewwidth = nil;
        _constraint_viewheight = nil;
    }
}
-(void)calcRegion{
    CGRect rect = self.view.frame;
    _cgrect_viewcontent = CGRectMake(0, 0, _constraint_viewwidth.constant, _constraint_viewheight.constant);
    
    _cgrect_selectcategory = CGRectMake(0, 0, rect.size.width*2/3, 300);
}
-(void)initControls{
    _view_addnew = [[[NSBundle mainBundle] loadNibNamed:@"ViewAddNewLocation" owner:self options:nil] objectAtIndex:0];
    [_view_addnew initControls];
    _view_postreview = [[[NSBundle mainBundle] loadNibNamed:@"ViewPostReview" owner:self options:nil] objectAtIndex:0];
    _view_setting = [[[NSBundle mainBundle] loadNibNamed:@"ViewSetting" owner:self options:nil] objectAtIndex:0];
    [_view_setting initControl];
    
    [_view_setting.btn_ok addTarget:self action:@selector(ClickDialogButton:) forControlEvents:UIControlEventTouchUpInside];
    _view_setting.btn_ok.tag = ClickDialogButton_SETTINGOK;
    
    _view_savedloc = [[UITableView alloc] init];
    _autocompleteTable = [[UITableView alloc] init];
    _tableview_severalfound = [[[UITableView alloc] init] initWithFrame:CGRectMake(0, 0, 240, 300)];
    
    
    _autocompleteTable.backgroundColor = [UIColor lightGrayColor];
    _autocompleteTable.hidden = true;
    
    [_view_content addSubview:_view_addnew];
    [_view_content addSubview:_view_postreview];
    [_view_content addSubview:_view_savedloc];
    [_view_content addSubview:_view_setting];
    [_view_content addSubview:_autocompleteTable];

    
    
    [self LayoutConfigure];
    
    [_btn_add addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_usemyloc addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_savedloc addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_postreview addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_add.tag = 101;
    _btn_usemyloc.tag = 102;
    _btn_savedloc.tag = 103;
    _btn_postreview.tag = 104;
    
    _img_setting.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_img_setting addGestureRecognizer:gesture];
    _img_setting.tag = 100;

    
    [CGlobal makeBlackBorder:_btn_add];
    [CGlobal makeBlackBorder:_btn_usemyloc];
    [CGlobal makeBlackBorder:_btn_savedloc];
    [CGlobal makeBlackBorder:_btn_postreview];
    
    _hidden_addnew  = true;
    _hidden_postreview  = true;
    _hidden_savedloc  = true;
    _hidden_setting  = true;
    
    _view_addnew.hidden = _hidden_addnew;
    _view_postreview.hidden = _hidden_postreview;
    _view_setting.hidden = _hidden_setting;
    _view_savedloc.hidden = _hidden_savedloc;
    
    
    [_view_postreview initControls];
    [_view_addnew initData];
    [_view_setting initData];
    
    
    [_view_postreview setMyDelegate:self];
    
    _view_addnew.img_search.userInteractionEnabled = true;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickDialogImage:)];
    [_view_addnew.img_search addGestureRecognizer:gesture];
    
    
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickDialogImage:)];
    [_view_postreview.view_searchloc addGestureRecognizer:gesture];
    
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickDialogImage:)];
    [_view_postreview.view_usemyloc addGestureRecognizer:gesture];
    
    
    _view_addnew.img_search.tag = ClickDialogButton_ADDNEWSEARCH;
    _view_postreview.view_usemyloc.tag =ClickDialogButton_POSTREVIEW_USEMYLOC;
    _view_postreview.view_searchloc.tag =ClickDialogButton_POSTREVIEW_SEARCHLOC;
    
    

    _view_postreview.view_searchloc.hidden = true;
    
    _viewforpost = [[UIView alloc] init];
}
-(void)resetFlyingViews{
    _autocompleteTable.hidden = true;
    _view_addnew.hidden = true;
    _view_setting.hidden = true;
    _view_savedloc.hidden = true;
    _view_postreview.hidden = true;
    
    _constraint_addnew.constant = 0;
    _constraint_setting.constant = 0;
    _constraint_savedloc.constant = 0;
    _constraint_postreview.constant = 0;
    
    [_view_addnew setNeedsUpdateConstraints];
    [_view_setting setNeedsUpdateConstraints];
    [_view_savedloc setNeedsUpdateConstraints];
    [_view_postreview setNeedsUpdateConstraints];
    
    
    [_view_addnew layoutIfNeeded];
    [_view_setting layoutIfNeeded];
    [_view_savedloc layoutIfNeeded];
    [_view_postreview layoutIfNeeded];
}
-(void)setAddNew:(BOOL)show withAnimation:(BOOL)animation{
    CGSize size = _view_addnew.frame.size;
    if (!show) {
        _view_addnew.hidden = false;
        _constraint_addnew.constant = -1*size.height;
        [_view_addnew setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_addnew layoutIfNeeded];
            }];
        }else{
            [_view_addnew layoutIfNeeded];
        }
    }else{
        _constraint_addnew.constant = 0;
        [_view_addnew setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                
                [_view_addnew layoutIfNeeded];
                _view_addnew.hidden = true;
            }];
        }else{
            _view_addnew.hidden = true;
            [_view_addnew layoutIfNeeded];
        }
        
    }
    
}
-(void)setSetting:(BOOL)show withAnimation:(BOOL)animation{
    CGSize size = _view_setting.frame.size;
    if (!show) {
        _view_setting.hidden = false;
        _constraint_setting.constant = -1*size.height;
        [_view_setting setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_setting layoutIfNeeded];
            }];
        }else{
            [_view_setting layoutIfNeeded];
        }
    }else{
        _constraint_setting.constant = 0;
        [_view_setting setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                
                [_view_setting layoutIfNeeded];
                _view_setting.hidden = true;
            }];
        }else{
            _view_setting.hidden = true;
            [_view_setting layoutIfNeeded];
        }
        
    }
    _autocompleteTable.hidden = true;
}
-(void)setSavedLoc:(BOOL)show withAnimation:(BOOL)animation{
    CGSize size = _view_savedloc.frame.size;
    if (!show) {
        _view_savedloc.hidden = false;
        _constraint_savedloc.constant = 1*size.height;
        [_view_savedloc setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_savedloc layoutIfNeeded];
            }];
        }else{
            [_view_savedloc layoutIfNeeded];
        }
    }else{
        _constraint_savedloc.constant = 0;
        [_view_savedloc setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_savedloc layoutIfNeeded];
                _view_savedloc.hidden = true;
            }];
        }else{
            _view_savedloc.hidden = true;
            [_view_savedloc layoutIfNeeded];
        }
        
    }
}

-(void)setPostReview:(BOOL)show withAnimation:(BOOL)animation{
    CGSize size = _view_postreview.frame.size;
    if (!show) {
        _view_postreview.hidden = false;
        _constraint_postreview.constant = 1*size.height;
        [_view_postreview setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_postreview layoutIfNeeded];
            }];
        }else{
            [_view_postreview layoutIfNeeded];
        }
    }else{
        _constraint_postreview.constant = 0;
        [_view_postreview setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                
                [_view_postreview layoutIfNeeded];
                _view_postreview.hidden = true;
            }];
        }else{
            _view_postreview.hidden = true;
            [_view_postreview layoutIfNeeded];
        }
        
    }
}
-(void)ClickGesture:(UITapGestureRecognizer*)sender{
    int tag = sender.view.tag;
    if (tag == 100) {
        _hidden_setting = !_hidden_setting;
        [self setSavedLoc:true withAnimation:true];
        [self setPostReview:true withAnimation:true];
        [self setAddNew:true withAnimation:true];
        [self setSetting:_hidden_setting withAnimation:true];
      
    }
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == 101) {
        _hidden_addnew = !_hidden_addnew;
        [self setSavedLoc:true withAnimation:true];
        [self setPostReview:true withAnimation:true];
        [self setAddNew:_hidden_addnew withAnimation:true];
        [self setSetting:true withAnimation:true];
    }else if (tag == 102){
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
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
        
        
        
    }else if(tag == 103){
        _hidden_savedloc = !_hidden_savedloc;
        
        [self setSavedLoc:_hidden_savedloc withAnimation:true];
        [self setPostReview:true withAnimation:true];
        [self setAddNew:true withAnimation:true];
        [self setSetting:true withAnimation:true];
    }else if(tag == 104){
        _hidden_postreview = !_hidden_postreview;
        [self setSavedLoc:true withAnimation:true];
        [self setPostReview:_hidden_postreview withAnimation:true];
        [self setAddNew:true withAnimation:true];
        [self setSetting:true withAnimation:true];
    }
}
-(void) gotoScreen2{
    AppDelegate*delegate = [[UIApplication sharedApplication] delegate];
    
    g_curRegion.isSavedToDb = [delegate hasThisRegion:g_curRegion];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController2",@"reset":@"1"}];
    
    [self resetFlyingViews];
    //
}

-(void)LayoutConfigure{
    CGSize size = _view_addnew.frame.size;
    NSLayoutConstraint *leadingConst = [NSLayoutConstraint constraintWithItem:_view_addnew attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConst = [NSLayoutConstraint constraintWithItem:_view_addnew attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint *widthConst = [NSLayoutConstraint constraintWithItem:_view_addnew attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *heightConst = [NSLayoutConstraint constraintWithItem:_view_addnew attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    
    _constraint_addnew = [NSLayoutConstraint constraintWithItem:_view_addnew attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _view_addnew.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,trailingConst,widthConst,heightConst,_constraint_addnew, nil]];
    
    size = _view_postreview.frame.size;
    leadingConst = [NSLayoutConstraint constraintWithItem:_view_postreview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    trailingConst = [NSLayoutConstraint constraintWithItem:_view_postreview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    widthConst = [NSLayoutConstraint constraintWithItem:_view_postreview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    heightConst = [NSLayoutConstraint constraintWithItem:_view_postreview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    
    _constraint_postreview = [NSLayoutConstraint constraintWithItem:_view_postreview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    _view_postreview.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,trailingConst,widthConst,heightConst,_constraint_postreview, nil]];

    size = _view_savedloc.frame.size;
    leadingConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    trailingConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    widthConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
//    heightConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height];
    heightConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    
    _constraint_savedloc = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    _view_savedloc.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,trailingConst,widthConst,heightConst,_constraint_savedloc, nil]];
    
    size = _view_setting.frame.size;
    leadingConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    trailingConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    widthConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    heightConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    
    _constraint_setting = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _view_setting.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,trailingConst,widthConst,heightConst,_constraint_setting, nil]];
    
    size = _autocompleteTable.frame.size;
    leadingConst = [NSLayoutConstraint constraintWithItem:_autocompleteTable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:130];
    
    
    
    widthConst = [NSLayoutConstraint constraintWithItem:_autocompleteTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-140];
    //    heightConst = [NSLayoutConstraint constraintWithItem:_view_savedloc attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height];
    CGFloat tempheight = 120;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        tempheight = 60;
    }
    heightConst = [NSLayoutConstraint constraintWithItem:_autocompleteTable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:tempheight];
    
    _constraint_autocomplete = [NSLayoutConstraint constraintWithItem:_autocompleteTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view_addnew.searchField attribute:NSLayoutAttributeTop multiplier:1 constant:-8];
    _autocompleteTable.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,widthConst,heightConst,_constraint_autocomplete, nil]];
}
-(void) ClickFastReview:(id)dict{
    int desc = [(NSNumber*)[dict objectForKey:@"desc"] intValue];
    if (desc == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]
                              initWithTitle:@"No Place Found"
                              message:@"Would you like to add this place?"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Add",nil];
        alertview.tag = 101;
        [alertview show];
    }else if (desc == 1){
        // found many results
        UIAlertView *alertview = [[UIAlertView alloc]
                              initWithTitle:@"Several Places Found"
                              message:@"Select the place to post"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Post",nil];
        
        items_placesforpostreview = [[NSMutableArray alloc] init];
        NSArray*array = [dict objectForKey:@"rows"];
        for (id item in array) {
            EftGooglePlace*place = [[EftGooglePlace alloc] initWithDictionary:item];
            [items_placesforpostreview addObject:place];
        }
        
        [alertview setValue:_tableview_severalfound forKey:@"accessoryView"];
        [_tableview_severalfound reloadData];
        
        alertview.tag = 102;
        [alertview show];
    }else if(desc == 2){
        // review added.
        
        EftPlace* place = [[EftPlace alloc] initWithDictionary:[dict objectForKey:@"row_place"]];
        
        EftReview *review = [[EftReview alloc] initWithDictionary:[dict objectForKey:@"ep_review"]];
        //update my review table
        BOOL found = false;
        for (EftPlace*iplace in g_myplaces) {
            if (iplace.ep_id == place.ep_id) {
                
                [iplace.ep_reviews addObject:review];
                found = true;
                break;
            }
        }
        if (!found) {
            [g_myplaces addObject:place];
        }
        
        [self resetFlyingViews];
    }
}
-(void)ClickDialogButton:(UIView*)sender{
    int tag = sender.tag;
    if (tag == ClickDialogButton_SELECTCATEGORYFROMTABLEVIEW) {
        if (g_selIndexPath != nil) {
            EftCategory * selected;
            int row = g_selIndexPath.row;
            int sec = g_selIndexPath.section;
            EftCategory*parent = [g_category objectAtIndex:sec];
            if (row == 0) {
                selected = parent;
            }else{
                selected =  [parent.ec_subcategory objectAtIndex:row-1];
            }
            [_view_postreview setCategory:selected];
            
        }
        [_dialogViewSelectTableView dismissPopup];
    }else if (tag == ClickDialogButton_CATEGORYTXTCLICK){
        g_selIndexPath = nil;
        _dialogViewSelectTableView = [[MyPopupDialog alloc] init];
        _viewSelectTableView = (ViewSelectTableView*)[[[NSBundle mainBundle] loadNibNamed:@"ViewSelectTableView" owner:self options:nil] objectAtIndex:0];
        [_viewSelectTableView initControl:g_category];
        [_dialogViewSelectTableView setup:_viewSelectTableView];
        
        [_dialogViewSelectTableView setLayout:_cgrect_selectcategory.size];
        [_dialogViewSelectTableView layoutIfNeeded];
        
        [_viewSelectTableView setMyDelegate:self];
        [_dialogViewSelectTableView showPopup:self.view];
        
    }else if(tag == ClickDialogButton_POSTREVIEW_POST){
        //
        id arplace = _view_postreview.googleplace;
        NSString*reference;
        UIImage*picture = nil;
        if ([arplace isKindOfClass:[EftPlace class]]) {
            EftPlace*place = (EftPlace*)arplace;
            reference = place.reference;
            picture = place.tmpImage;
        }else if ([arplace isKindOfClass:[EftGooglePlace class]]){
            EftGooglePlace*place = (EftGooglePlace*)arplace;
            reference = place.reference;
            
            picture = place.tmpImage;
        }
        
        g_curReview = [[EftReview alloc] init];
        [g_curReview initData];
        g_curReview.er_text = _view_postreview.txt_review.text;
        
        UIButton*btn = (UIButton*)sender;
        btn.enabled = false;
        if (picture!=nil) {
            NSString*filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            filename = [filename stringByAppendingString:@".jpg"];
            NSString* uploadpath = [g_baseUrl stringByAppendingString:@"uploads/"];
            uploadpath = [uploadpath stringByAppendingString:filename];
            
            
            [CGlobal showIndicator:self];
            NetworkParser *manager = [NetworkParser sharedManager];
            [manager uploadImage:picture ImagePath:uploadpath FileName:filename withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                if (error== nil) {
                    g_curReview.er_picture = uploadpath;
                    [self postReview:reference Sender:btn];
                }else{
                    [CGlobal AlertMessage:@"There's error on uploading Image" Title:nil];
                    [CGlobal stopIndicator:self];
                    btn.enabled = true;
                }
            }];
        }else{
            [self postReview:reference Sender:btn];
            btn.enabled = true;
        }
    }else if(tag == ClickDialogButton_SETTINGOK){
        [self setSetting:true withAnimation:true];
        [_view_setting endEditing:YES];
    }
}
-(void)postReview:(NSString*)reference Sender:(UIButton*)sender{
    [CGlobal showIndicator:self];
    NetworkParser *manager = [NetworkParser sharedManager];
    [manager onAddReview:g_curReview Reference:reference Category:_view_postreview.category_selected withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
//            EftPlace* place = [[EftPlace alloc] initWithDictionary:[dict objectForKey:@"row_place"]];
            
            EftPlace* place = [[EftPlace alloc] initWithDictionary:[dict objectForKey:@"row_place"]];
            
            EftReview *review = [[EftReview alloc] initWithDictionary:[dict objectForKey:@"ep_review"]];
            //update my review table
            BOOL found = false;
            for (EftPlace*iplace in g_myplaces) {
                if (iplace.ep_id == place.ep_id) {
                    
                    [iplace.ep_reviews addObject:review];
                    found = true;
                    break;
                }
            }
            if (!found) {
                [g_myplaces addObject:place];
            }
            
            [self resetFlyingViews];
            
            [_view_postreview initData];
            
            //update review;
        }else{
            [CGlobal AlertMessage:@"Failed to Post Review" Title:nil];
        }
        sender.enabled = true;
        
        [CGlobal stopIndicator:self];
    }];
    
}
-(EftRegion*) checkValidateADDNEW{
    EftRegion *region;
    
    if ([_view_addnew.searchField.text isBlank]) {
        return nil;
    }
    region = [[EftRegion alloc] initData];
    region.erg_type = 1;
    region.erg_city = _view_addnew.searchField.text;
    
    return region;
}
-(BOOL)checkValidateForPostReview{
    if ([_view_postreview.txt_business.text isBlank]) {
        [CGlobal AlertMessage:@"Input Business or Place Name" Title:nil];
        return false;
    }
    if (_view_postreview.category_selected == nil) {
        [CGlobal AlertMessage:@"Select Category" Title:nil];
        return false;
    }
    return true;
}
-(void)ClickDialogImage:(UITapGestureRecognizer*)gesture{
    int tag = gesture.view.tag;
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    if (tag == ClickDialogButton_ADDNEWSEARCH) {
        EftRegion*resgion = [self checkValidateADDNEW];
        if (resgion != nil) {
            g_curRegion = resgion;
            [self gotoScreen2];
            
        }
    }else if (tag == ClickDialogButton_POSTREVIEW_USEMYLOC){
        if ([self checkValidateForPostReview]) {
            if (delegate.cl_location != nil) {
                [CGlobal showIndicator:self];
                NetworkParser *manager = [NetworkParser sharedManager];
                NSString*lat = [NSString stringWithFormat:@"%f", delegate.cl_location.coordinate.latitude];
                NSString*lon = [NSString stringWithFormat:@"%f", delegate.cl_location.coordinate.longitude];
                
                
                [manager onGoogleSearchOne:_view_postreview.category_selected Latitude:lat Longitude:lon Radius:[_view_setting getRadius] Query:_view_postreview.txt_business.text withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                    if (error == nil) {
                        EftGooglePlace*place = [[EftGooglePlace alloc] initWithDictionary:[dict objectForKey:@"row"]];
                        [_view_postreview setPlace:place];
                    }else{
                        _view_postreview.reference = nil;
                    }
                    
                    [CGlobal stopIndicator:self];
                }];
            }else{
                [CGlobal AlertMessage:@"Not Get Location Yet" Title:nil];
            }
            
        }
        
    }else if (tag == ClickDialogButton_POSTREVIEW_SEARCHLOC){
        //need mapview
        [CGlobal showIndicator:self];
        NetworkParser *manager = [NetworkParser sharedManager];
        NSString*lat = @"40.659222";
        NSString*lon = @"-73.937155";
        
        
        [manager onGoogleSearchOne:_view_postreview.category_selected Latitude:lat Longitude:lon Radius:[_view_setting getRadius] Query:_view_postreview.txt_business.text withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                EftGooglePlace*place = [[EftGooglePlace alloc] initWithDictionary:[dict objectForKey:@"row"]];
                [_view_postreview setPlace:place];
            }else{
                _view_postreview.reference = nil;
            }
            
            [CGlobal stopIndicator:self];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ClickTableViewCellRight:(UIView*)sender{
    int tag = sender.tag - 100;
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EftRegion *region = [g_savedLocations objectAtIndex:tag];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.dbManager deleteLocation:region];
        
        g_savedLocations = [delegate.dbManager getLocation];
        [_view_savedloc reloadData];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are You Sure to Delete Location?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    [alert addAction:action]; // 4
    [alert addAction:cancel]; // 5
    
    if([alert popoverPresentationController] != nil){
        [alert popoverPresentationController].sourceView = sender;
    }
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
-(void)getAutoCompletePlaces:(NSString *)searchKey{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // set request timeout
    manager.requestSerializer.timeoutInterval = 5;
    
    NSString *url = [[NSString stringWithFormat:kGoogleAutoCompleteAPI,GoogleDirectionAPI,searchKey] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSLog(@"API : %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        NSDictionary *JSON = responseObject;
        
        items = [NSMutableArray array];
        
        // success
        AutomCompletePlaces *places = [AutomCompletePlaces modelObjectWithDictionary:JSON];
        
        for (Predictions *pred in places.predictions) {
            
            [items addObject:pred.predictionsDescription];
            
        }
        if ([items count]>0) {
            _autocompleteTable.hidden = false;
            [_autocompleteTable reloadData];
        }else{
            _autocompleteTable.hidden = true;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _autocompleteTable.hidden = true;
    }];
    
}
#pragma mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    if (tableView == _autocompleteTable) {
        CellGeneral *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGeneral" forIndexPath:indexPath];
        
        cell.lbl_content.text = items[indexPath.row];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }else if(tableView == _tableview_severalfound  ){
        CellGeneral *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGeneral" forIndexPath:indexPath];
        EftGooglePlace*place = items_placesforpostreview[indexPath.row];
        cell.lbl_content.text = place.name;
        
        cell.backgroundColor = [UIColor lightGrayColor];
        if (items_placesforpostreview_selindex == row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        return cell;
        
    }else{
        static NSString *cellIdentifier = @"CellPlaceName";
        CellPlaceName *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        long row = indexPath.row;
        EftRegion * model = [g_savedLocations objectAtIndex:row];
        [cell setData:model];
        [cell.btn_close addTarget:self action:@selector(ClickTableViewCellRight:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_close.tag = 100+row;
        
        return cell;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _autocompleteTable) {
        if (items.count == 0) {
            tableView.hidden = true;
        }
        return items.count;
    }else if (tableView == _tableview_severalfound){
        return [items_placesforpostreview count];
    }
    return [g_savedLocations count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _autocompleteTable ) {
        return 23;
    }else if (tableView == _tableview_severalfound){
        return 50;
    }
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    if (tableView == _autocompleteTable) {
        _view_addnew.searchField.text = items[indexPath.row];
        
        [_autocompleteTable deselectRowAtIndexPath:indexPath animated:YES];
        
        _autocompleteTable.hidden = true;
        
        return;
    }else if (tableView == _tableview_severalfound){
        int temp = items_placesforpostreview_selindex;
        items_placesforpostreview_selindex = row;
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
        if (temp == items_placesforpostreview_selindex) {
            items_placesforpostreview_selindex = -1;
        }else{
            if (temp != -1) {
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:temp inSection:indexPath.section];
                [array addObject:indexPath1];
            }
        }
        
        [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        
        return;
    }
    EftRegion *region = [g_savedLocations objectAtIndex:row];
    g_curRegion = region;
    [self gotoScreen2];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![textField.text isEqualToString:@""]) {
        [self getAutoCompletePlaces:textField.text];
        
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
