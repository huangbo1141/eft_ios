//
//  MyPopupDialog.h
//  SchoolApp
//
//  Created by TwinkleStar on 11/28/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewLayoutActionProtocol <NSObject>

@optional
-(void)setLayout:(CGSize) rect;

@end

@interface MyPopupDialog : UIView

@property (nonatomic,strong) UIView* backgroundview;
@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic,weak) id delegate;
@property (nonatomic,weak) UIView<ViewLayoutActionProtocol>* contentview;

-(void) setup:(UIView<ViewLayoutActionProtocol>*) view backgroundDismiss:(BOOL) dismiss backgroundMode:(NSInteger) mode;
-(void) setup:(UIView<ViewLayoutActionProtocol>*) view;
-(void)showPopup:(UIView*) root;
-(void)showAnimation;
-(void)dismissPopup;
-(void)setLayout:(CGSize) rect;
-(void) setup:(UIView<ViewLayoutActionProtocol>*) view Mode:(int) mode;
@end
