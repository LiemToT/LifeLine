//
//  ViewController.m
//  TestLocalNotification
//
//  Created by Sooyo on 14-12-22.
//  Copyright (c) 2014年 Sooyo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic , strong) UIButton *testButton;


- (IBAction)setAlarm:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    [self.datePicker setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.testButton = [[UIButton alloc] initWithFrame:CGRectMake(100 , 100  , 60 , 60)];
    [self.testButton setBackgroundColor:[UIColor redColor]];
    [self.testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.testButton setTitle:@"Test" forState:UIControlStateNormal];
    [self.view addSubview:self.testButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setAlarm:(id)sender
{
//    NSDate *date = self.datePicker.date;
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.timeStyle = NSDateFormatterShortStyle;
//    formatter.dateStyle = NSDateFormatterShortStyle;
//    
//    NSString *dateString = [formatter stringFromDate:date];
//    NSLog(@"DateString %@" , dateString);
//
//    NSDate *triggerDate = [formatter dateFromString:dateString];
//    NSLog(@"%@", triggerDate);
//    
//    /* Make local notification */
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = triggerDate;
//    notification.alertBody = @"Test alert!";
//    notification.soundName = @"Alarm.caf";
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    
    [self performSegueWithIdentifier:@"segue" sender:self];
    
//    CGRect frame = self.testButton.frame;
//    frame.size.height -= 40;
//    
//    [UIView animateWithDuration:1 animations:^{self.testButton.frame = frame;}];
    
}
@end
