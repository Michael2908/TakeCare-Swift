import UIKit
import Firebase
import UserNotifications

class PillScheduelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var ref = Firestore.firestore().collection(Auth.auth().currentUser!.uid)
    var num : Int = 0
    var pillArr : [String] = []
    @IBOutlet weak var minutes: UITextField!
    @IBOutlet weak var hour: UITextField!
    @IBOutlet weak var pillName: UITextField!
    @IBOutlet weak var pillSchedule: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArray()
        pillSchedule.delegate = self
        pillSchedule.dataSource = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:{didAllow, error in})
    }
    
    func populateArray (){
        ref.document("Pills").getDocument(completion: { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let count = documentSnapshot?.data()?.count
            if count != nil {
                var strNum = "1"
                for i in 1...count!{
                    strNum = String(i)
                    self.pillArr.append(documentSnapshot?.get(strNum) as! String)
                }
                self.pillSchedule.reloadData()
            }
            
        })
    }
    
    func validateFields() -> String?{
        if pillName.text == "" {
            return "Please Fill Pill Name"
        }
        if hour.text == ""{
            return "Please Enter Hour"
        }else{
            let intHour = Int(hour.text!)
            if intHour! > 23 || intHour! < 0  {
                return "Please Enter Hour Between 0-23"
            }
            
        }
        if minutes.text == ""{
            return "Please Enter Minutes"
        }else{
            let intMinutes = Int(minutes.text!)
            if intMinutes! > 59 || intMinutes! < 0  {
                return "Please Enter Minutes Between 0-59"
            }
            
        }
        return nil
    }
    
    @IBAction func goBack(_ sender: Any) {
    let menuViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.MenuViewController) as? MenuViewController
        view.window?.rootViewController = menuViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func clearPills(_ sender: Any) {
        ref.document("Pills").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        pillArr = []
        self.pillSchedule.reloadData()
    }
    @IBAction func addPill(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            self.showAlert("Error", error!)
        }else{
            let tempPill = pillName.text
            let tempHour = hour.text
            let tempMinutes = minutes.text
            var strNum = "1"
            ref.document("Pills").getDocument(completion: { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let count = documentSnapshot?.data()?.count
                if count == nil {
                    let str = tempPill! + "  " + tempHour!+":"+tempMinutes!
                    self.addSinglePill(strNum, str)
                    self.pillArr.append(str)

                }else{
                    self.num = 1 + count!
                    let str = tempPill! + "  " + tempHour!+":"+tempMinutes!
                    strNum = String(self.num)
                    self.addSinglePill(strNum, str)
                    self.pillArr.append(str)

                    
                }
                self.pillSchedule.reloadData()
            })
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.subtitle = tempPill!
            content.body = "Time To Take The Pill"
            content.badge = 1
            var date = DateComponents()
            date.calendar = Calendar.current
            date.hour = Int(tempHour!)
            date.minute = Int(tempMinutes!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }

    }
    func addSinglePill (_ strNum: String,_ str: String){
        self.ref.document("Pills").setData([strNum: str], merge: true)
        self.showAlert("Success!","Pill Added")
        pillName.text = ""
        hour.text = ""
        minutes.text = ""
    }
    func showAlert(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return pillArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "pillCell", for: indexPath)
        if pillArr.isEmpty{
            cell.textLabel!.text = "No Pills To Diplay"
        }else{
            cell.textLabel!.text = pillArr[indexPath.row]
        }
        return cell
    }
    
}
