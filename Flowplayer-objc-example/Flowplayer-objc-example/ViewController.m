//
//  ViewController.m
//  Flowplayer-objc-example
//
//  Created by Mathias Palm on 2019-01-09.
//  Copyright © 2019 com.appshack. All rights reserved.
//

#import "ViewController.h"
#import <Flowplayer/Flowplayer.h>

@interface ViewController () <FLPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet FLPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *controllButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.playerView loadWithVideoId:@"f0d918c6-3122-4090-b39b-ce376c6e4790" andPlayerId:@"999391f8-9119-4ac7-b550-f0f594ec8950"];
    [self.playerView setDelegate:self];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (self.playerView.isPlaying) {
        [self.playerView play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [self.playerView pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)timeUpdate:(float)currentTime {
    self.progressLabel.text = [NSString stringWithFormat:@"Time elapsed: %.2f", currentTime];
}

- (void)stateChanged:(Boolean)isPlaying {
    [self.controllButton setTitle: isPlaying ? @"Pause" : @"Play" forState:UIControlStateNormal];
}

@end
