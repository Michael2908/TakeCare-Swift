
import UIKit
import Firebase

class AddFoodViewController: UIViewController {
    var tempMeal : BLD = BLD.breakfest
    var meal : String = ""
    private var ref = Firestore.firestore().collection(Auth.auth().currentUser!.uid)
    var num : Int = 0
    
    @IBOutlet weak var addFood: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch tempMeal{
        case BLD.breakfest:
            meal = "Breakfest"
            break
        case BLD.lunch:
            meal = "Lunch"
            break
        case BLD.dinner:
            meal = "Dinner"
            break
        }
        
    }
    
    @IBAction func addFoodToDB(_ sender: Any) {
        let tempFood = addFood.text
        var strNum = "1"
        if tempFood != "" {
            ref.document(meal).getDocument(completion: { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let count = documentSnapshot?.data()?.count
                if count == nil {
                    self.addFood(strNum,tempFood!)
                }else{
                    self.num = 1 + count!
                    strNum = String(self.num)
                    self.addFood(strNum,tempFood!)
                    
                }
            })
        }else{
            showAlert("Error", "Field is emtpy!")}}
    
    
    
    func addFood(_ num:String,_ food:String){
        ref.document(self.meal).setData([num: food], merge: true)
        showAlert("Success!", "Food Added To The Menu")
        addFood.text = ""
    }
    
    func showAlert(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
}



