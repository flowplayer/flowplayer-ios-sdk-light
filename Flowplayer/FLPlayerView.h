//
//  FLWeb.h
//  Flowplayer
//
//  Created by Mathias Palm on 2019-01-07.
//  Copyright © 2019 com.appshack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class FLPlayerView;

/**
 * A delegate for FLPLayerView to respond to flowplayer events,
 * such as changes to the current time.
 */
@protocol FLPlayerViewDelegate<NSObject>

@optional
/**
 * Invoked when the player current time has changed.
 *
 * @param currentTime a float indicating the current playback time in seconds.
 */
- (void)timeUpdate:(float)currentTime;
@end


/**
 * FLPlayerView is a custom UIView Flowplayer in their iOS applications.
 * It can be instantiated programmatically, or via
 * Interface Builder. Use the methods FLPlayerView::loadWithVideoId:,
 * FLPlayerView::loadWithVideoId andPlayerId:.
 */
@interface FLPlayerView : UIView <WKScriptMessageHandler>

@property(nonatomic, strong, nullable, readonly) WKWebView *webView;

/** A delegate to be notified on playback events. */
@property(nonatomic, weak, nullable) id<FLPlayerViewDelegate> delegate;

/**
 * Starts or resumes playback on the loaded video.
 */
- (void)play;

/**
 * Pauses playback on a playing video
 */
- (void)pause;

/**
 * This method reloads or creates a new video player. You can call this either if you ant to
 * reload a player view with a new video or if you want to create a complete new player view.
 *
 * This method only make use of the video id, if you want to use player id as well use method
 * loadWithVideoId: andPLayerId: instead
 *
 * @param videoId the video ID of the video
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithVideoId:(NSString *)videoId;

/**
 * This method reloads or creates a new video player. You can call this either if you ant to
 * reload a player view with a new video or if you want to create a complete new player view.
 *
 * This method uses both videoId and playerId
 *
 * @param videoId The video ID of the video
 * @param playerId The player ID of the video
 * @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithVideoId:(NSString *)videoId andPlayerId:(NSString *)playerId;

@end




