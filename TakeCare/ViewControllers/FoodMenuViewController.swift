
import UIKit
import Firebase

class FoodMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var breakfestTableView: UITableView!
    @IBOutlet weak var lunchTableView: UITableView!
    @IBOutlet weak var dinnerTableView: UITableView!
    private var ref = Firestore.firestore().collection(Auth.auth().currentUser!.uid)
    var breakfestArr : [String] = []
    var lunchArr = [String]()
    var dinnerArr = [String]()
    var tempMeal : BLD = BLD.breakfest
    override func viewDidLoad() {
        super.viewDidLoad()
        populateArray("Breakfest")
        populateArray("Lunch")
        populateArray("Dinner")
        breakfestTableView.dataSource = self
        breakfestTableView.delegate = self
        lunchTableView.dataSource = self
        lunchTableView.delegate = self
        dinnerTableView.dataSource = self
        dinnerTableView.delegate = self
    }
    
    func populateArray (_ meal: String){
        ref.document(meal).getDocument(completion: { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let count = documentSnapshot?.data()?.count
            if count != nil {
                var strNum = "1"
                for i in 1...count!{
                    strNum = String(i)
                    if (meal == "Breakfest"){
                        self.breakfestArr.append(documentSnapshot?.get(strNum) as! String)
                    }else if (meal == "Lunch"){
                        self.lunchArr.append(documentSnapshot?.get(strNum) as! String)
                    }else if (meal == "Dinner"){
                        self.dinnerArr.append(documentSnapshot?.get(strNum) as! String)}
                    
                }
                self.dinnerTableView.reloadData()
                self.lunchTableView.reloadData()
                self.breakfestTableView.reloadData()
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddFoodViewController{
            vc.tempMeal = tempMeal
        }
    }
    func clearDB(_ meal: String){
        ref.document(meal).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.dinnerTableView.reloadData()
        self.lunchTableView.reloadData()
        self.breakfestTableView.reloadData()
    }
    
    @IBAction func goBack(_ sender: Any) {
        let menuViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.MenuViewController) as? MenuViewController
        view.window?.rootViewController = menuViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func clearBreakfestDB(_ sender: Any) {
        breakfestArr = []
        clearDB("Breakfest")
    }
    
    @IBAction func clearLunchDB(_ sender: Any) {
        lunchArr=[]
        clearDB("Lunch")
    }
    
    
    @IBAction func clearDinnerDB(_ sender: Any) {
        dinnerArr = []
        clearDB("Dinner")
    }
    
    @IBAction func addBreakfest(_ sender: Any) {
        tempMeal = BLD.breakfest
    }
    
    
    @IBAction func addLunch(_ sender: Any) {
        tempMeal = BLD.lunch
    }
    
    
    @IBAction func addDinner(_ sender: Any) {
        tempMeal = BLD.dinner
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        var numberOfRows = 1
        switch tableView {
        case breakfestTableView:
            numberOfRows = breakfestArr.count
        case lunchTableView:
            numberOfRows = lunchArr.count
        case dinnerTableView:
            numberOfRows = dinnerArr.count
        default: break
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = UITableViewCell()
        switch tableView {
        case breakfestTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "bCell", for: indexPath)
            if breakfestArr.isEmpty{
                cell.textLabel!.text = "No Food To Diplay"
            }else{
                cell.textLabel!.text = breakfestArr[indexPath.row]
            }
        case lunchTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "lCell", for: indexPath)
            if lunchArr.isEmpty{
                cell.textLabel!.text = "No Food To Diplay"
            }else{
                cell.textLabel!.text = lunchArr[indexPath.row]
            }
        case dinnerTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath)
            if dinnerArr.isEmpty{
                cell.textLabel!.text = "No Food To Diplay"
            }else{
                cell.textLabel!.text = dinnerArr[indexPath.row]
            }
        default: break
            
        }
        
        return cell
    }
}

