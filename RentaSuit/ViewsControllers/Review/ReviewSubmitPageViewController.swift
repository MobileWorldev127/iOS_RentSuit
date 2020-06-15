
import Foundation
protocol SubmitReviewDelegate {
    func submitReview(review:Review)
}
class ReviewSubmitPageViewController: BasepageViewController, PickableValuesTextFieldDelegate {

  @IBOutlet weak var backgroundView: UIView!
    var delegate : SubmitReviewDelegate?
    var category  :CategoryProduct?
    
//    @IBOutlet weak var ratingTextField: PickableDataTextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var ratingTextFiled: PickableDataTextField!
  @IBOutlet weak var submitBtn: UIButton!
    
    static let sharedInstance: ReviewSubmitPageViewController = {
        let instance: ReviewSubmitPageViewController = UIStoryboard(name: "RentedList", bundle: nil).instantiateViewController(withIdentifier: "ReviewSubmitPageViewController") as! ReviewSubmitPageViewController
        instance.index = 1
        
        return instance
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        setUpInfo()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubmitPageViewController.didCloseFilter(_:)))
        self.backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func didCloseFilter(_ sender : UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func submitBtnPressed(_ sender: Any) {
        if ( ((titleTextField.text?.isEmpty)! && (commentTextView.text?.isEmpty)! )){
            self.dismiss(animated: true, completion: nil)
        }else{
            if Reachability.isConnectedToNetwork() {
//                filterProductsWs()
//              self.delegate?.submitReview(review: [])
              print("=======>")
            }else {
                self.showAlertView(title: "", message: "network_error".localized)
                
            }
        }
        
    }
//    func filterProductsWs()  {
//        var params : Dictionary<String , String> = [:]
//        if (sizeTextField.text == "XS") {
//          params ["size"] = "Extra Small" as String
//        }
//        if (sizeTextField.text == "S") {
//          params ["size"] = "Small" as String
//        }
//        if (sizeTextField.text == "M") {
//          params ["size"] = "Medium" as String
//        }
//        if (sizeTextField.text == "L") {
//          params ["size"] = "Large" as String
//        }
//        if (sizeTextField.text == "XL") {
//          params ["size"] = "Extra Large" as String
//        }
//
//        if (priceTextField.text == "Per Month") {
//          params ["per"] = "per_day" as String
//        }
//        if (priceTextField.text == "Per Week") {
//          params ["per"] = "per_week" as String
//        }
//        if (priceTextField.text == "Per Month") {
//          params ["per"] = "per_month" as String
//        }
//        params ["page"] = "1" as String
//        params ["category_id"] = category?.id as! String
//        params ["results_per_page"] = "50" as String
//        Product.filtreProduitWs(credentials:  params as! Dictionary<String, String> as Dictionary<String, String>) { (listProducts, error) in
//            if (listProducts != nil){
//                if self.delegate != nil {
//                    self.delegate?.filterProducts(homeProduct: listProducts!)
//                }
//            }
//            self.dismiss(animated: true, completion: nil)
//
//        }
//
//    }
    func setUpInfo(){
//        sizeTextField.text = sizeSet.first
//        priceTextField.text = priceSet.first

        setUpSelector(ratingTextFiled, dataSet: ratingSet, action: .done)
//        setUpSelector(priceTextField, dataSet: priceSet, action: .done)

    }
    fileprivate func setUpSelector(_ sender : PickableDataTextField, dataSet : [String]?, action : ExtrasActions) {
        sender.dataSet = (dataSet! as [AnyObject])
        sender.extras = action
        sender.pickableDelegate = self
    }
    func didSelectValue(sender: PickableValuesTextField, value: AnyObject?) {
        if value is String {
            sender.text = (value as! String)
        }
    }
    
    func didRequestNext(sender: PickableValuesTextField) {
        
        
    }
    
    func didRequestDone(sender: PickableValuesTextField) {
        self.view.endEditing(true)
    }

}
