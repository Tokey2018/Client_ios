//
//  XYPopView.m
//  FUGenealogySDK
//
//  Created by 杨卢银 on 16/8/29.
//  Copyright © 2016年 杨卢银. All rights reserved.
//

#import "XYPopView.h"
#import "XYFuncTableViewCell.h"
#import "XYFuncModel.h"
#import "UIImage+RTTint.h"

#define kScreenHeight  CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
/**
 *  设置颜色RGB值
 */
//#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

@interface XYPopView ()<UITableViewDataSource, UITableViewDelegate>
{
    UIColor *showColor;
    
    UIView *rootView;
    
}
@property (strong, nonatomic)  UIControl *bgControl;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static const CGFloat everyW = width;
static const CGFloat everyH = rowH;

// tableView的最小高度为10，会随着cell个数的增加改变
static CGFloat height = 10;
static const CGFloat maxH = 10 + everyH * 4;

@implementation XYPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    showColor = [UIColor whiteColor];
    _bgView.backgroundColor = [UIColor clearColor];
}


+ (instancetype)popViewWithFuncModels:(NSArray *)funcModels{
    
    XYPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"XYPopView" owner:self options:nil].lastObject;
    popView.backgroundColor = [UIColor clearColor];
    popView.funcModels = [@[] mutableCopy];
    if (funcModels && funcModels.count) {
        height = 10 + everyH * funcModels.count;
        popView.funcModels = [funcModels mutableCopy];
    }
    // 最大高度为4个选项的高度
    height = height > maxH ? maxH : height;
    // 设置弹出视图的位置
    popView.frame = CGRectMake(kScreenWidth - everyW - 20 , 64, everyW, height);
    [popView createUIWithCount:popView.funcModels.count];
    popView.bgView.backgroundColor = [UIColor greenColor];
    return popView;
}
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts x:(CGFloat)x y:(CGFloat)y{
    XYPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"XYPopView" owner:self options:nil].lastObject;
    
    popView.backgroundColor = [UIColor clearColor];
    popView.funcModels = [@[] mutableCopy];
    
    if (funcDicts && funcDicts.count) {
        for (NSDictionary *dict in funcDicts) {
            XYFuncModel *funcModel = [[XYFuncModel alloc] initWithDict:dict];
            [popView.funcModels addObject:funcModel];
        }
        height = 10 + everyH * popView.funcModels.count;
        
    }
    // 最大高度为4个选项的高度
    height = height > maxH ? maxH : height;
    // 设置弹出视图的位置
    popView.frame = CGRectMake(x , y, everyW, height);
    [popView createUIWithCount:popView.funcModels.count];
//    popView.bgView.backgroundColor = [UIColor greenColor];
    return popView;
}
+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts{
    return [self popViewWithFuncDicts:funcDicts x:kScreenWidth - everyW - 20 y:64];
//    XYPopView *popView = [[NSBundle mainBundle] loadNibNamed:FUGE_PATH(@"XYPopView") owner:self options:nil].lastObject;
//    
//    popView.backgroundColor = [UIColor clearColor];
//    popView.funcModels = [@[] mutableCopy];
//    
//    if (funcDicts && funcDicts.count) {
//        for (NSDictionary *dict in funcDicts) {
//            XYFuncModel *funcModel = [[XYFuncModel alloc] initWithDict:dict];
//            [popView.funcModels addObject:funcModel];
//        }
//        height = 10 + everyH * popView.funcModels.count;
//        
//    }
//    // 最大高度为4个选项的高度
//    height = height > maxH ? maxH : height;
//    // 设置弹出视图的位置
//    popView.frame = CGRectMake(kScreenWidth - everyW - 20 , 64, everyW, height);
//    [popView createUIWithCount:popView.funcModels.count];
//    //popView.bgView.backgroundColor = [UIColor greenColor];
//    return popView;
}
- (void)createUIWithCount:(NSInteger)count{
    
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.rowHeight = everyH;
    // 大于4项可以滚动
    self.tableView.scrollEnabled = count >4 ? YES : NO;
    //self.bgView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = showColor;
    
    // 画三角形
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width - 25, 10)];
    [path addLineToPoint:CGPointMake(width - 20, 2)];
    [path addLineToPoint:CGPointMake(width - 15, 10)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    // 颜色设置和cell颜色一样
    layer.fillColor = showColor.CGColor;
    layer.strokeColor = showColor.CGColor;
    layer.path = path.CGPath;
    [self.bgView.layer addSublayer:layer];
    
}
-(UIControl *)bgControl{
    if (_bgControl==nil) {
        _bgControl = [[UIControl alloc]init];
    }
    return _bgControl;
}
-(void)bgControlTouchBegin:(UIControl *)sender{
    [self dismissFromKeyWindow];
}
-(void)showInView:(UIView *)view{
    
    rootView = view;
    
    _isShow = YES;
    self.alpha = 0;
    
    self.bgControl.frame = view.frame;
    
    [self.bgControl addTarget:self action:@selector(bgControlTouchBegin:) forControlEvents:UIControlEventTouchUpInside];
    self.bgControl.backgroundColor = [UIColor blackColor];
    self.bgControl.alpha = 0.4;
    
    [view addSubview:self.bgControl];
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}
- (void)showInKeyWindow{
    _isShow = YES;
    self.alpha = 0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    rootView = keyWindow;
    self.bgControl.frame = keyWindow.frame;
    [self.bgControl addTarget:self action:@selector(bgControlTouchBegin:) forControlEvents:UIControlEventTouchUpInside];
    self.bgControl.backgroundColor = [UIColor clearColor];
//    self.bgControl.alpha = 0.6;
    
    [keyWindow addSubview:self.bgControl];
    
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissFromKeyWindow{
    _isShow = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.transform = CGAffineTransformTranslate(self.transform, 40, -64);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        [self.bgControl removeFromSuperview];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"funcCell";
    XYFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XYFuncTableViewCell" owner:self options:nil].lastObject;
    }
    
    if (!self.funcModels.count) {
        return cell;
    }
    
    
    
    cell.funcModel = self.funcModels[indexPath.row];
    
    cell.iconImgView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xy_top_imageViewSelect:)];
    [cell.iconImgView addGestureRecognizer:tap];
    
    cell.contentView.backgroundColor = showColor;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        
//        
//    }
//    if (!self.funcModels.count) {
//        return cell;
//    }
//    XYFuncModel *funcModel = self.funcModels[indexPath.row];
//    UIImage *image = [[UIImage imageNamed:funcModel.iconName] rt_tintedImageWithColor:[UIColor whiteColor]];
//    if (image) {
//        
//        UIImage *icon = image;
//        CGSize itemSize = CGSizeMake(30, 30);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        
//        cell.imageView.image = icon;
//        
//    }else{
//        cell.imageView.image = nil;
//    }
//    cell.imageView.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xy_top_imageViewSelect:)];
//    [cell.imageView addGestureRecognizer:tap];
//    
//    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
//    cell.textLabel.text = funcModel.title;
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.contentView.backgroundColor = showColor;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    //NSLog(@"%ld", indexPath.row);
    
    if(self.menuSelectBlock){
        self.menuSelectBlock (indexPath.row);
    }
    
    //[self dismissFromKeyWindow];
}
-(void)xy_top_imageViewSelect:(UITapGestureRecognizer*)sender{
    NSIndexPath *indexPath = [self indexsPathFromView:sender.view byTableView:_tableView];
    
    if(self.menuIconSelectBlock){
        self.menuIconSelectBlock (indexPath.row);
    }
}

/**
 *通过View 找到indexPath
 */
-(NSIndexPath*)indexsPathFromView:(UIView*)view byTableView:(UITableView*)tableView
{
    UIView *parentView = [view superview];
    
    while (![parentView isKindOfClass:[UITableViewCell class]] && parentView!=nil) {
        parentView = parentView.superview;
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell*)parentView];
    return indexPath;
}

@end
