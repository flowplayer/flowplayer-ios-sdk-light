//
//  FLWebView.m
//  Flowplayer
//
//  Created by Mathias Palm on 2019-01-07.
//  Copyright © 2019 com.appshack. All rights reserved.
//

#import "FLPlayerView.h"

NSString static *const baseUrl = @"https://ljsp.lwcdn.com";

@implementation FLPlayerView {
    NSURL *originURL;
    WKWebView *webView;
}

- (BOOL)loadWithVideoId:(NSString *)videoId {
    NSString *url = [NSString stringWithFormat:@"%@/api/video/embed.jsp?id=%@", baseUrl, videoId];
    NSDictionary *params = @{ @"url" : url };
    return [self loadWithPlayerParams:params];
}

- (BOOL)loadWithVideoId:(NSString *)videoId andPlayerId:(NSString *)playerId {
    NSString *url = [NSString stringWithFormat:@"%@/api/video/embed.jsp?id=%@&pi=%@", baseUrl, videoId, playerId];
    NSDictionary *params = @{ @"url" : url };
    return [self loadWithPlayerParams:params];
}

#pragma mark - Player methods

- (void)play {
    [self stringFromEvaluatingJavaScript:@"video.play();" completionHandler:nil];
}

- (void)pause {
    [self stringFromEvaluatingJavaScript:@"video.pause();" completionHandler:nil];
}

#pragma mark - Helper/delegate methods

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name  isEqualToString: @"progress"]) {
        NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        float seconds = floorf([[json objectForKey:@"time"] floatValue] * 100 + 0.5) / 100;
        if ([self.delegate respondsToSelector:@selector(timeUpdate:)]) {
            [self.delegate timeUpdate:seconds];
        }
    } else if ([message.name isEqualToString:@"stateChanged"]) {
        NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        Boolean playing = [[json objectForKey:@"playing"] boolValue];
        self.isPlaying = playing;
        if ([self.delegate respondsToSelector:@selector(stateChanged:)]) {
            [self.delegate stateChanged:playing];
        }
    } else if ([message.name isEqualToString:@"loaded"]) {
//        NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([self.delegate respondsToSelector:@selector(viewIsReady)]) {
            [self.delegate viewIsReady];
        }
    }
}

- (void)stringFromEvaluatingJavaScript:(NSString *)jsToExecute completionHandler:(void (^ __nullable)(NSString * __nullable response, NSError * __nullable error))completionHandler{
    [webView evaluateJavaScript:jsToExecute completionHandler:^(NSString * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(response, error);
        }
    }];
}

- (BOOL)loadWithPlayerParams:(NSDictionary *)playerParams {
    if (!originURL) {
        originURL = [[NSURL alloc] initWithString:baseUrl];
    }
    // Remove the existing webView to reset any state
    [webView removeFromSuperview];
    webView = [self createNewWebView];
    [self addSubview:webView];
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:webView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:webView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0.0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:webView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:webView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0.0];
    NSArray *constraints = @[topConstraint, leftConstraint, rightConstraint, bottomConstraint];
    [self addConstraints:constraints];
    
    NSError *error = nil;
    NSString *path = [[NSBundle bundleForClass:[FLPlayerView class]] pathForResource:@"fl-player"
                                                                              ofType:@"html"
                                                                         inDirectory:@"Assets"];
    // in case of using Swift and embedded frameworks, resources included not in main bundle,
    // but in framework bundle
    if (!path) {
        path = [[[self class] frameworkBundle] pathForResource:@"fl-player"
                                                        ofType:@"html"
                                                   inDirectory:@"Assets"];
    }
    NSString *embedHTMLTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Received error rendering template: %@", error);
        return NO;
    }
    
    NSError *jsonRenderingError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonRenderingError];
    
    if (jsonRenderingError) {
        NSLog(@"Attempted configuration of player with invalid playerVars: %@ \tError: %@",
              playerParams,
              jsonRenderingError);
        return NO;
    }
    
    NSString *playerVarsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *embedHTML = [NSString stringWithFormat:embedHTMLTemplate, playerVarsJsonString];
    [webView loadHTMLString:embedHTML baseURL: originURL];
    
    return YES;
}

- (WKWebView *)createNewWebView {
    
    // WKWebView equivalent for UIWebView's scalesPageToFit
    // http://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    [wkUController addScriptMessageHandler:self name:@"progress"];
    [wkUController addScriptMessageHandler:self name:@"loaded"];
    [wkUController addScriptMessageHandler:self name:@"stateChanged"];

    configuration.userContentController = wkUController;
    
    configuration.allowsInlineMediaPlayback = YES;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    webView.scrollView.scrollEnabled = NO;
    webView.scrollView.bounces = NO;
    
    return webView;
}

+ (NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle bundleForClass:[self class]] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"FLPlayerView.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}
@end
