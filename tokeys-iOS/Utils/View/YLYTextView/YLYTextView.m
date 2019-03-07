//
//  YLYTextView.m
//  zishu-ios
//
//  Created by 杨卢银 on 15/10/8.
//  Copyright © 2015年 杨卢银. All rights reserved.
//

#import "YLYTextView.h"

@interface YLYTextView ()
{
    UILabel *PlaceholderLabel;
}
#pragma mark - Synthesize


@property (strong , nonatomic) UILabel *placeholderLabel;

@end


@implementation YLYTextView


- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self awakeFromNib];
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)layoutSubviews{
    [self drawDashedBorder];
}
- (void)initialize
{
    [self drawDashedBorder];
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self initialize];
    NSString *p = self.placeholder;
    self.placeholder = p;
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self initialize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    float left=0,top=0,hegiht=30;
    
    self.placeholderColor = [UIColor lightGrayColor];
    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , CGRectGetWidth(self.frame)-2*left, hegiht)];
    PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
    PlaceholderLabel.textColor=self.placeholderColor;
    PlaceholderLabel.numberOfLines = 1000;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    PlaceholderLabel.font  = self.font;
    
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
        PlaceholderLabel.text=placeholder;
        NSMutableString *string = [[NSMutableString alloc]initWithString:placeholder];
        CGRect ss = [string boundingRectWithSize:CGSizeMake(self.bounds.size.width, 142) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
        float left=2,top=8,hegiht=ss.size.height;
        
        self.placeholderColor = [UIColor lightGrayColor];
        PlaceholderLabel.frame = CGRectMake(left, top, CGRectGetWidth(self.frame)-2*left, hegiht);
        [PlaceholderLabel sizeToFit];
        if(self.text.length>0){
            PlaceholderLabel.hidden=YES;
        }else{
            PlaceholderLabel.hidden=NO;
        }
    }
    _placeholder=placeholder;
    
    
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PlaceholderLabel removeFromSuperview];
    
}


#pragma mark - Drawing


- (void)drawDashedBorder
{
    if (_shapeLayer) [_shapeLayer removeFromSuperlayer];
    
    //border definitions
    CGFloat cornerRadius = _cornerRadius;
    CGFloat borderWidth = _borderWidth;
    NSInteger dashPattern1 = _dashPattern;
    NSInteger dashPattern2 = _spacePattern;
    UIColor *lineColor = _borderColor ? _borderColor : [UIColor blackColor];
    
    //drawing
    CGRect frame = self.bounds;
    
    _shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = _borderType == YLYBorderTypeDashed ? [NSArray arrayWithObjects:[NSNumber numberWithInteger:dashPattern1], [NSNumber numberWithInteger:dashPattern2], nil] : nil;
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view
    [self.layer addSublayer:_shapeLayer];
    self.layer.cornerRadius = cornerRadius;
}


#pragma mark - Setters


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self drawDashedBorder];
}


- (void)setBorderType:(YLYBorderType)borderType
{
    _borderType = borderType;
    
    [self drawDashedBorder];
}


- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    [self drawDashedBorder];
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    [self drawDashedBorder];
}


- (void)setDashPattern:(NSUInteger)dashPattern
{
    _dashPattern = dashPattern;
    
    [self drawDashedBorder];
}


- (void)setSpacePattern:(NSUInteger)spacePattern
{
    _spacePattern = spacePattern;
    
    [self drawDashedBorder];
}


- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    [self drawDashedBorder];
}
@end
