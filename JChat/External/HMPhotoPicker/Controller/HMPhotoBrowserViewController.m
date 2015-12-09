//
//  HMPhotoBrowserViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoBrowserViewController.h"
#import "HMPhotoBrowserCollectionViewCell.h"
#import "HMPhotoModel.h"
#import "HMPhotoPickerConstants.h"

@interface HMPhotoBrowserViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate> {
  __weak IBOutlet UICollectionView *collectionView;
  __weak IBOutlet UIView *topBar;
  
  __weak IBOutlet UIButton *selectStatusBtn;
  __weak IBOutlet UIView *bottomBar;
}

@end

@implementation HMPhotoBrowserViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES];
  [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.view layoutIfNeeded];
  [collectionView scrollToItemAtIndexPath:_currentIndex
                         atScrollPosition:UICollectionViewScrollPositionLeft
                                 animated:NO];
  [self performSelector:@selector(updateSelectedBtn) withObject:nil afterDelay:0.1];
}

- (IBAction)ClickToSendImage:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:kFinishToSelectPhoto object:nil];
}

- (void)updateSelectedBtn {
  NSIndexPath *currentIndex = [self currentIndex];
  HMPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  selectStatusBtn.selected = currentPhotoModel.isSelected;
}

- (void)setupCollectionView {
  UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  collectionView.pagingEnabled = YES;
  [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [collectionView registerNib:[UINib nibWithNibName:@"HMPhotoBrowserCollectionViewCell" bundle:nil]
   forCellWithReuseIdentifier:@"HMPhotoBrowserCollectionViewCell"];
  collectionView.delegate = self;
  collectionView.dataSource = self;
  collectionView.userInteractionEnabled = YES;
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapContent:)];
  [collectionView addGestureRecognizer:gesture];
}

- (void)hidenAllBar {
  [UIView animateWithDuration:0.2 animations:^{
    topBar.hidden = !topBar.hidden;
    bottomBar.hidden = !bottomBar.hidden;
  }];
}

- (IBAction)ClickToBack:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ClickToSelectImage:(id)sender {
  UIButton *selectBtn = sender;
  HMPhotoModel *currentPhotoModel = _allPhotoArr[[self currentIndex].item];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectStatusChange object:@[currentPhotoModel, selectBtn]];
}

- (NSIndexPath *)currentIndex {
  NSInteger itemIndex = collectionView.contentOffset.x / collectionView.frame.size.width;
  NSInteger sectionIndex = 0;
  _currentIndex = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
  return _currentIndex;
}

- (void)tapContent:(UIGestureRecognizer *)gesture {

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  
  return [[UIScreen mainScreen] bounds].size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"HMPhotoBrowserCollectionViewCell";
  HMPhotoBrowserCollectionViewCell *cell = (HMPhotoBrowserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  HMPhotoModel *currentPhotoModel = _allPhotoArr[indexPath.item];
  [cell setDataWithModel:currentPhotoModel];
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSIndexPath *currentIndex = [self currentIndex];
  HMPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  selectStatusBtn.selected = currentPhotoModel.isSelected;
}



@end
