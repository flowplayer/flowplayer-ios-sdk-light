//
//  FlowplayerTests.m
//  FlowplayerTests
//
//  Created by Mathias Palm on 2019-01-07.
//  Copyright © 2019 com.appshack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Flowplayer/Flowplayer.h>

@interface FlowplayerTests : XCTestCase <FLPlayerViewDelegate> {
    FLPlayerView *playerView;
    XCTestExpectation *timeUpdateExpectation;
    XCTestExpectation *viewIsReadyExpectation;
}
@end

@implementation FlowplayerTests

- (void)setUp {
    playerView = [FLPlayerView new];
    playerView.delegate = self;
}

- (void)testLoadVideo {
    viewIsReadyExpectation = [self expectationWithDescription:@"view is ready delegate"];
    
    Boolean test = [playerView loadWithVideoId:@"f0d918c6-3122-4090-b39b-ce376c6e4790" andPlayerId:@"999391f8-9119-4ac7-b550-f0f594ec8950"];
    [self waitForExpectationsWithTimeout:3 handler:^(NSError *error) {
        if (error) {
            NSLog(@"View timeout Error: %@", error);
        }
    }];
    XCTAssertTrue(test, @"Should return YES since video can load");
}

- (void)viewIsReady {
    [viewIsReadyExpectation fulfill];
    XCTAssert(YES, @"View is ready!");
}

/**
 *
 * Seems like the javascript player wont play unless there is a view,
 * hmm this can be hard to test since we dont have any views in a framework.
 * have to come back to this -MARK: error
 *
 */
//- (void)testTimeUpdate {
//    timeUpdateExpectation = [self expectationWithDescription:@"Time update delegate"];
//    Boolean test = [playerView loadWithVideoId:@"f0d918c6-3122-4090-b39b-ce376c6e4790" andPlayerId:@"999391f8-9119-4ac7-b550-f0f594ec8950"];
//
//
//    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 6);
//    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
//        [self->playerView play];
//    });
//    [self waitForExpectationsWithTimeout:9 handler:^(NSError *error) {
//        if (error) {
//            NSLog(@"Server Timeout Error: %@", error);
//        }
//    }];
//
//    XCTAssertTrue(test, @"Should return YES since video is loaded");
//}

//- (void)timeUpdate:(float)currentTime {
//    [timeUpdateExpectation fulfill];
//    XCTAssertTrue(currentTime > -1, @"Time update delegate works");
//}

@end
