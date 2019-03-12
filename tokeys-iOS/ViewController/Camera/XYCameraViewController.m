//
//  XYCameraViewController.m
//  tokeys
//
//  Created by 杨卢银 on 2018/6/6.
//  Copyright © 2018年 liujianji. All rights reserved.
//

#import "XYCameraViewController.h"
#import "WRNavigationBar.h"
#import "Masonry.h"
#import "SDPieLoopProgressView.h"
#import "ZZCircleProgress.h"
#import "XYCircleProgress.h"
#import "TKSelectPeople.h"
#import "TKInviteViewController.h"
#import "XYCameraPhotoCell.h"

@interface XYCameraViewController ()<AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *bottonBTBGView;
@property (weak, nonatomic) IBOutlet UIButton *bottonBT;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic,strong)AVCaptureSession *session;
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据

@property (nonatomic,strong)AVAssetWriter *videoWriter;
@property (nonatomic,strong)AVAssetWriterInput *videoWriterInput;
@property (nonatomic,strong)AVAssetWriterInput *audioWriterInput;
@property (nonatomic,strong)AVAssetWriterInputPixelBufferAdaptor*adaptor;
@property (nonatomic,strong)AVCaptureAudioDataOutput * audioOutput;

//**************
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSArray * arr;
@property (nonatomic,strong)NSArray * groupArr;
@property (nonatomic,copy  )NSString * str;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;
@property (nonatomic,assign)NSInteger pltime;

@property (nonatomic,strong)UIImage *image;
/** 图片数组 */
@property (nonatomic,strong)NSMutableArray *picDataArr;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@end

@implementation XYCameraViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
}
-(void)setup{
    
    [self initCamera];
    [self initUI];
    [self cameraExchange:nil];
    [self loadData];
}

-(void)timeChange{
    
    _time--;
    XYLog(@"---%ld",_time);
    //_label.text = [NSString stringWithFormat:@"00 : 00 : %.2ld",_time];
    _pltime++;
    self.progressView.progress = (_pltime)/30.0;
    //   self.circleAniView.percentStr = str;
    if (_time==0) {
        // [self.output stopRecording];
        [self stopVideo];
        
        
    }
}

-(void)loadData{
    _picDataArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    _time = 30;
    _pltime = 0;
    
    if(_dataArr.count==0){
        TKSelectPeople * user  = [[TKSelectPeople alloc]init];
        user.infoNme = @"本地文档";
        user.isWendang = YES;
        user.name = @"本地文档";
        [_dataArr addObject:user];
    }
    
    
    _arr = [[[NIMSDK sharedSDK] userManager] myFriends];
    for( NIMUser * user in _arr){
        TKSelectPeople * sele = [[TKSelectPeople alloc]init];
        sele.name = user.userId;
        sele.infoNme = user.alias;
        sele.isGroup = NO;
        NSLog(@"11111111%@",sele.infoNme);
        if(sele.infoNme.length!=0){
            [_dataArr addObject:sele];
        }
    }
    
    _groupArr = [[[NIMSDK sharedSDK]teamManager]allMyTeams];
    for( NIMTeam * team in _groupArr){
        TKSelectPeople * sele = [[TKSelectPeople alloc]init];
        sele.name = team.teamId;
        sele.infoNme = team.teamName;
        sele.isGroup = YES;
        NSLog(@"%@",team.teamName);
        if(sele.infoNme.length!=0){
            [_dataArr addObject:sele];
        }
        
    }
    NSLog(@"%ld",_dataArr.count);
}
#pragma mark - 结束录制
-(void)stopVideo{
    
    _bottonBT.selected = NO;
    
    //设置录制视频保存的路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    [self.session stopRunning];
    [self.videoWriter finishWriting];
    TKInviteViewController * invite = [[TKInviteViewController alloc]init];
    invite.dataArr = [NSMutableArray arrayWithArray:_dataArr];
    invite.isVideo = YES;
    invite.pathStr = _str;
    invite.picDataArr = [NSMutableArray array];
  
    [self.rootVC.navigationController pushViewController:invite animated:YES];
    
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
-(void)initUI{
    
    [_bottonBTBGView setRoundView];
    [_bottonBTBGView setBackgroundColor:[UIColor clearColor]];
    
    [_bottonBT setRoundView];
//    [_bottonBTBGView setBorderWidth:5.0 borderColor:[UIColor whiteColor]];
    
    _progressView.pathBackColor = [UIColor whiteColor];
    _progressView.pathFillColor = blcolor;
    _progressView.progress = 0.0;
    _progressView.startAngle = -90;
    _progressView.strokeWidth = 5.0;
    _progressView.showPoint = NO;
    _progressView.increaseFromLast = YES;
    _progressView.showProgressText = NO;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // UICollectionViewFlowLayout流水布局的内部成员属性有以下：
    
    float w =(screen_width)/3.0;
    // 定义大小
    layout.itemSize = CGSizeMake(w, 128);
    // 设置最小行间距
    layout.minimumLineSpacing = 5;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 5;
    // 设置滚动方向（默认垂直滚动）
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView setCollectionViewLayout:layout];
    
    self.collectionView.dataSource =self;
    self.collectionView.delegate = self;
    // 通过xib注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XYCameraPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:@"XYCameraPhotoCell"];

    
}

-(void)initCamera{
    NSError * error;
    
    _session = [[AVCaptureSession alloc] init];
    
    [_session beginConfiguration];
    
    [_session setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
    
    [self initVideoAudioWriter];
    
    AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    
    
    
    AVCaptureDevice * audioDevice1 = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    AVCaptureDeviceInput *audioInput1 = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice1 error:&error];
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    
    _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    
    //numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    [_audioOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    [_session addInput:videoInput];
    
    [_session addInput:audioInput1];
    
    [_session addOutput:_videoOutput];
    
    [_session addOutput:_audioOutput];
    
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    preLayer.frame = CGRectMake(0, 0, screen_width, screen_height);
    
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.videoView.layer addSublayer:preLayer];
    
    [_session commitConfiguration];
    
    if ([_captureSession canAddInput:_captureDeviceInput])
    {
        [_captureSession addInput:_captureDeviceInput];
    }
    [_session startRunning];
}
-(void) initVideoAudioWriter

{
    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    // _videoWriter.status = 0;
    //设置录制视频保存的路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"video%@.mp4", str];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];
    
    _str = path;
    
    // NSString *betaCompressionDirectory = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    
    
    
    NSError *error = nil;
    
    
    
    unlink([path UTF8String]);
    
    
    
    //----initialize compression engine
    
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                        
                                                 fileType:AVFileTypeMPEG4
                        
                                                    error:&error];
    
    NSParameterAssert(_videoWriter);
    
    if(error)
        
        NSLog(@"error = %@", [error localizedDescription]);
    
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                           
                                           [NSNumber numberWithDouble:self.view.bounds.size.width*self.view.bounds.size.width*1000000],AVVideoAverageBitRateKey,
                                           
                                           nil ];
    
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   
                                   [NSNumber numberWithInt:size.width],AVVideoHeightKey,videoCompressionProps, AVVideoCompressionPropertiesKey, nil];
    
    self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    
    
    NSParameterAssert(_videoWriterInput);
    
    
    
    _videoWriterInput.expectsMediaDataInRealTime = YES;
    
    
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           
                                                           [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    
    
    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoWriterInput
                    
                                                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    
    NSParameterAssert(_videoWriterInput);
    
    NSParameterAssert([_videoWriter canAddInput:_videoWriterInput]);
    
    
    
    if ([_videoWriter canAddInput:_videoWriterInput])
        
        NSLog(@"I can add this input");
    
    else
        
        NSLog(@"i can't add this input");
    
    
    
    // Add the audio input
    
    AudioChannelLayout acl;
    
    bzero( &acl, sizeof(acl));
    
    acl.mChannelLayoutTag = kAudioChannelLayoutTag_Mono;
    
    
    
    NSDictionary* audioOutputSettings = nil;
    
    audioOutputSettings = [ NSDictionary dictionaryWithObjectsAndKeys:
                           
                           [ NSNumber numberWithInt: kAudioFormatMPEG4AAC ], AVFormatIDKey,
                           
                           [ NSNumber numberWithInt:64000], AVEncoderBitRateKey,
                           
                           [ NSNumber numberWithFloat: 44100.0 ], AVSampleRateKey,
                           
                           [ NSNumber numberWithInt: 1 ], AVNumberOfChannelsKey,
                           
                           [ NSData dataWithBytes: &acl length: sizeof( acl ) ], AVChannelLayoutKey,
                           
                           nil ];
    
    
    
    _audioWriterInput = [AVAssetWriterInput
                         
                         assetWriterInputWithMediaType: AVMediaTypeAudio
                         
                         outputSettings: audioOutputSettings ];
    
    
    
    _audioWriterInput.expectsMediaDataInRealTime = YES;
    
    //add input
    
    [_videoWriter addInput:_audioWriterInput];
    
    [_videoWriter addInput:_videoWriterInput];
    [_videoWriter startWriting];
    
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    // Create a UIImage from the sample buffer data
    
    //    < Add your code here that uses the image >
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    /*We release some components*/
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    /*We display the result on the custom layer*/
    /*self.customLayer.contents = (id) newImage;*/
    
    /*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly)*/
    UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    NSLog(@"%@", image);
    if(image){
       self.image = image;
    }
    /*We relase the CGImageRef*/
    CGImageRelease(newImage);
    
    [_videoWriter startSessionAtSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
    if ([captureOutput isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        
        if (_videoWriter.status != 0) {
            [_videoWriterInput appendSampleBuffer:sampleBuffer];
        }
        
    }
    else if ([captureOutput isKindOfClass:[AVCaptureAudioDataOutput class]]) {
        
        if (_videoWriter.status != 0) {
            [_audioWriterInput appendSampleBuffer:sampleBuffer];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backSelect:(id)sender {
    [self.session stopRunning];
    self.videoWriter=nil ;
    self.session= nil;
    [self.rootVC.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cameraExchange:(id)sender {
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            if(position == AVCaptureDevicePositionFront){
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }else{
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
    
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}
- (IBAction)photoCheck:(UIButton*)sender {
    if(sender.selected == NO){
        
        self.rootVC.scrollView.scrollEnabled = NO;
        
        sender.selected = YES;
        
        _bgImageView.hidden = YES;
        _bgLabel.hidden = YES;
        
        _backButton.hidden = NO;
        _sendButton.hidden = NO;
        if(!_timer){
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            
        }
    }else{
        [_picDataArr addObject:self.image];
        [_collectionView reloadData];
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_picDataArr.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}
- (IBAction)sendCheck:(id)sender {
    [self stopVideo];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backBTCheck:(id)sender {
    [self.session stopRunning];
    self.videoWriter=nil ;
    self.session= nil;
    self.progressView.progress = 0.0;
    self.rootVC.scrollView.scrollEnabled = YES;
    
    _bottonBT.selected = YES;
    
    _bgImageView.hidden = NO;
    _bgLabel.hidden = NO;
    
    _backButton.hidden = YES;
    _sendButton.hidden = YES;
    
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
#pragma mark coll
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _picDataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XYCameraPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYCameraPhotoCell" forIndexPath:indexPath];
    cell.centerImageView.image = _picDataArr[indexPath.row];
    [cell closeButtonCheck:^(NSIndexPath *aIndexPath, UIButton *sender) {
        [self.picDataArr removeObjectAtIndex:aIndexPath.row];
        [self.collectionView reloadData];
        NSInteger row = aIndexPath.row - 1;
        if (row>=0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
@end
