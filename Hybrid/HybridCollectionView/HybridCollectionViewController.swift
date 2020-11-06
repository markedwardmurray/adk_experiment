import AsyncDisplayKit
import UIKit

final class HybridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  private let cellCount: Int
  private lazy var dataSource = CollectionViewDataSource(cellCount: cellCount)

  init(cellCount: Int) {
    self.cellCount = cellCount
    let layout = Self.layout
    super.init(collectionViewLayout: layout)

    collectionView.collectionViewLayout = layout
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .timesWhite
    collectionView.backgroundColor = .timesWhite
    collectionView.dataSource = dataSource
    collectionView.delegate = self
    collectionView.register(cell: TextureWrapperCell<HeadlineSummaryCellNode>.self)
    collectionView.register(cell: TextureWrapperCell<ThumbnailCellNode>.self)
    collectionView.register(cell: TextureWrapperCell<LargeImageCellNode>.self)
    collectionView.register(cell: TextureWrapperCell<WebCellNode>.self)
  }

  private static let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
    Section(sectionIndex).isCarouselSection ? carouselLayoutSection : defaultLayoutSection
  }

  private static let carouselLayoutSection: NSCollectionLayoutSection = {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(300.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(200.0),
      heightDimension: .estimated(300.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.interGroupSpacing = 10
    section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
    return section
  }()

  private static let defaultLayoutSection: NSCollectionLayoutSection = {
    let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.estimated(44)
    )
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
    return section
  }()
}

final private class CollectionViewDataSource: NSObject, UICollectionViewDataSource {

  private let cellCount: Int

  init(cellCount: Int) {
    self.cellCount = cellCount
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return cellCount
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Section(section).isCarouselSection ? 10 : 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let headline = ContentGenerator.thisManyWords(2...8)
    let summary = ContentGenerator.thisManyWords(20...40)

    switch Section(indexPath.section) {
    case .carouselSection:
      let cell: TextureWrapperCell<LargeImageCellNode> = collectionView.dequeue(for: indexPath)
      cell.customNode = LargeImageCellNode(
        headline: "Miles Davis",
        summary: "Miles Dewey Davis III was an American jazz trumpeter, bandleader, and composer.",
        kicker: "",
        credit: "",
        hideFooter: true,
        crop: Crop(imageFilename: "miles.png", size: CGSize(width: 560, height: 560))
      )
      return cell
    case .headlineSummarySection:
      let cell: TextureWrapperCell<HeadlineSummaryCellNode> = collectionView.dequeue(for: indexPath)
      cell.customNode = HeadlineSummaryCellNode(headline: headline, summary: summary)
      return cell
    case .thumbnailCellSection:
      let cell: TextureWrapperCell<ThumbnailCellNode> = collectionView.dequeue(for: indexPath)
      cell.customNode = ThumbnailCellNode(headline: headline, summary: summary)
      return cell
    case .largeImageCellSection:
      let cell: TextureWrapperCell<LargeImageCellNode> = collectionView.dequeue(for: indexPath)
      cell.customNode = LargeImageCellNode(
        headline: headline,
        summary: summary,
        kicker: "KICKER",
        credit: "Photo by Joe Blow",
        hideFooter: false,
        crop: Crop(imageFilename: "coltrane.jpg", size: CGSize(width: 540, height: 300))
      )
      return cell
    case .webCellSection:
      let cell: TextureWrapperCell<WebCellNode> = collectionView.dequeue(for: indexPath)
      cell.customNode = WebCellNode(
        url: URL(string: "https://secure-ds.serving-sys.com/BurstingRes/Site-85296/WSFolders/7649898/TH029_728x90_r3.hyperesources/TH029_728x90_GiGi.jpg")!,
        height: 50
      )
      return cell
    }
  }
}
