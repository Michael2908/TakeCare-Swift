

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.transitionToMainMenu()
            }
        }}
    
    func validateFields() -> String?{
        if  EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        
        
        return nil
    }
    @IBAction func login(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            self.showAlert("Error", error!)
        }else{
            let email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    self.showAlert("Error", error!.localizedDescription)
                }else{
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
