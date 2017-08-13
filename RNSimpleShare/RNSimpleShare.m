
#import "RNSimpleShare.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>
#import <React/RCTUIManager.h>
#import <React/RCTImageLoader.h>

static UIActivityType const UIActivityTypePostToPinterest = @"pinterest.ShareExtension";

@interface RNSimpleShare() <UIActivityItemSource>

@property (nonatomic, strong) NSDictionary *options;

@end

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
        return [self showWithOptions:options image:shareableImage failureCallback:^(NSError *error) {
            failureCallback(error);
        } successCallback:^(NSArray *response) {
            successCallback(response);
        }];
    }
    
    __weak RNSimpleShare *weakSelf = self;
    
    [self.bridge.imageLoader loadImageWithURLRequest: [RCTConvert NSURLRequest: imageUrl]
                                            callback:^(NSError *error, UIImage *image) {
        if (error) {
            RCTLogWarn(@"Could not fetch image.");
            failureCallback(error);
        } else {
            dispatch_async([weakSelf methodQueue], ^{
                [weakSelf showWithOptions:options image:image failureCallback:^(NSError *error) {
                    failureCallback(error);
                } successCallback:^(NSArray *response) {
                    successCallback(response);
                }];
            });
        }
    }];
}

- (void)showWithOptions:(NSDictionary *)options image:(UIImage *)image failureCallback:(RCTResponseErrorBlock)failureCallback successCallback:(RCTResponseSenderBlock)successCallback
{
    self.options = options;
    
    NSArray *items = [self checkForItemsWithOptions:options image:image];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    
    NSArray *excludedActivityTypes = [self excludedActivityTypes:options[@"excludedActivityTypes"]];
    if (excludedActivityTypes) {
        shareController.excludedActivityTypes = excludedActivityTypes;
    }
    
    // Display the Activity View
    UIViewController *controller = RCTPresentedViewController();
    shareController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, __unused NSArray *returnedItems, NSError *activityError) {
        if (activityError) {
            failureCallback(activityError);
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
    NSString *title = options[@"title"];
    NSString *description = options[@"description"];
    NSURL *url =  [RCTConvert NSURL:options[@"url"]];
    NSObject *file = options[@"file"];
    
    // Return if no options were passed
    if (!title && !description && !url && !image && !file) {
        RCTLogError(@"You must specify a text, url, image, imageBase64 and/or imageUrl.");
        return items;
    }
    
    [items addObject:self];
    
    if (image) {
        [items addObject:image];
    }
    
    if (url) {
        [items addObject:url];
    }
    
    if (![title isKindOfClass:[NSNull class]] || title.length) {
        [items addObject:title];
    }
    
    if (![description isKindOfClass:[NSNull class]] && description.length) {
        [items addObject:description];
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

- (NSArray *)excludedActivityTypes:(NSArray *)activityTypes {
    NSDictionary *activityTypesMap = [self activityTypes];
    
    NSMutableArray *excludedActivityTypes = [NSMutableArray new];
    
    [activityTypes enumerateObjectsUsingBlock:^(NSString *activityTypeKey, NSUInteger idx, BOOL *stop) {
        NSString *activityType = [activityTypesMap objectForKey:activityTypeKey];
        if (!activityType) {
            RCTLogWarn(@"activityTypeKey not found: %@. Try one of these: %@", activityTypeKey, [activityTypesMap allKeys]);
            return;
        }
        [excludedActivityTypes addObject:activityType];
    }];
    
    return [RCTConvert NSStringArray:excludedActivityTypes];
}

- (NSDictionary *)activityTypes {
    return @{
             @"postToFacebook"     : UIActivityTypePostToFacebook,
             @"postToTwitter"      : UIActivityTypePostToTwitter,
             @"postToFlickr"       : UIActivityTypePostToFlickr,
             @"postToVimeo"        : UIActivityTypePostToVimeo,
             @"postToTencentWeibo" : UIActivityTypePostToTencentWeibo,
             @"postToWeibo"        : UIActivityTypePostToWeibo,
             @"postToPinterest"    : UIActivityTypePostToPinterest,
             @"message"            : UIActivityTypeMessage,
             @"airDrop"            : UIActivityTypeAirDrop,
             @"mail"               : UIActivityTypeMail,
             @"assignToContact"    : UIActivityTypeAssignToContact,
             @"saveToCameraRoll"   : UIActivityTypeSaveToCameraRoll,
             @"addToReadingList"   : UIActivityTypeAddToReadingList,
             @"print"              : UIActivityTypePrint,
             @"copyToPasteboard"   : UIActivityTypeCopyToPasteboard
             };
}

//MARK: - UIActivity Item Source

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType {
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        [self itemsForActivityType];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        [self itemsForActivityType];
    } else if ([activityType isEqualToString:UIActivityTypePostToPinterest]) {
        [self itemsForActivityType];
    } else {
        [self itemsForActivityType];
    }
    
    return @[];
}

- (id)itemsForActivityType {
    NSString *title = self.options[@"title"];
    NSString *description = self.options[@"description"];
    if (title && description) {
        return @[@"%@ - %@", title, description];
    } else if (title) {
        return title;
    } else {
        return description;
    }
    return @[];
}

/// if a subject exists in the options dictionary, use it,
/// otherwise use the bundle app name
- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    NSString *subject = [RCTConvert NSString:self.options[@"subject"]];
    if (subject) {
        return subject;
    } else {
        return [[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBundleNameKey];
    }
}

@end
