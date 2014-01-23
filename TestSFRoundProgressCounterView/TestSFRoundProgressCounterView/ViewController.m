//
//  ViewController.m
//  TestSFRoundProgressTimerView
//
//  Created by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import "ViewController.h"
#import "SFRoundProgressCounterView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SFRoundProgressCounterView *progressCounterView;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;

@property (strong, nonatomic) AVAudioPlayer *warningAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *finishAudioPlayer;

@property (atomic) BOOL playBeep;

@end

#define DEFAULT_BEEP_INTERVAL 10000

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup progress timer view
    self.progressCounterView.delegate = self;
    NSNumber* interval = [NSNumber numberWithLong:5000.0];
    self.progressCounterView.intervals = @[interval];
    
    // setup audio player
    [self.warningAudioPlayer prepareToPlay];
    [self.finishAudioPlayer prepareToPlay];
    self.playBeep = YES;
}

#pragma mark = SFRoundProgressTimerViewDelegate
- (void)countdownDidEnd:(SFRoundProgressCounterView*)progressTimerView
{
    [self.finishAudioPlayer play];
    self.playBeep = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.startStopButton setTitle:@"START" forState:UIControlStateNormal];
        [self.progressCounterView reset];
        self.restartButton.hidden = YES;
    });
}

- (void)intervalDidEnd:(SFRoundProgressCounterView *)progressTimerView WithIntervalPosition:(int)position
{
    [self.warningAudioPlayer play];
}

#pragma mark - audio
- (AVAudioPlayer*) warningAudioPlayer {
    if (!_warningAudioPlayer) {
        NSURL *audioUrl = [NSURL fileURLWithPath:([[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"])];
        _warningAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    }
    
    return _warningAudioPlayer;
}

- (AVAudioPlayer*) finishAudioPlayer {
    if (!_finishAudioPlayer) {
        NSURL *audioUrl = [NSURL fileURLWithPath:([[NSBundle mainBundle] pathForResource:@"doublebeep" ofType:@"mp3"])];
        _finishAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    }
    
    return _finishAudioPlayer;
}

#pragma mark - actions
- (IBAction)actionStartStop:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    // start
    if ([button.currentTitle isEqualToString:@"START"]) {
    
        [self.progressCounterView start];
        [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
        self.restartButton.hidden = NO;
    // stop
    } else if ([button.currentTitle isEqualToString:@"STOP"]) {
        
        [self.progressCounterView stop];
        [self.startStopButton setTitle:@"RESUME" forState:UIControlStateNormal];
    // resume
    } else {
        
        [self.progressCounterView resume];
        [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
    }
}

- (IBAction)actionRestart:(id)sender {
    [self.startStopButton setTitle:@"STOP" forState:UIControlStateNormal];
    [self.progressCounterView start];
}

#pragma mark - color
- (void)setColor:(UIColor *)color
{
    if (color) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressCounterView.progressColor = color;
            self.progressCounterView.labelColor = color;
            
            self.startStopButton.tintColor = color;
            self.restartButton.tintColor = color;
        });
    }
}

- (void)setIntervals:(NSArray *)intervals
{
    if (intervals) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.startStopButton setTitle:@"START" forState:UIControlStateNormal];
            [self.progressCounterView stop];
            self.restartButton.hidden = YES;
            _intervals = intervals;
            self.progressCounterView.intervals = intervals;
        });
    }
}

@end
