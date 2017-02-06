//
//  PhotoPostNode.m
//  ASLayoutSpecPlayground
//
//  Created by Hannah Troisi on 3/11/16.
//  Copyright © 2016 Hannah Troisi. All rights reserved.
//

#import "PhotoPostNode.h"
#import "AsyncDisplayKit+Debug.h"
#import "Utilities.h"

#define USER_IMAGE_HEIGHT       60
#define HORIZONTAL_BUFFER       10
#define VERTICAL_BUFFER         5
#define FONT_SIZE               20

@implementation PhotoPostNode
{
  NSUInteger          _index;
  ASNetworkImageNode  *_userAvatarImageView;
  ASNetworkImageNode  *_photoImageView;
  ASTextNode          *_userNameLabel;
  ASTextNode          *_photoLocationLabel;
  ASTextNode          *_photoTimeIntervalSincePostLabel;
  ASTextNode          *_photoLikesLabel;
  ASTextNode          *_photoDescriptionLabel;
}

#pragma mark - Lifecycle

- (instancetype)initWithIndex:(NSUInteger)index
{
  self = [super init];
  
  if (self) {
    
    self.backgroundColor                 = [UIColor whiteColor];
    self.automaticallyManagesSubnodes = YES;
    self.shouldVisualizeLayoutSpecs = YES;
    self.shouldCacheLayoutSpec = YES;
    
    _index = index;
    
    _userAvatarImageView     = [[ASNetworkImageNode alloc] init];
    _userAvatarImageView.URL = [NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/avatars/503h_1458880322_140.jpg"];
    
    [_userAvatarImageView setImageModificationBlock:^UIImage *(UIImage *image) {   // FIXME: in framework autocomplete for setImageModificationBlock line seems broken
      CGSize profileImageSize = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
      return [image makeCircularImageWithSize:profileImageSize withBorderWidth:0];
    }];
    
    _userNameLabel                  = [[ASTextNode alloc] init];
    _userNameLabel.attributedText = [self usernameAttributedStringWithFontSize:FONT_SIZE];
    
    _photoLocationLabel                      = [[ASTextNode alloc] init];
    _photoLocationLabel.maximumNumberOfLines = 1;
    _photoLocationLabel.attributedText     = [self locationAttributedStringWithFontSize:FONT_SIZE];
    
    _photoTimeIntervalSincePostLabel                  = [[ASTextNode alloc] init];
    _photoTimeIntervalSincePostLabel.attributedText = [self uploadDateAttributedStringWithFontSize:FONT_SIZE];
    
    _photoImageView     = [[ASNetworkImageNode alloc] init];
    _photoImageView.URL = [NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/564x/9f/5b/3a/9f5b3a35640bc7a5d484b66124c48c46.jpg"];
    
    _photoLikesLabel                  = [[ASTextNode alloc] init];
    _photoLikesLabel.attributedText = [self likesAttributedStringWithFontSize:FONT_SIZE];
    
    _photoDescriptionLabel                      = [[ASTextNode alloc] init];
    _photoDescriptionLabel.attributedText     = [self descriptionAttributedStringWithFontSize:FONT_SIZE];
    _photoDescriptionLabel.maximumNumberOfLines = 3;
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    switch (_index) {
    case 1:
      return [self layoutSpecThatFitsNavBar:constrainedSize];
    case 2:
      return [self layoutSpecThatFitsASDKgram:constrainedSize];
    default:
      return [self layoutSpecThatFitsASDKgram:constrainedSize];
      break;
  }
}

- (ASLayoutSpec *)layoutSpecThatFitsNavBar:(ASSizeRange)constrainedSize
{
  // username / photo location header vertical stack
  
  _userNameLabel.style.flexShrink      = 1.0;
  _photoLocationLabel.style.flexShrink = 1.0;

  ASStackLayoutSpec *headerSubStack = [ASStackLayoutSpec verticalStackLayoutSpec];
  headerSubStack.style.flexShrink   = 1.0;
  
  if (_photoLocationLabel.attributedText) {
    [headerSubStack setChildren:@[_userNameLabel, _photoLocationLabel]];
  } else {
    [headerSubStack setChildren:@[_userNameLabel]];
  }
  
  // header stack
  
  _userAvatarImageView.style.preferredSize             = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
  _photoTimeIntervalSincePostLabel.style.spacingBefore = HORIZONTAL_BUFFER; // hack to remove double spaces around spacer
  
  UIEdgeInsets avatarInsets          = UIEdgeInsetsMake(HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *avatarInset     = [ASInsetLayoutSpec insetLayoutSpecWithInsets:avatarInsets child:_userAvatarImageView];
  
  ASLayoutSpec *spacer               = [[ASLayoutSpec alloc] init];
  spacer.style.flexGrow              = 1.0;
  spacer.style.flexShrink            = 1.0;  // FIXME: this overrides stuff :) THIS IS A SYSTEMIC ISSUE - can we make layoutSpecThatFits only run once? cache layoutSpec, just use new constrainedSize, don't put properties in layoutSpecThatFits
  // separate the idea of laying out and rerunning with new constrainedSize
  
  ASStackLayoutSpec *headerStack     = [ASStackLayoutSpec horizontalStackLayoutSpec];
  headerStack.alignItems             = ASStackLayoutAlignItemsCenter;                     // center items vertically in horizontal stack
  headerStack.justifyContent         = ASStackLayoutJustifyContentStart;                  // justify content to the left side of the header stack
  headerStack.style.flexShrink       = 1.0;
  headerStack.style.flexGrow         = 1.0;
  
  [headerStack setChildren:@[avatarInset, headerSubStack, spacer, _photoTimeIntervalSincePostLabel]];
  
  // header inset stack
  
  UIEdgeInsets insets                = UIEdgeInsetsMake(0, HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *headerWithInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:headerStack];
  headerWithInset.style.flexShrink   = 1.0;
  headerWithInset.style.flexGrow     = 1.0;
  
  return headerWithInset;
}

- (ASLayoutSpec *)layoutSpecThatFitsASDKgram:(ASSizeRange)constrainedSize
{
  // username / photo location header vertical stack
  
  _userNameLabel.style.flexShrink      = 1.0;
  _photoLocationLabel.style.flexShrink = 1.0;

  ASStackLayoutSpec *headerSubStack = [ASStackLayoutSpec verticalStackLayoutSpec];
  headerSubStack.style.flexShrink   = 1.0;
  
  if (_photoLocationLabel.attributedText) {
    [headerSubStack setChildren:@[_userNameLabel, _photoLocationLabel]];
  } else {
    [headerSubStack setChildren:@[_userNameLabel]];
  }
  
  // header stack
  
  _userAvatarImageView.style.preferredSize             = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
  _photoTimeIntervalSincePostLabel.style.spacingBefore = HORIZONTAL_BUFFER; // hack to remove double spaces around spacer
  
  UIEdgeInsets avatarInsets          = UIEdgeInsetsMake(HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *avatarInset     = [ASInsetLayoutSpec insetLayoutSpecWithInsets:avatarInsets child:_userAvatarImageView];
  
  ASLayoutSpec *spacer               = [[ASLayoutSpec alloc] init];
  spacer.style.flexGrow              = 1.0;
  spacer.style.flexShrink            = 1.0;  // FIXME: this overrides stuff :) THIS IS A SYSTEMIC ISSUE - can we make layoutSpecThatFits only run once? cache layoutSpec, just use new constrainedSize, don't put properties in layoutSpecThatFits
  // separate the idea of laying out and rerunning with new constrainedSize
  
  ASStackLayoutSpec *headerStack     = [ASStackLayoutSpec horizontalStackLayoutSpec];
  headerStack.alignItems             = ASStackLayoutAlignItemsCenter;                     // center items vertically in horizontal stack
  headerStack.justifyContent         = ASStackLayoutJustifyContentStart;                  // justify content to the left side of the header stack
  headerStack.style.flexShrink       = 1.0;
  headerStack.style.flexGrow         = 1.0;
  
  [headerStack setChildren:@[avatarInset, headerSubStack, spacer, _photoTimeIntervalSincePostLabel]];
  
  // header inset stack
  
  UIEdgeInsets insets                = UIEdgeInsetsMake(0, HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *headerWithInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:headerStack];
  headerWithInset.style.flexShrink   = 1.0;
  headerWithInset.style.flexGrow     = 1.0;
  
  // footer stack
  
  ASStackLayoutSpec *footerStack     = [ASStackLayoutSpec verticalStackLayoutSpec];
  footerStack.spacing                = VERTICAL_BUFFER;
  
  [footerStack setChildren:@[_photoLikesLabel, _photoDescriptionLabel]];
  
  // footer inset stack
  
  UIEdgeInsets footerInsets          = UIEdgeInsetsMake(VERTICAL_BUFFER, HORIZONTAL_BUFFER, VERTICAL_BUFFER, HORIZONTAL_BUFFER);
  ASInsetLayoutSpec *footerWithInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:footerInsets child:footerStack];
  
  // vertical stack
  
  ASRatioLayoutSpec *photoRatioSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0 child:_photoImageView];
  
  ASStackLayoutSpec *verticalStack   = [ASStackLayoutSpec verticalStackLayoutSpec];
  verticalStack.alignItems           = ASStackLayoutAlignItemsStretch;                // sretch headerStack to fill horizontal space
  [verticalStack setChildren:@[headerWithInset, photoRatioSpec, footerWithInset]];
  verticalStack.style.flexShrink     = 1.0;
  
  return verticalStack;
}

#pragma mark - helper methods

- (NSAttributedString *)usernameAttributedStringWithFontSize:(CGFloat)size
{
  return [NSAttributedString attributedStringWithString:@"hannahmbanana"
                                               fontSize:size
                                                  color:[UIColor darkBlueColor]
                                         firstWordColor:nil];
}

- (NSAttributedString *)locationAttributedStringWithFontSize:(CGFloat)size
{
  return [NSAttributedString attributedStringWithString:@"San Fransisco, CA"
                                               fontSize:size
                                                  color:[UIColor lightBlueColor]
                                         firstWordColor:nil];
}

- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size
{
  return [NSAttributedString attributedStringWithString:@"30m"
                                               fontSize:size
                                                  color:[UIColor lightGrayColor]
                                         firstWordColor:nil];
}

- (NSAttributedString *)likesAttributedStringWithFontSize:(CGFloat)size
{
  return [NSAttributedString attributedStringWithString:@"♥︎ 17 likes"
                                               fontSize:size
                                                  color:[UIColor darkBlueColor]
                                         firstWordColor:nil];
}

- (NSAttributedString *)descriptionAttributedStringWithFontSize:(CGFloat)size
{
  NSString *string               = [NSString stringWithFormat:@"hannahmbanana check out this cool pic from the internet!"];
  NSAttributedString *attrString = [NSAttributedString attributedStringWithString:string
                                                                         fontSize:size
                                                                            color:[UIColor darkGrayColor]
                                                                   firstWordColor:[UIColor darkBlueColor]];
  return attrString;
}

@end
