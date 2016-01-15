//
//  HMPhotoBrowserViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JCHATPhotoBrowserViewController.h"
#import "JCHATPhotoBrowserCollectionViewCell.h"
#import "JCHATPhotoModel.h"
#import "JCHATPhotoPickerConstants.h"

@interface JCHATPhotoBrowserViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate> {
  __weak IBOutlet UICollectionView *collectionView;
  __weak IBOutlet UIView *topBar;
  
  __weak IBOutlet UIButton *selectStatusBtn;
  __weak IBOutlet UIView *bottomBar;
}

@end

@implementation JCHATPhotoBrowserViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES];
  self.navigationController.navigationBar.translucent = NO;
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
  NSIndexPath *currentIndex = [self currentIndex];
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  currentPhotoModel.isSelected = YES;
  [self sendNotificationToFinishSelectPhoto:currentPhotoModel];
}

- (void)sendNotificationToFinishSelectPhoto:(JCHATPhotoModel *)currentPhotoModel {// 改为delegate
  [_selectVCDelegate finshToSelectPhoto:currentPhotoModel];
}

- (void)updateSelectedBtn {
  NSIndexPath *currentIndex = [self currentIndex];
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  selectStatusBtn.selected = currentPhotoModel.isSelected;
  _selectOriginBtn.selected = currentPhotoModel.isOriginPhoto;
}

- (void)setupCollectionView {
  UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  collectionView.pagingEnabled = YES;
  [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [collectionView registerNib:[UINib nibWithNibName:@"JCHATPhotoBrowserCollectionViewCell" bundle:nil]
   forCellWithReuseIdentifier:@"JCHATPhotoBrowserCollectionViewCell"];
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
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[[self currentIndex].item];
  currentPhotoModel.isSelected = !currentPhotoModel.isSelected;
  selectBtn.selected = currentPhotoModel.isSelected;
  [_selectVCDelegate didSelectStatusChange:currentPhotoModel];
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
  static NSString *CellIdentifier = @"JCHATPhotoBrowserCollectionViewCell";
  JCHATPhotoBrowserCollectionViewCell *cell = (JCHATPhotoBrowserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[indexPath.item];
  [cell setDataWithModel:currentPhotoModel];
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSIndexPath *currentIndex = [self currentIndex];
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[currentIndex.item];
  selectStatusBtn.selected = currentPhotoModel.isSelected;
}

- (IBAction)clickToSelectOriginImage:(id)sender {
  UIButton *selectOriginImageBtn = sender;
  JCHATPhotoModel *currentPhotoModel = _allPhotoArr[[self currentIndex].item];
  currentPhotoModel.isOriginPhoto = !currentPhotoModel.isOriginPhoto;
  selectOriginImageBtn.selected = currentPhotoModel.isOriginPhoto;
}

//- (void)layoutB

@end
