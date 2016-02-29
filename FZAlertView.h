//
//  FZAlertView.h
//  FZAlertViewDemo
//
//  Created by FerryZhu on 16/2/24.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZAlertView;

typedef void(^CompletionBlock)(FZAlertView *alertView, NSInteger indexPath);

typedef void(^CustomizationBlock) (FZAlertView *alertView);

@interface FZAlertView : UIView

@property (nonatomic, copy) CompletionBlock completionBlock;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *messageColor;

@property (nonatomic, strong) UIColor *cancleButtonColor;

@property (nonatomic, strong) UIColor *otherButtonColor;

+ (id)showAlertViewWithTitle:(NSString *)title message:(NSString *)message customzizationBlock:(CustomizationBlock)customzization completionBlock:(CompletionBlock)completionBlock cancleButtonTitle:(NSString *)cancleButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;
@end
