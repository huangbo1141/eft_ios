//
//  ViewSelectTableView.h
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPopupDialog.h"
@interface ViewSelectTableView : UIView<UITableViewDataSource,UITableViewDelegate,ViewLayoutActionProtocol>

@property (strong,nonatomic) UIButton *btn_select;
@property (strong,nonatomic) UITableView *tableview;

-(void)setLayout:(CGSize)size;

@property (weak,nonatomic) NSArray *data;
@property (strong,nonatomic) NSIndexPath* index;

-(void)initControl:(NSMutableArray*)data;
-(void) initData;

@property (weak,nonatomic) id mydelegate;
-(void)setMyDelegate:(id) delegate;


@end
