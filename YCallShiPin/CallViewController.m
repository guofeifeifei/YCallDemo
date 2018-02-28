//
//  CallViewController.m
//  YCallShiPin
//
//  Created by ZZCN77 on 2018/1/26.
//  Copyright © 2018年 ZZCN77. All rights reserved.
//

#import "CallViewController.h"
#import <WilddogVideoCall/WilddogVideoCall.h>
#import <WilddogAuth/WilddogAuth.h>
#import <WilddogCore/WilddogCore.h>
#import "GSwitch.h"
#import "IGCMenu.h"

@interface CallViewController ()<UIScrollViewDelegate,WDGVideoCallDelegate, WDGConversationDelegate, WDGLocalStreamDelegate,IGCMenuDelegate>{
    long int _pathCount;
    long int _zongCount;
    long int _currentCount;

    BOOL _isRecing;//正在录制中
    NSTimer *_myTimer1;
    NSTimer *_myTimer2;
}
@property (nonatomic, strong) WDGLocalStream *localStream;
@property (nonatomic, strong) WDGConversation *conversation;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) WDGVideoView *remote;
@property (nonatomic, strong) UILabel *idLable;
@property (nonatomic, strong) WDGRemoteStream *remoteStream;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) IGCMenu *igcMenu;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) GSwitch *recordingBtn;
@property (nonatomic, assign) BOOL theColor;//反色
@property (nonatomic, assign) BOOL theLiang;//亮度
@property (nonatomic, assign) float liangDu;//亮度
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableArray *pathArray;

@end

@implementation CallViewController
- (NSMutableArray *)pathArray{
    if (_pathArray == nil) {
        self.pathArray = [NSMutableArray new];
    }
    return _pathArray;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 * widthScale, 0 * widthScale, self.view.frame.size.width - 0 * widthScale, self.view.frame.size.height - 0 * widthScale)];
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 3.0;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
    }
    return _scrollView;
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.remote;
}
//使缩小放大的图片位置中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.remote.center = CGPointMake((scrollView.contentSize.width - 20 * widthScale)* 0.5 + offsetX,
                                     
                                     (scrollView.contentSize.height - 30 * widthScale) * 0.5 + offsetY);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview: self.currentImageView ];
    
    //速率
    self.queue = [[NSOperationQueue alloc] init]; //自定义队列
    self.queue.maxConcurrentOperationCount = 20;
    _pathCount = 0;
    _currentCount = 0;
    _isRecing = NO;
    _liangDu = 0;
    _theColor = NO;
    _zongCount = 0;
    
    NSString *appUrlID = @"wd2594166845uulehn";
    WDGOptions *options = [[WDGOptions alloc] initWithSyncURL:[NSString stringWithFormat:@"https://%@.wilddogio.com", appUrlID]];
    [WDGApp configureWithOptions:options];
    WDGLocalStreamOptions *localStreamOptions = [[WDGLocalStreamOptions alloc] init];
    localStreamOptions.shouldCaptureAudio = NO;
    localStreamOptions.dimension = WDGVideoDimensions360p;
    self.localStream = [WDGLocalStream localStreamWithOptions:localStreamOptions];
    self.localStream.audioEnabled = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.remote =[[WDGVideoView alloc] initWithFrame:self.view.frame];
     self.remote.transform = CGAffineTransformRotate(self.remote.transform, M_PI);
    self.remote.backgroundColor = [UIColor blackColor];
    self.remote.contentMode  = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.remote];
    // 双击的 Recognizer
    UITapGestureRecognizer * doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRemoteFrame:)];
    doubleRecognizer.numberOfTapsRequired = 1; // 双击
    //关键语句，给self.view添加一个手势监测；
    [self.remote addGestureRecognizer:doubleRecognizer];

    [self login: [userDefaults objectForKey:@"username"]];
    
    self.idLable = [[UILabel alloc] initWithFrame:CGRectMake(KMainScreenWidth - 170 * widthScale, 160 * widthScale, 300 * widthScale, 20 * widthScale)];
    self.idLable.font = [UIFont systemFontOfSize:16 * widthScale];
    self.idLable.textColor = [UIColor colorWithRed:222/255.0 green:120.0/255.0 blue:137.0/255.0 alpha:1.0];
    self.idLable.backgroundColor = [UIColor clearColor];
    self.idLable.transform = CGAffineTransformRotate(self.idLable.transform, M_PI/2);
    self.idLable.text = @"等待连接...";
    self.idLable.textAlignment = 0;
    [self.view addSubview:self.idLable];
    
    self.bgImage = [[UIImageView alloc] initWithFrame:self.remote.frame];
    self.bgImage.hidden = YES;
    [self.view addSubview:self.bgImage];
    
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.recordingBtn];
    [self.view addSubview:self.lastBtn];
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.selectBtn];
    
    [self showSetupMenu];
    
}
#pragma mark 登录

- (void)login:(NSString *)appID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [[WDGAuth auth] signInWithEmail:appID
                           password:appID
                         completion:^(WDGUser *user, NSError *error) {
                             NSLog(@"%@", user);
                             if (!error) {
                                 NSLog(@"登陆成功");
                                 [userDefaults setValue:appID forKey:@"username"];
                                 
                                 
                                 [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"登录成功"];
                                 
                                 //初始化视频
                                 [self signInAnonymously];
                                 
                                 
                             }else{
                                 
                                 [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"重试登录请稍后"];
                                 NSLog(@"登录失败%@",error.description);
                                 [self login:appID];
                             }
                             
                             
                         }];
}


- (void)signInAnonymously{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"开始连接"];
        
    });
    // [[WDGAuth auth] signOut:nil];
    
    [[WDGAuth auth] signInAnonymouslyWithCompletion:^(WDGUser *user, NSError *error) {
        if (!error) {
            // 获取 token
            [user getTokenWithCompletion:^(NSString * _Nullable idToken, NSError * _Nullable error) {
                // 配置 Video Initializer
                [[WDGVideoInitializer sharedInstance] configureWithVideoAppId:@"wd2594166845uulehn" token:idToken];
                
                //邀请视频
                NSLog(@"%@", self.callID);
                 self.conversation = [[WDGVideoCall sharedInstance] callWithUid:self.callID localStream:self.localStream options:nil];
                self.conversation.delegate = self;
                //代理
                [WDGVideoCall sharedInstance].delegate  = self;
                
            }];
        }else{
            [self signInAnonymously];
        }
    }];
}
#pragma mark  WDGConversation 通过调用该方法通知代理当前视频通话发生错误而未能建立连接。
- (void)conversation:(WDGConversation *)conversation didReceiveResponse:(WDGCallStatus)callStatus{
    switch (callStatus) {
            
        case WDGCallStatusAccepted:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"接收视频邀请"];
                
            });
            NSLog(@"WDGCallStatusAccepted");
           
            
        }
            break;
        case WDGCallStatusRejected:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"拒绝视频邀请"];
                
                //初始化视频
                [self signInAnonymously];
            });
            NSLog(@"WDGCallStatusRejected");
            
        }
            break;
        case WDGCallStatusBusy:
        {
            NSLog(@"WDGCallStatusBusy");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"对方忙碌"];
                
                //初始化视频
                [self signInAnonymously];
            });
        }
            break;
        case WDGCallStatusTimeout:
        {
            NSLog(@"WDGCallStatusTimeout");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"请求超时"];
                
                //初始化视频
                [self signInAnonymously];
            });
        }
            break;
        default:
            break;
    }
    
}

//播放媒体流
- (void)conversation:(WDGConversation *)conversation didReceiveStream:(WDGRemoteStream *)remoteStream {
        self.remoteStream = remoteStream;
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"开始接收视频"];
        self.remoteStream.audioEnabled = NO;
        self.idLable.text = [NSString stringWithFormat:@"ID:%@", conversation.remoteUid];
        [self.remoteStream attach: self.remote];
        self.conversation = conversation;
}
#pragma mark--- 开始录制
- (void)recordingAction2{
    if (self.recordingBtn.isOn == YES) {
        //开始录制
        [self recordingAction];
      
    }else{
        //结束录制
        [self endRecording];

    }
    
    
    
}

//开始录制
- (void)recordingAction{
    //开始录屏
    if (_isRecing == YES) {
        return ;
    }
    if (_pathCount != 0) {
        [self.pathArray removeAllObjects];
    }
    _zongCount = 0;
    _isRecing = YES;
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
    
    [self jietuAction];
}
- (void)endRecording{
    //结束录制
    _isRecing = NO;
    _currentCount = _zongCount;
    NSLog(@"!!!!!!!!!!!!!!!!!!%ld, %ld", _currentCount, _zongCount);
    [self likeTheCurrentPicture];
    //延时执行
    int64_t delayInSeconds = 5.0;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // do something
            if (_timer != nil) {
                dispatch_source_cancel(_timer);
                self.timer = nil;
            }

    });
   
    self.remote.frame = CGRectMake(KMainScreenWidth - KMainScreenWidth * 0.3 , KMainScreenHeight - KMainScreenHeight * 0.3, KMainScreenWidth * 0.3, KMainScreenHeight * 0.3);
}
- (void)jietuAction{
    NSTimeInterval delayTime = 0.0f;
    //定时器间隔时间
    NSTimeInterval timeInterval = 0.1f;
    //创建子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //使用之前创建的队列来创建计时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置延时执行时间，delayTime为要延时的秒数
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    //设置计时器
    dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
//        NSLog(@"定时器------------%@", [NSThread currentThread]);
        //执行事件
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];  //主队列
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            //任务执行
            _pathCount ++;
            _zongCount ++;
            UIGraphicsBeginImageContextWithOptions(self.remote.frame.size, YES, 0);
            if ([self.remote respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
               [self.remote drawViewHierarchyInRect:self.remote.bounds afterScreenUpdates:NO];
            }
            else{
                [self.remote.layer renderInContext:UIGraphicsGetCurrentContext()];
            }
           
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
//            NSLog(@"获取图片------------%@", [NSThread currentThread]);
            [self saveImage:image patch:_pathCount];
           
        }];
        [mainQueue addOperation:operation];
        
    });
    // 启动计时器
    dispatch_resume(_timer);
    
}
- (void)saveImage:(UIImage *)img patch:(long int)count{
    [self.queue addOperationWithBlock:^{
        //任务执行
//        NSLog(@"保存图片------------%@", [NSThread currentThread]);
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if (_zongCount > 300) {
            [[NSFileManager defaultManager] removeItemAtPath: self.pathArray[0] error:nil];

            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.pathArray removeObjectAtIndex:0];
                _zongCount--;
                if (_currentCount > 2) {
                    _currentCount--;
                }
                
            });
        }
        NSString *videoPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"image%ld.png", count]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImageJPEGRepresentation(img,0.3) writeToFile:videoPath atomically:YES];
        [self.pathArray addObject:videoPath];
        NSLog(@"%ld---,%ld--,%ld--",_pathCount,_zongCount, (unsigned long)self.pathArray.count);
    }];
    
    
}
- (UIWindow *)findKeyWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (![NSStringFromClass([keyWindow class]) isEqualToString:@"UIWindow"]) {
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *window in windows) {
            if ([NSStringFromClass([window class]) isEqualToString:@"UIWindow"]) {
                keyWindow = window;
                break;
            }
        }
    }
    return keyWindow;
}
#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter{
    
    [self.myFilterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = self.myFilterGroup.filterCount;
    
    if (count == 1)
    {
        //设置初始滤镜
        self.myFilterGroup.initialFilters = @[newTerminalFilter];
        //设置末尾滤镜
        self.myFilterGroup.terminalFilter = newTerminalFilter;
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    = self.myFilterGroup.terminalFilter;
        NSArray *initialFilters                          = self.myFilterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        //设置初始滤镜
        self.myFilterGroup.initialFilters = @[initialFilters[0]];
        //设置末尾滤镜
        self.myFilterGroup.terminalFilter = newTerminalFilter;
    }
}
- (void)changeAction:(UIButton *)btn{
    
    if (btn.selected == NO) {
        btn.selected = YES;
        [_igcMenu showHorLineMenu];
        
    }else{
        btn.selected = NO;
        [_igcMenu hideHorLineMenu];
    }
}
- (void)showSetupMenu{
    self.selectBtn.clipsToBounds = YES;
    self.selectBtn.layer.cornerRadius = self.selectBtn.frame.size.height / 2;
    if (_igcMenu == nil) {
        _igcMenu = [[IGCMenu alloc] init];
        
    }
    
    _igcMenu.menuButton = self.selectBtn;   //Pass refernce of menu button
    _igcMenu.menuSuperView = self.buttonView;      //Pass reference of menu button super view
    _igcMenu.disableBackground = YES;        //Enable/disable menu background
    _igcMenu.numberOfMenuItem = 4;           //Number of menu items to display
    
    //Menu background. It can be BlurEffectExtraLight,BlurEffectLight,BlurEffectDark,Dark or None
    _igcMenu.backgroundType = None;
    _igcMenu.menuHeight = 50;
    /* Optional
     Pass name of menu items
     **/
    _igcMenu.menuItemsNameArray = [NSArray arrayWithObjects:@"quanping",@"xuanzhuan",@"liangdu",@"fanse",nil];
    
    /*Optional
     Pass color of menu items
     **/
//    UIColor *homeBackgroundColor = [UIColor clearColor];
//    UIColor *searchBackgroundColor = [UIColor clearColor];
//
//    _igcMenu.menuBackgroundColorsArray = [NSArray arrayWithObjects:homeBackgroundColor,searchBackgroundColor,searchBackgroundColor,searchBackgroundColor,nil];
//
    /*Optional
     Pass menu items icons
     **/
    _igcMenu.menuImagesNameArray = [NSArray arrayWithObjects:@"quanping",@"xuanzhuan",@"liangdu",@"fanse",nil];
    
    /*Optional if you don't want to get notify for menu items selection
     conform delegate
     **/
    _igcMenu.delegate = self;
}
#pragma mark 工具事件
- (void)igcMenuSelected:(NSString *)selectedMenuName atIndex:(NSInteger)index{
 
        switch (index) {
            case 0:
            {
                //恢复
                  self.remote.frame = self.view.frame;
            }
                break;
            case 1:{
                //翻转
                  self.remote.transform = CGAffineTransformRotate(self.remote.transform, M_PI);
            }
                
                break;
            case 2:  {

                //亮度
                if (_zongCount == 0 || _currentCount == 0) {
                    return;
                }
                UIImage *myImage =[UIImage imageWithContentsOfFile:_pathArray[_currentCount - 1]];
                if (myImage == nil) {
                    return;
                }
                NSLog(@"曾亮------%ld", _currentCount);
                if (_liangDu > 0.6) {
                    _liangDu = 0.0;
                }else{
                    _liangDu += 0.2;
                }
                GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
                [filter setBrightness:_liangDu];
                [filter forceProcessingAtSize:myImage.size];
                [filter useNextFrameForImageCapture];
                GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:myImage];
                [stillImageSource addTarget:filter];
                [stillImageSource processImage];
                self.currentImageView.image = [filter imageFromCurrentFramebuffer];
                 _theColor = NO;
            }
                break;
            case 3:{
                //去反色
                if (_zongCount == 0 || _currentCount == 0) {
                    return;
                }
                UIImage *myImage =[UIImage imageWithContentsOfFile:_pathArray[_currentCount - 1]];
                if (myImage == nil) {
                    return;
                }
                if (_theColor == NO) {
                    _theColor = YES;
                 
                    GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init];
                    [filter forceProcessingAtSize:myImage.size];
                    GPUImageColorInvertFilter *colorInvertFilter = [[GPUImageColorInvertFilter alloc] init];
                    //把多个滤镜对象放到数组中
                    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:myImage];
                    
                    self.myFilterGroup = [[GPUImageFilterGroup alloc] init];
                    //将滤镜组加在GPUImagePicture上
                    [stillImageSource addTarget:self.myFilterGroup];
                    //添加上滤镜
                    //将滤镜加在FilterGroup中
                    [self addGPUImageFilter:filter];
                    [self addGPUImageFilter:colorInvertFilter];
                    //开始渲染
                    [stillImageSource processImage];
                    [self.myFilterGroup useNextFrameForImageCapture];
                    //获取渲染后的图片
                    self.currentImageView.image = [self.myFilterGroup imageFromCurrentFramebuffer];
                }else{
                    _theColor = NO;
                    self.currentImageView.image = myImage;
                }
            }
                
                break;
            case 4:
                
                break;
            default:
                break;
        }
   
}

#pragma mark 切换视频窗口大小
-(void)changeRemoteFrame:(UITapGestureRecognizer*)recognizer
{
    //处理双击操作
    if ( self.remote.frame.size.width != self.view.frame.size.width) {
        //开始录制
      self.remote.frame = self.view.frame;
        
    }else{
            _pathCount ++;
            _zongCount ++;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(KMainScreenWidth, KMainScreenHeight), YES, 0);
            [self.remote drawViewHierarchyInRect:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) afterScreenUpdates:NO];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *videoPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"image%ld.png", _pathCount]];
            //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
            [UIImageJPEGRepresentation(image,0.3) writeToFile:videoPath atomically:YES];
            [self.pathArray addObject:videoPath];
            _currentCount = _zongCount;
            [self likeTheCurrentPicture];
            self.remote.frame = CGRectMake(KMainScreenWidth - KMainScreenWidth * 0.3 , KMainScreenHeight - KMainScreenHeight * 0.3, KMainScreenWidth * 0.3, KMainScreenHeight * 0.3);
    }
    }
- (void)nextAction:(UIButton *)btn{
    if (_zongCount == 0) {
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"没有录制视频"];
        return;
    }
    _currentCount += 1;
    NSLog(@"当前数量-------%ld", _currentCount);

    if (_currentCount >= _zongCount) {
        _currentCount = _zongCount;
          NSLog(@"当前数量-------%ld", _currentCount);
        if (_myTimer1!= nil) {
            [_myTimer1 invalidate];
            _myTimer1 = nil;
        }
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"已经是最后一张了"];
        return;
    }
    [self likeTheCurrentPicture];
    
}
- (void)likeTheCurrentPicture{
    if (_zongCount == 0) {
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"没有录制视频"];
    }else{

        while (_pathArray.count < _currentCount) {
              _currentCount --;
        }
        UIImage *image = [UIImage imageWithContentsOfFile:_pathArray[_currentCount - 1]];
        NSLog(@"当前图片------%ld", _currentCount);
        if (_theColor == YES) {
            GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init];
            [filter forceProcessingAtSize:image.size];
            GPUImageColorInvertFilter *colorInvertFilter = [[GPUImageColorInvertFilter alloc] init];
            //把多个滤镜对象放到数组中
            GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:image];
            self.myFilterGroup = [[GPUImageFilterGroup alloc] init];
            //将滤镜组加在GPUImagePicture上
            [stillImageSource addTarget:self.myFilterGroup];
            //添加上滤镜
            //将滤镜加在FilterGroup中
            [self addGPUImageFilter:filter];
            [self addGPUImageFilter:colorInvertFilter];
            //开始渲染
            [stillImageSource processImage];
            [self.myFilterGroup useNextFrameForImageCapture];
            //获取渲染后的图片
            self.currentImageView.image = [self.myFilterGroup imageFromCurrentFramebuffer];
        }else if (_liangDu > 0){
          
            GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
            [filter setBrightness:_liangDu];
            [filter forceProcessingAtSize:image.size];
            [filter useNextFrameForImageCapture];
            GPUImagePicture * stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
            [stillImageSource addTarget:filter];
            [stillImageSource processImage];
            self.currentImageView.image = [filter imageFromCurrentFramebuffer];
        }else{
            self.currentImageView.image = image;
        }
    }
    
}
- (void)lastAction:(UIButton *)btn{
    if (_zongCount == 0) {
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"没有录制视频"];
        return;
    }
    _currentCount -= 1;
    NSLog(@"当前数量-------%ld", _currentCount);

    if (_currentCount <= 1) {
        _currentCount = 1;
        NSLog(@"当前数量-------%ld", _currentCount);

        if (_myTimer2!= nil) {
            [_myTimer2 invalidate];
            _myTimer2 = nil;
        }
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"已经是第一张了"];
        return;
    }
   [self likeTheCurrentPicture];
    
}
-(void)btnLong:(UILongPressGestureRecognizer*)gestureRecognizer{
    if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
        if (_myTimer1 == nil) {
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"开始播放"];
            
            _myTimer1 =  [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                         target:self
                                                       selector:@selector(nextAction:)
                                                       userInfo:nil
                                                        repeats:YES];
            
        }
    }else if ( [gestureRecognizer state] == UIGestureRecognizerStateEnded){
        NSLog(@"终止");
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"已经停止播放"];
        
        if (_myTimer1!= nil) {
            [_myTimer1 invalidate];
            _myTimer1 = nil;
        }
    }
    
    
}
-(void)lastLong:(UILongPressGestureRecognizer*)gestureRecognizer{
    if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
        if (_myTimer2 == nil) {
            [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"开始后退"];
            _myTimer2 =  [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                          target:self
                                                        selector:@selector(lastAction:)
                                                        userInfo:nil
                                                         repeats:YES];
            
            
            
        }
    }else if ( [gestureRecognizer state] == UIGestureRecognizerStateEnded){
        [MBProgressHUD showTitleToView:self.view postion:NHHUDPostionBottom title:@"已经停止播放"];
        
        if (_myTimer2!= nil) {
            [_myTimer2 invalidate];
            _myTimer2 = nil;
        }
    }
}
- (UIView *)buttonView{
    if (_buttonView == nil) {
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0* widthScale, KMainScreenHeight - 50  * widthScale, KMainScreenWidth,40 * widthScale)];
    }
    return _buttonView;
}

- (UIButton *)selectBtn{
    if (_selectBtn == nil) {
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(20* widthScale, 0  * widthScale, 40 * widthScale,40 * widthScale );
        [self.selectBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectBtn setImage:[UIImage imageNamed:@"seting"] forState:0];
        self.selectBtn.selected = NO;
    }
    return _selectBtn;
}
- (GSwitch *)recordingBtn{
    if (_recordingBtn == nil) {
        self.recordingBtn = [[GSwitch alloc] initWithFrame:CGRectMake(20 * kwidthScale, KMainScreenHeight - 100 * widthScale, 60 * kwidthScale, 30 * kwidthScale)];
        self.recordingBtn.tintColor = [UIColor grayColor];
        [self.recordingBtn addTarget:self action:@selector(recordingAction2) forControlEvents:UIControlEventValueChanged];
        self.recordingBtn.on = NO;
    }
    return _recordingBtn;
}

- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextBtn.frame = CGRectMake(20* widthScale,  150  * widthScale, 40 * widthScale,40 * widthScale );
        [self.nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.nextBtn setImage:[UIImage imageNamed:@"houtui"] forState:0];
        //button长按事件
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
        
        longPress.minimumPressDuration=0.8;//定义按的时间
        [self.nextBtn addGestureRecognizer:longPress];
        
        
    }
    return _nextBtn;
}
- (UIButton *)lastBtn{
    if (_lastBtn == nil) {
        self.lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lastBtn.frame = CGRectMake(20* widthScale,  50  * widthScale, 40 * widthScale,40 * widthScale );
        [self.lastBtn addTarget:self action:@selector(lastAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.lastBtn setImage:[UIImage imageNamed:@"kuaijin"] forState:0];
        //button长按事件
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lastLong:)];
        
        longPress.minimumPressDuration=0.8;//定义按的时间
        [self.lastBtn addGestureRecognizer:longPress];
        
        
    }
    return _lastBtn;
}
- (UIImageView *)currentImageView{
    if (_currentImageView == nil) {
        self.currentImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        self.currentImageView.image = [UIImage imageNamed:@"bg"];
        self.currentImageView.userInteractionEnabled = YES;
        self.currentImageView.contentMode  = UIViewContentModeScaleAspectFill;
        self.currentImageView.transform = CGAffineTransformRotate(self.currentImageView.transform, M_PI);
    }
    return _currentImageView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[WDGAuth auth] signOut:nil];
}
@end
