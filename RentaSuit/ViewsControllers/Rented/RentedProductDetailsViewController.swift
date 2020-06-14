
import Foundation
import Cosmos

class RentedProductDetailsViewController: BaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productOwnerImage: UIImageView!
    @IBOutlet weak var productDeliveryOptionLabel: UILabel!
    @IBOutlet weak var productRentStartDateLabel: UILabel!
    @IBOutlet weak var productRentEndDateLabel: UILabel!
    @IBOutlet weak var productDeliverLocation1Label: UILabel!
    @IBOutlet weak var productDeliverLocation2Label: UILabel!
    @IBOutlet weak var productEmailLabel: UILabel!
    @IBOutlet weak var productContactLabel: UILabel!
    @IBOutlet weak var productRentDescriptionLabel: UILabel!
    @IBOutlet weak var productStatusLabel: UILabel!
  
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var productReviewsLabel: UILabel!
    @IBOutlet weak var productSeasonLabel: UILabel!
    @IBOutlet weak var productSizeLabel: UILabel!
    @IBOutlet weak var productColorLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productDatePostedLabel: UILabel!
    @IBOutlet weak var productOwnerNameLabel: UILabel!
    @IBOutlet weak var productOwnerContactLabel: UILabel!
    @IBOutlet weak var productOwnerLocationLabel: UILabel!
    @IBOutlet weak var productBodyTypeLabel: UILabel!
  
    @IBOutlet weak var ratingField: PickableDataTextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
  
    var item : RentedProductDetail?
    
  override func viewDidLoad() {
      super.viewDidLoad()
      setUp()
  }
  
  func setUp() {
      let placeHolder : UIImage? = UIImage.init(named: "placeholder-test")
      if (item?.rentedProductDetail?.picture != nil) {
        let urlwithPercentEscapes =  (item?.rentedProductDetail?.picture)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
           let url:URL = URL(string:urlwithPercentEscapes!)!
           self.productImage.setImageWith(url, placeholderImage: placeHolder)
       }
    self.productDeliveryOptionLabel.text = item?.deliveryOption
    self.productRentStartDateLabel.text = "From: " + (item?.rentalStartDate)!
    self.productRentEndDateLabel.text = "To: " + (item?.rentalEndDate)!
    self.productDeliverLocation1Label.text = item!.streetNumber! + ", " + item!.city! + item!.state! + ", " + item!.postalCode! + ", " + item!.country!
    self.productDeliverLocation2Label.text = item?.address2
    self.productEmailLabel.text = "Email: " + item!.email!
    self.productContactLabel.text = "Contact: " + item!.rentedcontactNumber!
    self.productRentDescriptionLabel.text = "Description: " + item!.detail!
    self.productNameLabel.text = item?.rentedProductDetail?.name
    ratingView.rating = Double(exactly: (item?.rentedProductDetail?.rating)!)!
    self.productReviewsLabel.text = (item?.rentedProductDetail?.totalReviews!)! + " REVIEWS"
    self.productSeasonLabel.text = item?.rentedProductDetail?.season
    self.productSizeLabel.text = item?.rentedProductDetail?.size
    self.productColorLabel.text = item?.rentedProductDetail?.color
    self.productPriceLabel.text = item?.rentedProductDetail?.price
    self.productDescriptionLabel.text = item?.rentedProductDetail?.detail
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MM/dd/yyyy"
    let date: Date? = dateFormatterGet.date(from: (item?.rentedProductDetail!.createdAt)!)
    self.productDatePostedLabel.text = dateFormatterPrint.string(from: date!)
    
    if (item?.rentedProductDetail?.userDetail?.photo != nil) {
     let urlwithPercentEscapes =  (item?.rentedProductDetail?.userDetail?.photo)!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url:URL = URL(string:urlwithPercentEscapes!)!
        self.productOwnerImage.contentMode = UIViewContentMode.scaleAspectFill;
        self.productOwnerImage.setImageWith(url, placeholderImage: placeHolder)
    }
    
    self.productOwnerNameLabel.text = item?.rentedProductDetail?.userDetail?.displayName()
    self.productOwnerContactLabel.text = item?.rentedProductDetail?.userDetail?.contactNumber
    self.productOwnerLocationLabel.text = item?.rentedProductDetail?.userDetail?.location
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
  }
}
