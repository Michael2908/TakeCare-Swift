

import UIKit
import Firebase

class VitalsViewController: UIViewController {
    
    @IBOutlet weak var heartRate: UITextField!
    @IBOutlet weak var bloodPressure: UITextField!
    @IBOutlet weak var bloodSugar: UITextField!
    @IBOutlet weak var temperature: UITextField!
    private var docRef = Firestore.firestore().collection(Auth.auth().currentUser!.uid).document("Vitals")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                self.heartRate.text = document.get("heartRate") as? String
                self.bloodSugar.text = document.get("bloodSugar") as? String
                self.bloodPressure.text = document.get("bloodPressure") as? String
                self.temperature.text = document.get("temperature") as? String
            } else {
                print("Document does not exist in cache")
            }
        }
        
        // Do any additional setup after loading the view.
    }
 
    @IBAction func goBack(_ sender: Any) {
        let menuViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.MenuViewController) as? MenuViewController
        view.window?.rootViewController = menuViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func UpdateButton(_ sender: Any) {
        let rate = heartRate.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pressure = bloodPressure.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sugar = bloodSugar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let temp = temperature.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        docRef.setData(["heartRate": rate ?? "0","bloodPressure": pressure ?? "0","bloodSugar":sugar ?? "0","temperature":temp ?? "0"]){ (error) in
            if error != nil {
                print(error.debugDescription)
            }
        }
    }
    
}

