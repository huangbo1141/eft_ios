//
//  MyPopupDialog.m
//  SchoolApp
//
//  Created by TwinkleStar on 11/28/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import "MyPopupDialog.h"

@implementation MyPopupDialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) setup:(UIView<ViewLayoutActionProtocol>*) view backgroundDismiss:(BOOL) dismiss backgroundMode:(NSInteger) mode{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    
    _contentview = view;
    _contentview.center = self.center;
    [self addSubview:_contentview];
    
    _backgroundview = [[UIView alloc]initWithFrame:frame];
    _backgroundview.alpha = 0.0;
    switch (mode) {
        case 1:
            _backgroundview.backgroundColor = [UIColor grayColor];
            break;
            
        default:
            _backgroundview.backgroundColor = [UIColor whiteColor];
            break;
    }
    
    [self insertSubview:_backgroundview belowSubview:_contentview];
    
    if(dismiss){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView:)];
        [_backgroundview addGestureRecognizer:gesture];
    }
    
}
-(void)setLayout:(CGSize) rect{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    _contentview.frame = CGRectMake(0, 0, rect.width, rect.height);
    _contentview.center = self.center;
    
    _backgroundview.frame = frame;
    
    if ([_contentview respondsToSelector:@selector(setLayout:)]) {
        
        [_contentview setLayout:rect];
    }
    [self layoutIfNeeded];
}
-(void) ClickView:(id) sender{
    [self dismissPopup];
}
-(void) setup:(UIView<ViewLayoutActionProtocol>*) view{
    [self setup:view backgroundDismiss:true backgroundMode:0];
}
-(void) setup:(UIView<ViewLayoutActionProtocol>*) view Mode:(int) mode{
    [self setup:view backgroundDismiss:true backgroundMode:mode];
}
-(void)showPopup:(UIView*) root{
    [root addSubview:self];
    [self showAnimation];
    _isShowing = true;
}

-(void)showAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundview.alpha = 0.2;
    }];
}
-(void)dismissPopup{
    [self removeFromSuperview];
    _isShowing = false;
}
@end
