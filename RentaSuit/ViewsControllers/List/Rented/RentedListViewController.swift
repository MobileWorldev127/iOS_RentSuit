
import Foundation

class RentedListViewController: ItemListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func deleteItem(cell : UITableViewCell, item : Any, index : Int) {
        let itemCast = item as! RentedProduct
        var params : Dictionary<String , NSObject> = [:]
        params["rented_id"] = (item as AnyObject).rentedId as! NSObject
        params["status"] = "cancel" as! NSObject
        RentedProduct.changeStatusRentedList(params: params as! Dictionary<String, NSObject>) { (code, err) in
            self.changeStatus(cell)
        }
    }
}
