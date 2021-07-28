

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func validateFields() -> String?{
        if firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        
        
        return nil
    }
    
    @IBAction func signUp(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            self.showAlert("Error", error!)
        }else{
            
            let firstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    self.showAlert("Error", err!.localizedDescription)
                }else{
                    let db = Firestore.firestore()
                    db
                        .collection(result!.user.uid)
                        .document("User Info")
                        .setData(["firstname":firstName,"lastname":lastName,"email":email,"phone":phone, "uid":result!.user.uid]){ (error) in
                            if error != nil {
                                print(error.debugDescription)
                            }
                        }
                    self.transitionToMainMenu()
                }
                
            }
        }
    }
    func showAlert(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    func transitionToMainMenu(){
        
        let menuViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.MenuViewController) as? MenuViewController
        view.window?.rootViewController = menuViewController
        view.window?.makeKeyAndVisible()
    }
}
