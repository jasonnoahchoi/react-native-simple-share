
#import "RNSimpleShare.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>
#import <React/RCTUIManager.h>
#import <React/RCTImageLoader.h>

@implementation RNSimpleShare

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(share:(NSDictionary *)options
                  failureCallback:(RCTResponseErrorBlock)failureCallback
                  successCallback:(RCTResponseSenderBlock)successCallback)
{
    if (RCTRunningInAppExtension()) {
        RCTLogError(@"Unable to show action sheet from app extension");
        return;
    }
    
    NSString *imageUrl = options[@"imageUrl"];
    NSString *image = options[@"image"];
    NSString *imageBase64 = options[@"imageBase64"];
    
    __block UIImage *shareableImage;
    
    if (image) {
        shareableImage = [UIImage imageNamed:image];
    }
    
    if (imageBase64) {
        NSError *error;
        @try {
            NSData *decodedImage = [[NSData alloc] initWithBase64EncodedString:imageBase64
                                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
            shareableImage = [UIImage imageWithData:decodedImage];
        } @catch (NSException *exception) {
            failureCallback(error);
            RCTLogWarn(@"Could not decode image.");
        }
    }
    
    if (!imageUrl) {
        return [self showWithMoreOptions:options image:shareableImage failureCallback:^(NSError *error) {
            failureCallback(error);
        } successCallback:^(NSArray *response) {
            successCallback(response);
        }];
    }
    
    __weak RNSimpleShare *weakSelf = self;
    
    [self.bridge.imageLoader loadImageWithURLRequest: [RCTConvert NSURLRequest: imageUrl]
        callback:^(NSError *error, UIImage *image) {
            if (!error) {
                dispatch_async([weakSelf methodQueue], ^{
                    [weakSelf showWithMoreOptions:options image:image failureCallback:^(NSError *error) {
                        failureCallback(error);
                    } successCallback:^(NSArray *response) {
                        successCallback(response);
                    }];
                });
            } else {
                RCTLogWarn(@"Could not fetch image.");
                failureCallback(error);
            }
        }
     ];
}

- (void)showWithMoreOptions:(NSDictionary *)options image:(UIImage *)image failureCallback:(RCTResponseErrorBlock)failureCallback successCallback:(RCTResponseSenderBlock)successCallback
{
    NSArray *items = [self checkForItemsWithOptions:options image:image];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    NSString *subject = [RCTConvert NSString:options[@"subject"]];
    if (subject) {
        [shareController setValue:subject forKey:@"subject"];
    }
    
    NSArray *excludedActivityTypes = [RCTConvert NSStringArray:options[@"excludedActivityTypes"]];
    if (excludedActivityTypes) {
        shareController.excludedActivityTypes = excludedActivityTypes;
    }
    
    // Display the Activity View
    UIViewController *controller = RCTPresentedViewController();
    shareController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, __unused NSArray *returnedItems, NSError *activityError) {
        if (activityError) {
            failureCallback(@[activityError, RCTNullIfNil(activityType)]);
        } else {
            successCallback(@[@(completed), RCTNullIfNil(activityType)]);
        }
    };
    
    shareController.modalPresentationStyle = UIModalPresentationPopover;
    NSNumber *anchorViewTag = [RCTConvert NSNumber:options[@"anchor"]];
    if (!anchorViewTag) {
        shareController.popoverPresentationController.permittedArrowDirections = 0;
    }
    shareController.popoverPresentationController.sourceView = controller.view;
    shareController.popoverPresentationController.sourceRect = [self sourceRectInView:controller.view anchorViewTag:anchorViewTag];
    
    [controller presentViewController:shareController animated:YES completion:nil];
    
    shareController.view.tintColor = [RCTConvert UIColor:options[@"tintColor"]];
}

- (NSArray *)checkForItemsWithOptions:(NSDictionary *)options image:(UIImage *)image {
    NSMutableArray *items = [NSMutableArray array];
    NSString *text = options[@"text"];
    NSURL *url = options[@"url"];
    NSObject *file = options[@"file"];
    
    // Return if no args were passed
    if (!text && !url && !image && !file) {
        RCTLogError(@"You must specify a text, url, image, imageBase64 and/or imageUrl.");
        return items;
    }
    
    if (text) {
        [items addObject:text];
    }
    
    if (url) {
        [items addObject:url];
    }
    
    if (image) {
        [items addObject:image];
    }
    
    if (file) {
        [items addObject:file];
    }
    return items;
}

- (CGRect)sourceRectInView:(UIView *)sourceView anchorViewTag:(NSNumber *)anchorViewTag
{
    if (anchorViewTag) {
        UIView *anchorView = [self.bridge.uiManager viewForReactTag:anchorViewTag];
        return [anchorView convertRect:anchorView.bounds toView:sourceView];
    } else {
        return (CGRect){sourceView.center, {1, 1}};
    }
}

@end

