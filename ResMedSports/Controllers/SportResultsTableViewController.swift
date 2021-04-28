//
//  SportResultsTableViewController.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/25/21.
//

import UIKit
import Combine

class SportResultsTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var getResultsBtn: UIBarButtonItem!
    var subscriptions = Set<AnyCancellable>()
    let sportCellNib = UINib(nibName: "SportResultCell", bundle: nil)
    let viewModel = SportResultsVM()
    
    lazy var alertController: (String, [UIAlertAction]) -> UIAlertController = {
        let alert = UIAlertController(title: "Sport News", message: "", preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let messageText = NSMutableAttributedString(
            string: $0,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
                NSAttributedString.Key.foregroundColor : UIColor.systemGreen
            ]
        )
        
        alert.setValue(messageText, forKey: "attributedMessage")
        
        if $1.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            for action in $1 {
                alert.addAction(action)
            }
        }
        return alert
    }
    
    // MARK: - Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UIApplication.isDeviceJailBrokenCanOpenUrl() {
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                fatalError()
            }
            present(alertController("It appears that your device is jailbroken, you may not use this app on a jailbroken device.", [action]), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sport News"
        
        tableView.register(sportCellNib, forCellReuseIdentifier: "SportResultCell")
        
        // set up pipeline when sport results are received
        viewModel.orderedSportResultsDictWithDateKeys
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.tableView.reloadData()
                UIApplication.shared.keyWindow?.stopIndicatingActivity()
                self.getResultsBtn.isEnabled = true
            })
            .store(in: &subscriptions)
        
        // created to handle error if API error occurs without shutting down results subscriber
        viewModel.apiErrorOccured
            .receive(on: DispatchQueue.main)
            .sink { (error) in
                self.present(self.alertController(error.localizedDescription, []), animated: true)
                UIApplication.shared.keyWindow?.stopIndicatingActivity()
                self.getResultsBtn.isEnabled = true
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Internal
    
    /// When user taps 'Get Results', an HTTP request is fired off to retrieve sport results
    /// - Parameter sender: BarButtonItem
    @IBAction func getSportResults(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        UIApplication.shared.keyWindow?.startIndicatingActivity()
        viewModel.getGroupedAndOrderedSportResults()
    }
    
}

extension SportResultsTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let count = viewModel.orderedSportResultsDictWithDateKeys.value.0?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dateKey = viewModel.orderedSportResultsDictWithDateKeys.value.1?[section],
           let dateKeyElements = viewModel.orderedSportResultsDictWithDateKeys.value.0?[dateKey] {
            return dateKeyElements.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportResultCell", for: indexPath) as! SportResultCellVM
        
        if let dateKey = viewModel.orderedSportResultsDictWithDateKeys.value.1?[indexPath.section],
           let sportsToDisplay = viewModel.orderedSportResultsDictWithDateKeys.value.0?[dateKey] {
            cell.summary.text = sportsToDisplay[indexPath.row].summary
            cell.time.text = sportsToDisplay[indexPath.row].time
        } else {
            cell.summary.text = "IndexPath Row: \(indexPath.row)"
        }
        return UIView.animateCellWithMoveAndFade(cell: cell, tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionTitle = viewModel.orderedSportResultsDictWithDateKeys.value.1?[section] {
            return sectionTitle
        }
        return "No Date"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sportResultCell = sportCellNib.instantiate(withOwner: self, options: nil).last as! SportResultCellVM
        return sportResultCell.height
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let dateKey = viewModel.orderedSportResultsDictWithDateKeys.value.1?[indexPath.section],
           let sportsToDisplay = viewModel.orderedSportResultsDictWithDateKeys.value.0?[dateKey] {
            
            let sportResult = sportsToDisplay[indexPath.row]
            var json = ""
            
            do {
                json = try JsonEncoderFactory.getJsonForCommonSport(commonSport: sportResult)
            } catch {
                json = error.localizedDescription
            }
            
            present(alertController(json, []), animated: true)
        }
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

struct JsonEncoderFactory {
    
    /// Takes a common sport result and converts it to its concrete implementation
    /// - Parameter commonSport: general sport result
    /// - Throws: EncodingError
    /// - Returns: The JSON representation of the sport result
    static func getJsonForCommonSport(commonSport: CommonSport) throws -> String {
        let sportType = type(of: commonSport)
        let encoder = JSONEncoder()
        var data = Data()
        switch sportType {
        case is F1.Type:
            data = try encoder.encode(sport: commonSport as! F1)
        case is Nba.Type:
            data = try encoder.encode(sport: commonSport as! Nba)
        case is Tennis.Type:
            data = try encoder.encode(sport: commonSport as! Tennis)
        case is Baseball.Type:
            data = try encoder.encode(sport: commonSport as! Baseball)
        default:
            throw EncodingError.invalidValue("Error encoding \(sportType)", .init(codingPath: [], debugDescription: "Encoding error for type \(sportType)"))
        }
        return String(bytes: data, encoding: .utf8) ?? "Invalid sport \(sportType) - no JSON to encode"
    }
}




