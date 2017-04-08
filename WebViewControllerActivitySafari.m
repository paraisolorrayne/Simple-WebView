//
//  WebViewControllerActivitySafari.m
//  POP Store
//
//  Created by Lorrayne Paraiso on 03/03/17.
//  Copyright © 2017 DevTech. All rights reserved.
//

#import "WebViewControllerActivitySafari.h"

@interface WebViewControllerActivitySafari ()

@end

@implementation WebViewControllerActivitySafari

- (NSString *)activityTitle {
    return NSLocalizedStringFromTable(@"Open in Safari", @"WebViewController", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
            return YES;
        }
    }
    return NO;
    
}

- (void)performActivity {
    BOOL completed = [[UIApplication sharedApplication] canOpenURL:self.URLToOpen];
    [self activityDidFinish:completed];
}

@end
