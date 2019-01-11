![flowplayer](https://flowplayer.com/images/logo-blue.png)<br /><br />
![Flowplayer platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![ios 10.0](https://img.shields.io/badge/ios-10.0-blue.svg)

## Usage

#### Swift
```swift
import UIKit
import Flowplayer

class ViewController: UIViewController {
    @IBOutlet weak var playerView: FLPlayerView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var controllButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.load(withVideoId: "some_video_id", andPlayerId: "some_player_id")
        playerView.delegate = self
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if playerView.isPlaying {
            playerView.pause()
            sender.setTitle("Play", for: .normal)
        } else {
            playerView.play()
            sender.setTitle("Pause", for: .normal)
        }
    }
}

extension ViewController: FLPlayerViewDelegate {
    // CurrentTime is in seconds
    func timeUpdate(_ currentTime: Float) {
        progressLabel.text = "Time elapsed: \(currentTime)"
    }
    func stateChanged(_ isPLaying: Bool) {
        controllButton.setTitle(isPLaying ? "Pause" : "Play", for: .normal)
    }
}
```

#### Objective-C
```objc
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
    [self.playerView loadWithVideoId:@"some_video_id" andPlayerId:@"some_player_id"];
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
    self.progressLabel.text = [NSString stringWithFormat:@"%f", currentTime];
}

- (void)stateChanged:(Boolean)isPLaying {
    [self.controllButton setTitle: isPLaying ? @"Pause" : @"Play" forState:UIControlStateNormal];
}

@end
```

## Requirments
* Xcode 9.0
* iOS 10.0

> please note that this is not fully tested!

## Installation

### Manually
- Download flowplayer.framework.zip
- Unpack zip file
- Drag and drop into your project (make sure it's added under embeded libraries)
- And you are done!

### Cocapods (comming soon)


After importing your framework:

  1. Drag a UIView onto your Storyboard.
  2. Change the UIView's class in the Identity Inspector tab to FLPlayerView
  3. Import Flowplayer in your ViewController.
  6. Run your code!

