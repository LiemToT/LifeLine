//
//  MyViewController.m
//  TestLocalNotification
//
//  Created by Sooyo on 14-12-22.
//  Copyright (c) 2014年 Sooyo. All rights reserved.
//

#import "MyViewController.h"
#import <AVFoundation/AVFoundation.h>

#define rgba(a , b , c , d) [UIColor colorWithRed:(a) / 255.f  green:(b) / 255.f  blue:(c) / 255.f alpha:(d)]
#define rgb(a , b , c)  rgba(a , b , c , 1)

@interface MyViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIView *centerContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (nonatomic , strong) UIView *previewView;

@property (nonatomic , strong) UIButton *cameraButton;
@property (nonatomic , strong) UIButton *closeButton;
@property (nonatomic , strong) UIButton *okButton;
@property (nonatomic , strong) UIButton *helpButton;

@property (nonatomic , assign) BOOL isCameraOn;

@property (nonatomic , strong) AVCaptureSession *session;
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *sessionPreLayer;

/* Init the interface programmatically */
- (void)createTopButtons;
- (void)createBottomButtons;


- (void)onCameraButtonPressed:(id)sender;
- (void)onCloseButtonPressed;
- (void)onOKButtonPressed;
- (void)onHelpButtonPressed:(id)sender;

- (void)startVideoRecording:(BOOL)start;

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    _cameraButton = nil;
    _closeButton = nil;
    _okButton = nil;
    _helpButton = nil;
    
    _session = nil;
    _sessionPreLayer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isCameraOn = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self createTopButtons];
    [self createBottomButtons];
    
    self.previewView = [[UIView alloc] init];
    [self.previewView setBackgroundColor:rgb(0 , 0 , 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.previewView setFrame:self.centerContainer.frame];
    [self.previewView setAlpha:0];
}

- (void)createTopButtons
{
    CGFloat size = 0.5 * CGRectGetWidth(self.view.bounds);
    self.cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(-1 , -1 , size , size)];
    [self.cameraButton setBackgroundColor:rgb(227 , 66 , 72)];
    [self.cameraButton setTitleColor:rgb(255 , 255 , 255) forState:UIControlStateNormal];
    [self.cameraButton setTitle:@"Camera" forState:UIControlStateNormal];
    
    self.cameraButton.layer.borderColor = [rgb(255 , 255 , 255) CGColor];
    self.cameraButton.layer.borderWidth = 1;
    
    [self.view addSubview:self.cameraButton];
    [self.cameraButton addTarget:self action:@selector(onCameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(size - 2 , -1 , size + 3 , size)];
    [self.closeButton setBackgroundColor:self.cameraButton.backgroundColor];
    [self.closeButton setTitleColor:rgb(255 , 255 , 255) forState:UIControlStateNormal];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    
    self.closeButton.layer.borderColor = [rgb(255 , 255 , 255) CGColor];
    self.closeButton.layer.borderWidth = 1;
    
    [self.view addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(onCloseButtonPressed) forControlEvents:UIControlEventTouchUpInside];

}


- (void)createBottomButtons
{
    CGFloat size = 0.5 * CGRectGetWidth(self.view.bounds);

    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0 , size , size)];
    [self.okButton setBackgroundColor:rgb(255 , 255 , 255)];
    [self.okButton setTitleColor:rgb(0 , 255 , 0) forState:UIControlStateNormal];
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    
    [self.bottomContainer addSubview:self.okButton];
    [self.okButton addTarget:self action:@selector(onOKButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.helpButton = [[UIButton alloc] initWithFrame:CGRectMake(size + 1 , 0 , size - 1 , size)];
    [self.helpButton setBackgroundColor:rgb(255 , 255 , 255)];
    [self.helpButton setTitleColor:rgb(255 , 0 , 0) forState:UIControlStateNormal];
    [self.helpButton setTitle:@"Help" forState:UIControlStateNormal];
    
    [self.bottomContainer addSubview:self.helpButton];
    [self.helpButton addTarget:self action:@selector(onHelpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onCameraButtonPressed:(id)sender
{
    CGFloat topAnimateFactor = self.isCameraOn ? -100 : 100;
    CGFloat bottomAnimateFactor = self.isCameraOn ? -60 : 60;
    
    /* Animate the top buttons */
    CGRect cameraButtonFrame = self.cameraButton.frame;
    CGRect closeButtonFrame = self.closeButton.frame;
    
    cameraButtonFrame.size.height -= topAnimateFactor;
    closeButtonFrame.size.height -= topAnimateFactor;
    
    /* Animate bottom buttons */
    CGRect okButtonFrame = self.okButton.frame;
    CGRect helpButtonFrame = self.helpButton.frame;
    
    okButtonFrame.origin.y += bottomAnimateFactor;
    okButtonFrame.size.height -= bottomAnimateFactor;
    
    helpButtonFrame.origin.y += bottomAnimateFactor;
    helpButtonFrame.size.height -= bottomAnimateFactor;
    
    /* Animate preview view for video tapping */
    CGRect previewViewFrame = self.previewView.frame;
    previewViewFrame.origin.y = CGRectGetMaxY(cameraButtonFrame) + 1;
    previewViewFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(cameraButtonFrame) - CGRectGetHeight(okButtonFrame) - 1;

    CGFloat alpha = self.isCameraOn ? 0 : 1;
    if (!self.isCameraOn)
    {
        [self.view addSubview:self.previewView];
        [self.view bringSubviewToFront:self.previewView];
    }
    
    __weak MyViewController *__weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [__weakSelf.cameraButton setFrame:cameraButtonFrame];
        [__weakSelf.closeButton setFrame:closeButtonFrame];
        [__weakSelf.okButton setFrame:okButtonFrame];
        [__weakSelf.helpButton setFrame:helpButtonFrame];
        
        [__weakSelf.previewView setFrame:previewViewFrame];
        [__weakSelf.previewView setAlpha:alpha];
    } completion:^(BOOL finished) {
        __weakSelf.isCameraOn = !__weakSelf.isCameraOn;
        
        /* Remove the preview view when camera is off */
        if (!__weakSelf.isCameraOn)
            [__weakSelf.previewView removeFromSuperview];
        [self startVideoRecording:self.isCameraOn];
    }];
}


- (void)onHelpButtonPressed:(id)sender
{
    NSLog(@"On Help");
}

- (void)onOKButtonPressed
{
    NSLog(@"On OK");
}


- (void)onCloseButtonPressed
{
   
}

- (void)startVideoRecording:(BOOL)start
{
    if (start == YES)
    {
        
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetMedium;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测不到照相机" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alertView show];
        }
        [self.session addInput:input];
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [self.session addOutput:output];
        
        dispatch_queue_t queue = dispatch_queue_create("queue", nil);
        [output setSampleBufferDelegate:self queue:queue];
        
        output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                [NSNumber numberWithInt:320] , kCVPixelBufferWidthKey,
                                [NSNumber numberWithInt:240] , kCVPixelBufferHeightKey,
                                nil];
        
        self.sessionPreLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.sessionPreLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.sessionPreLayer.frame = self.previewView.bounds;
        [self.previewView.layer addSublayer:self.sessionPreLayer];
        [self.session startRunning];
 
    }
    
    else
    {
        [self.session stopRunning];
        self.session = nil;
        [self.sessionPreLayer removeFromSuperlayer];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate Method
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
}

@end
