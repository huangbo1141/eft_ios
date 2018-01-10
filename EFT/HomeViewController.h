//
//  HomeViewController.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewAddNewLocation.h"
#import "ViewPostReview.h"
#import "ViewSetting.h"
#import "CGlobal.h"
#import "ViewSelectTableView.h"
#import "MyPopupDialog.h"
@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak,nonatomic) IBOutlet UIButton * btn_add;
@property (weak,nonatomic) IBOutlet UIButton * btn_usemyloc;
@property (weak,nonatomic) IBOutlet UIButton * btn_savedloc;
@property (weak,nonatomic) IBOutlet UIButton * btn_postreview;

@property (weak,nonatomic) IBOutlet UIView * view_content;

@property (weak,nonatomic) IBOutlet UIImageView * img_setting;

@property (strong,nonatomic) ViewAddNewLocation*view_addnew;
@property (strong,nonatomic) ViewPostReview*view_postreview;
@property (strong,nonatomic) ViewSetting*view_setting;
@property (strong,nonatomic) UITableView*view_savedloc;

@property (strong,nonatomic) NSLayoutConstraint *constraint_addnew;
@property (strong,nonatomic) NSLayoutConstraint *constraint_postreview;
@property (strong,nonatomic) NSLayoutConstraint *constraint_savedloc;
@property (strong,nonatomic) NSLayoutConstraint *constraint_setting;
@property (strong,nonatomic) NSLayoutConstraint *constraint_autocomplete;

@property (strong,nonatomic) NSLayoutConstraint *constraint_addnew_heightConst;

@property (strong,nonatomic) NSLayoutConstraint *constraint_viewwidth;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewheight;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewleading;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewtop;

@property (assign,nonatomic) BOOL hidden_addnew;
@property (assign,nonatomic) BOOL hidden_postreview;
@property (assign,nonatomic) BOOL hidden_savedloc;
@property (assign,nonatomic) BOOL hidden_setting;

@property (strong,nonatomic) ViewSelectTableView * viewSelectTableView;
@property (strong,nonatomic) MyPopupDialog * dialogViewSelectTableView;


@property (nonatomic,strong) UITableView *autocompleteTable;
@property (nonatomic,strong) UITableView *tableview_severalfound;
@end
