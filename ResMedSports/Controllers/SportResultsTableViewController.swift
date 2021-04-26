//
//  SportResultsTableViewController.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import UIKit
import Combine
import SwiftyJSON

class SportResultsTableViewController: UITableViewController {
    
    @IBOutlet weak var getResultsBtn: UIBarButtonItem!
    
    lazy var loadingOverlay: UIView = {
        let overlay = UIView(frame: view.frame)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        overlay.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return overlay
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        return indicator
    }()
    
    var subscriptions = Set<AnyCancellable>()
    
    let sportCellNib = UINib(nibName: "SportResultCell", bundle: nil)
    
    let viewModel = SportResultsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$orderedSportResultsDictWithDateKeys
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print("Completed sport results request: \($0)")}) { (orderedSportResults) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //self.loadingOverlay.removeFromSuperview()
                    UIApplication.shared.keyWindow?.stopIndicatingActivity()
                    self.getResultsBtn.isEnabled = true
                }
            }
            .store(in: &subscriptions)
        
        tableView.register(sportCellNib, forCellReuseIdentifier: "SportResultCell")
        
        // preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func getSportResults(_ sender: UIBarButtonItem) {
        //view.addSubview(activityIndicator)
        //activityIndicator.startAnimating()
        
        UIApplication.shared.keyWindow?.startIndicatingActivity()
        //view.addSubview(loadingOverlay)
        sender.isEnabled = false
        viewModel.getGroupedAndOrderedSportResults()
    }
    
}

extension SportResultsTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let count = viewModel.orderedSportResultsDictWithDateKeys.0?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dateKey = viewModel.orderedSportResultsDictWithDateKeys.1?[section],
           let dateKeyElements = viewModel.orderedSportResultsDictWithDateKeys.0?[dateKey] {
            return dateKeyElements.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportResultCell", for: indexPath) as! SportResultCellVM
        
        if let dateKey = viewModel.orderedSportResultsDictWithDateKeys.1?[indexPath.section],
           let sportsToDisplay = viewModel.orderedSportResultsDictWithDateKeys.0?[dateKey] {
            cell.summary.text = sportsToDisplay[indexPath.row].summary
            cell.time.text = sportsToDisplay[indexPath.row].time
        } else {
            cell.summary.text = "IndexPath Row: \(indexPath.row)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionTitle = viewModel.orderedSportResultsDictWithDateKeys.1?[section] {
            return sectionTitle
        }
        return "No Date"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sportResultCell = sportCellNib.instantiate(withOwner: self, options: nil).last as! SportResultCellVM
        return sportResultCell.height
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension UIApplication {
    // MARK: - Key Window
    var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
        }
    }
}

extension UIWindow {
    //private static let association = ObjectAssociation<UIActivityIndicatorView>()
    private static let association = ObjectAssociation<UIView>()
    
    //var activityIndicator: UIActivityIndicatorView {
    var activityIndicator: UIView {
        set { UIWindow.association[self] = newValue }
        get {
            if let indicator = UIWindow.association[self] {
                return indicator
            } else {
                let indicatorView = UIActivityIndicatorView(style: .large)
                indicatorView.center = self.center
                indicatorView.startAnimating()
                let overlay = UIView(frame: self.frame)
                overlay.backgroundColor = UIColor.black
                overlay.alpha = 0.8
                overlay.addSubview(indicatorView)
                UIWindow.association[self] = overlay
                return UIWindow.association[self]!
            }
        }
    }
    
    // MARK: - Activity Indicator
    public func startIndicatingActivity(_ ignoringEvents: Bool? = true) {
        DispatchQueue.main.async {
            self.addSubview(self.activityIndicator)
            //self.activityIndicator.startAnimating()
        }
    }
    
    public func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
            //self.activityIndicator.stopAnimating()
        }
    }
    
}

public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}


