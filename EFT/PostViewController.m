//
//  PostViewController.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "PostViewController.h"
#import "CGlobal.h"
//#import "SWRevealViewController.h"
#import "MHCustomTabBarController.h"
#import "NSString+Common.h"
#import "CellSubCategory.h"
@interface PostViewController ()
@property (nonatomic,assign) CGFloat geometry_cellwidth;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self calcRegion];
    [self initData];
    [self initControls];
}
-(void)initData{
    EftPlace*place =  [g_places objectAtIndex:g_selectedReview];
    
    _lbl_title.text = place.ep_name;
    _lbl_rating.text = [NSString stringWithFormat:@"%.1f", place.ep_rating];
    _lbl_ratingright.text = place.temp_ratingright;
    
    _lbl_place.text = place.ep_name;
    _lbl_itemcategory.text = @"";
    _hcss_star.minimumValue = 0;
    _hcss_star.maximumValue = 5.0;
    _hcss_star.value = place.ep_rating;
    _hcss_star.userInteractionEnabled = false;
    _hcss_star.tintColor = [UIColor yellowColor];
    _hcss_star.backgroundColor = [UIColor clearColor];
    
    _img_star.tintColor = [UIColor yellowColor];
    
    
    _lbl_address.text = place.googlePlace.formatted_address;
    _lbl_phone.text = place.googlePlace.formatted_phone_number;
    
    if (![place.ep_photopath isBlank]) {
        _img_content.imageURL = [NSURL URLWithString:place.ep_photopath];
    }
    
    
    
}
-(void)calcRegion{
    CGRect rect = [UIScreen mainScreen].bounds;
    CGSize size = rect.size;
    _geometry_cellwidth = size.width-20;
}
-(void)initControls{
    [_btn_star addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_topcell addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_back addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_topcell.tag = 100;
    _btn_star.tag = 101;
    _btn_back.tag = 102;
    
    _tableview_reviews.delegate = self;
    _tableview_reviews.dataSource = self;
    
    [_tableview_reviews registerNib:[UINib nibWithNibName:@"CellSubCategory" bundle:nil] forCellReuseIdentifier:@"CellSubCategory"];
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if(tag == 100){
        
    }else if(tag == 101){
        
    }else if (tag == 102) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController2"}];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _scrollview.contentSize = CGSizeMake(rect.size.width, rect.size.height);
    
    [self.view layoutIfNeeded];
    
}
-(void)clearContainerConstraints{
    if (_constraint_viewheight!=nil && _constraint_viewwidth!=nil) {
        [self.view removeConstraints:[[NSArray alloc] initWithObjects:_constraint_viewheight,_constraint_viewwidth,_constraint_viewleading,_constraint_viewtop, nil]];
        _constraint_viewwidth = nil;
        _constraint_viewheight = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EftPlace*place =  [g_places objectAtIndex:g_selectedReview];
    return [place.ep_reviews count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellSubCategory";
    CellSubCategory *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    int row = indexPath.row;
    EftPlace*place =  [g_places objectAtIndex:g_selectedReview];
    EftReview*review =  [place.ep_reviews objectAtIndex:row];
    
    [cell setDataForReview:review];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    EftPlace*place =  [g_places objectAtIndex:g_selectedReview];
    EftReview*review =  [place.ep_reviews objectAtIndex:row];
    UIFont*font = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGFloat height = [CGlobal heightForView:review.er_text Font:font Width:_geometry_cellwidth];
    return height+20;
}
@end
