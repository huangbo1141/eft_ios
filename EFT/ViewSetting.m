//
//  ViewSetting.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "ViewSetting.h"
#import "CGlobal.h"
@implementation ViewSetting

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) initControl{
//    [_btn_ok addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    [self initData];
}
-(void)initData{
    _txt_radius.text = [NSString stringWithFormat:@"%d",g_curRadius];
}
-(NSString*)getRadius{
    return _txt_radius.text;
}
-(void)ClickView:(UIView*)sender{
    
}
@end
