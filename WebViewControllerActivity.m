//
//  WebViewControllerActivity.m
//  POP Store
//
//  Created by Lorrayne Paraiso on 03/03/17.
//  Copyright © 2017 DevTech. All rights reserved.
//

#import "WebViewControllerActivity.h"

@interface WebViewControllerActivity ()

@end

@implementation WebViewControllerActivity

- (NSString *)activityType {
    return NSStringFromClass([self class]);
}

- (UIImage *)activityImage {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [UIImage imageNamed:[self.activityType stringByAppendingString:@"-iPad"]];
    else
        return [UIImage imageNamed:self.activityType];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            self.URLToOpen = activityItem;
        }
    }
}

@end
