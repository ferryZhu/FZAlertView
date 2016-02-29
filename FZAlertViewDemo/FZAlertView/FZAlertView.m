//
//  FZAlertView.m
//  FZAlertViewDemo
//
//  Created by FerryZhu on 16/2/24.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import "FZAlertView.h"
#import "AppDelegate.h"

#define kDeviceWidth        [UIScreen mainScreen].bounds.size.width      // 界面宽度
#define kDeviceHeight       [UIScreen mainScreen].bounds.size.height     // 界面高度
#define kLineColor          [UIColor colorWithRed:219 / 255.0 green:219 / 255.0 blue:223 / 255.0 alpha:1]
#define kButtonColor        [UIColor colorWithRed:0 / 255.0 green:122 / 255.0 blue:255 / 255.0 alpha:1]
#define kButtonHeight       45
#define kButtonTag          10000

@interface FZAlertView ()

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSMutableArray *otherButtonArray;

@end

@implementation FZAlertView

@synthesize alertView = alertView;

+ (id)showAlertViewWithTitle:(NSString *)title message:(NSString *)message customzizationBlock:(CustomizationBlock)customzization completionBlock:(CompletionBlock)completionBlock cancleButtonTitle:(NSString *)cancleButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ...
{
    NSMutableArray *otherButtonTitilesArray = [[NSMutableArray alloc] init];
    if (otherButtonTitle != nil) {  // frist arguments isn't part of varargs list
        [otherButtonTitilesArray addObject:otherButtonTitle];
        va_list argumentList;
        va_start(argumentList, otherButtonTitle);
        id eachObject;
        while ((eachObject = va_arg(argumentList, id))) {
            [otherButtonTitilesArray addObject:eachObject];
        }
        va_end(argumentList);
    }
    
    FZAlertView *alertView = [[FZAlertView alloc] initWithTitle:title message:message completionBlock:completionBlock cancleButtonTitle:cancleButtonTitle otherButtonTitles:otherButtonTitilesArray];
    
    if (customzization) {
        customzization(alertView);
    }
    
    [alertView show];
    
    return alertView;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(CompletionBlock)completionBlock cancleButtonTitle:(NSString *)cancleButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, kDeviceHeight)];
    
    if (self) {
        
        self.otherButtonArray = [NSMutableArray array];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        [self addSubview:backgroundView];
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
        float messageHeight = [message boundingRectWithSize:CGSizeMake(kDeviceWidth - 150.0, MAXFLOAT) options: NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(50.0, (kDeviceHeight - 85 - messageHeight - otherButtonTitles.count * kButtonHeight) / 2, kDeviceWidth - 100.0, 85 + messageHeight + otherButtonTitles.count * kButtonHeight)];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.cornerRadius = 5;
        [self addSubview:alertView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 30.0, kDeviceWidth - 150, 23.0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:23.0];
        _titleLabel.text = title;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [alertView addSubview:_titleLabel];

        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 15.0, alertView.frame.size.width - 50.0, messageHeight)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont systemFontOfSize:13.0];
        _messageLabel.text = message;
        _messageLabel.numberOfLines = 0;
        [alertView addSubview:_messageLabel];
        
        int count = 0; // button count
        
        if (otherButtonTitles.count == 1) {
            
            float buttonWidth = alertView.frame.size.width / 2;
            if (cancleButtonTitle) {
                [self createFZButton:CGRectMake(0.0, 85 + messageHeight, buttonWidth, kButtonHeight) title:cancleButtonTitle tag:0];
            }
            
            [self createFZButton:CGRectMake(buttonWidth, 85 + messageHeight, buttonWidth, kButtonHeight) title:[otherButtonTitles lastObject] tag:1];
            
            count = 1;
            
        } else if(otherButtonTitles.count > 1) {
            
            if (cancleButtonTitle) {
                [self createFZButton:CGRectMake(0.0, 85 + messageHeight, alertView.frame.size.width, kButtonHeight) title:cancleButtonTitle tag:0];
                count = 1;
            }
            for (int i = 0; i < otherButtonTitles.count; i++) {
                
                [self createFZButton:CGRectMake(0.0, 85 + messageHeight + count * kButtonHeight, alertView.frame.size.width, kButtonHeight)
                               title:[otherButtonTitles objectAtIndex:i]
                                 tag:count];
                count ++;
            }
        } else {
            if (cancleButtonTitle) {
                [self createFZButton:CGRectMake(0.0, 85 + messageHeight, alertView.frame.size.width, kButtonHeight) title:cancleButtonTitle tag:0];
                count = 1;
            }
        }
        
        CGRect frame = alertView.frame;
        frame.size.height =  85 + messageHeight + count * kButtonHeight;
        frame.origin.y = (kDeviceHeight - 85 - messageHeight - count * kButtonHeight) / 2;
        alertView.frame = frame;
        
        if (completionBlock) {
             self.completionBlock = completionBlock;
        }
    }
    
    return self;
}

- (void)show
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *keyWindow = delegate.window;
    [keyWindow addSubview:self];
    [self shakeToShow:alertView];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
}

- (void)buttonAction:(UIButton *)sender
{
    [self hide];
    if (self.completionBlock) {
        self.completionBlock(self, (int)sender.tag - kButtonTag);
    }
}

- (void)shakeToShow:(UIView*)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)createFZButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.origin.y - 0.4, alertView.frame.size.width, 0.5)];
    lineView.backgroundColor = kLineColor;
    [alertView addSubview:lineView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag + kButtonTag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kButtonColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:button];
    
    if (tag != 0) {
        [_otherButtonArray addObject:button];
    }
}

// Setter Method
- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        _titleLabel.textColor = _titleColor;
    }
}

- (void)setMessageColor:(UIColor *)messageColor
{
    if (_messageColor != messageColor) {
        _messageColor = messageColor;
        _messageLabel.textColor = _messageColor;
    }
}

- (void)setCancleButtonColor:(UIColor *)cancleButtonColor
{
    if (_cancleButtonColor != cancleButtonColor) {
        _cancleButtonColor = cancleButtonColor;
         UIButton *cancleButton = (UIButton *)[alertView viewWithTag:kButtonTag];
        if (cancleButton) {
             [cancleButton setTitleColor:_cancleButtonColor forState:UIControlStateNormal];
        }
    }
}

- (void)setOtherButtonColor:(UIColor *)otherButtonColor
{
    if (_otherButtonColor != otherButtonColor) {
        _otherButtonColor = otherButtonColor;
        
        for (UIButton *otherButton in _otherButtonArray) {
            [otherButton setTitleColor:_otherButtonColor forState:UIControlStateNormal];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
