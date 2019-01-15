/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Table view controller used to display suggested search criteria.
*/

import UIKit
import MapKit


class SuggestionsTableTableViewController: UITableViewController {
    
    let searchCompleter = MKLocalSearchCompleter()
    var completerResults: [MKLocalSearchCompletion]?
    var subResults : [MKLocalSearchCompletion] = []

    convenience init() {
        self.init(style: .plain)
        searchCompleter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SuggestedCompletionTableViewCell.self, forCellReuseIdentifier: SuggestedCompletionTableViewCell.reuseID)
    }
}

extension SuggestionsTableTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("1")
        return completerResults?.count ?? 0
    }

    /// - Tag: HighlightFragment
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("2")

        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedCompletionTableViewCell.reuseID, for: indexPath)

        if let suggestion = completerResults?[indexPath.row] {
            // Each suggestion is a MKLocalSearchCompletion with a title, subtitle, and ranges describing what part of the title
            // and subtitle matched the current query string. The ranges can be used to apply helpful highlighting of the text in
            // the completion suggestion that matches the current query fragment.
            cell.textLabel?.attributedText = createHighlightedString(text: suggestion.title, rangeValues: suggestion.titleHighlightRanges)
            cell.detailTextLabel?.attributedText = createHighlightedString(text: suggestion.subtitle, rangeValues: suggestion.subtitleHighlightRanges)
        }

        return cell
    }
    
    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) ]
        let highlightedString = NSMutableAttributedString(string: text)
        
        // Each `NSValue` wraps an `NSRange` that can be used as a style attribute's range with `NSAttributedString`.
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { (range) in
            highlightedString.addAttributes(attributes, range: range)
        }
        
        return highlightedString
    }
}

extension SuggestionsTableTableViewController: MKLocalSearchCompleterDelegate {
    
    /// - Tag: QueryResults
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // As the user types, new completion suggestions are continuously returned to this method.
        // Overwrite the existing results, and then refresh the UI with the new results.
        subResults.removeAll()
        DispatchQueue.main.async {
            for i in completer.results{
                if i.subtitle.count == 0{
                    print("\(i.title)  \(i.subtitle)")
                    self.subResults.append(i)
                }
            }
            self.completerResults = self.subResults
            self.tableView.reloadData()

        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle any errors returned from MKLocalSearchCompleter.
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription)")
        }
    }
}

extension SuggestionsTableTableViewController: UISearchResultsUpdating {

    /// - Tag: UpdateQuery
    func updateSearchResults(for searchController: UISearchController) {
        // Ask `MKLocalSearchCompleter` for new completion suggestions based on the change in the text entered in `UISearchBar`.
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}

private class SuggestedCompletionTableViewCell: UITableViewCell {
    
    static let reuseID = "SuggestedCompletionTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
