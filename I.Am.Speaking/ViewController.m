//
//  ViewController.m
//  I.Am.Speaking
//
//  Created by Ang, Jay on 8/18/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *speechTextView;
@property (strong, nonatomic) IBOutlet UIButton *playPauseSpeechButton;
@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@property BOOL speechPaused;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.speechPaused = NO;
    
    self.speechTextView.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    self.speechSynthesizer = [AVSpeechSynthesizer new];
    
    self.speechSynthesizer.delegate = self;
    
    [self listOfLanguagesAvailable];
}


- (IBAction)onPlayPauseSpeechButtonPressed:(id)sender
{
    [self.speechTextView resignFirstResponder];
    
    [self isTextBeingSpoken];

    //if statement added to prevent re-creation of utterance and queues it to be played
    if (self.speechSynthesizer.speaking == NO)
    {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.speechTextView.text];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
        utterance.rate = 0.25f;
        [self.speechSynthesizer speakUtterance:utterance];
    }
}

#pragma mark - changing button status
-(void)isTextBeingSpoken
{
    if (self.speechPaused == NO)
    {
        [self.playPauseSpeechButton setTitle:@"Pause" forState:UIControlStateNormal];
        [self.speechSynthesizer continueSpeaking];
        self.speechPaused = YES;
    }
    else
    {
        [self.playPauseSpeechButton setTitle:@"Play" forState:UIControlStateNormal];
        self.speechPaused = NO;
        [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

#pragma mark - method to seek list of language
-(void)listOfLanguagesAvailable
{
    for (AVSpeechSynthesisVoice *voice in [AVSpeechSynthesisVoice speechVoices])
    {
        NSLog(@"languages : %@", voice.language);
    }
}

#pragma mark - dismiss keyboard upon touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.speechTextView resignFirstResponder];
}


#pragma mark - AVSpeechSynthesizer delegate method
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [self.playPauseSpeechButton setTitle:@"Play" forState:UIControlStateNormal];
    self.speechPaused = NO;
    self.speechTextView.font = [UIFont fontWithName:@"Helvetica" size:20];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.speechTextView.text];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:characterRange];
    self.speechTextView.attributedText = text;
    
}


@end
