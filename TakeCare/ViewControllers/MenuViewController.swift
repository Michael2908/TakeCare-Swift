

import UIKit
import FirebaseAuth
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var welcomeLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Firestore.firestore().collection(Auth.auth().currentUser!.uid).document("User Info").getDocument(source: .cache) { (document, error) in
            if let document = document {
                var str = document.get("firstname") as! String
                str = "Welcome " + str
                self.welcomeLable.text = str
            } else {
                print("Document does not exist in cache")
            }
        }
        
    }
    
    @IBAction func PillButton(_ sender: Any) {
        let PillScheduleViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.PillScheduleViewController) as? PillScheduelViewController
        view.window?.rootViewController = PillScheduleViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func VitalButton(_ sender: Any) {
        let vitalsViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.VitalsViewController) as? VitalsViewController
        view.window?.rootViewController = vitalsViewController
        view.window?.makeKeyAndVisible()
        
        
    }
    @IBAction func FoodButton(_ sender: Any) {
        let FoodMenuViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.FoodMenuViewController) as? FoodMenuViewController
        view.window?.rootViewController = FoodMenuViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func LogoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.LoginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
}
