//
//  ViewSelectTableView.m
//  EFT
//
//  Created by Twinklestar on 12/11/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "ViewSelectTableView.h"
#import "CellGeneral.h"
#import "CGlobal.h"
@implementation ViewSelectTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setLayout:(CGSize)size{
    
    CGSize buttonsize = CGSizeMake(80, 40);
    CGFloat buttonx = size.width - buttonsize.width - 10;
    CGFloat buttony = 10;
    _btn_select.frame = CGRectMake(buttonx, buttony, buttonsize.width, buttonsize.height);
    
    CGSize tablesize = CGSizeMake(size.width - 10*2, size.height - 10*3 - buttonsize.height);
    CGFloat tablex = 10;
    CGFloat tabley = buttony + 10 + buttonsize.height;
    _tableview.frame = CGRectMake(tablex, tabley, tablesize.width, tablesize.height);
    
    [self setNeedsLayout];
    
}
-(void)ClickView:(UIView*)sender{
    
    if ([_mydelegate respondsToSelector:@selector(ClickDialogButton:)]) {
        g_selIndexPath = _index;
        [_mydelegate performSelector:@selector(ClickDialogButton:) withObject:sender];
    }
}
-(void)setMyDelegate:(id) delegate{
    if (_mydelegate != delegate) {
        _mydelegate = delegate;
    }
    
}
-(void)initControl:(NSMutableArray*)data{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    
    _btn_select = [[UIButton alloc] initWithFrame:rect];
    
    [_btn_select setTitle:@"Select" forState:UIControlStateNormal];
    
    
    _tableview = [[UITableView alloc] initWithFrame:rect];
    
    _data = data;
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [_tableview registerNib:[UINib nibWithNibName:@"CellGeneral" bundle:nil] forCellReuseIdentifier:@"CellGeneral"];
    
    [_btn_select addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn_select.tag = ClickDialogButton_SELECTCATEGORYFROMTABLEVIEW;
    
    [self addSubview:_btn_select];
    [self addSubview:_tableview];
    
    [self initData];
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void) initData{
    _index = nil;
}
#pragma mark - tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellGeneral";
    CellGeneral *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    long row = indexPath.row;
    long section = indexPath.section;
    if (row == 0) {
        EftCategory*cat = [_data objectAtIndex:section];
        [cell setHeaderData:cat];
    }else{
        EftCategory*parent = [_data objectAtIndex:section];
        EftCategory*cat =  [parent.ec_subcategory objectAtIndex:row-1];
        [cell setData:cat];
    }
    
    if ([indexPath isEqual:_index]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EftCategory*cat = [_data objectAtIndex:section];
    return [cat.ec_subcategory count]+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_data count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    NSIndexPath* tmp = _index;
    _index = indexPath;
    
    if (tmp == _index) {
        _index = nil;
        [_tableview reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        [paths addObject:indexPath];
        if (tmp !=nil ) {
            [paths addObject:tmp];
        }
        [_tableview reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
    
}
@end
