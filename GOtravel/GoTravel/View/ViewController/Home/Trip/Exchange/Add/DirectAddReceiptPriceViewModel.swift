//
//  DirectAddReceiptPriceViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/24.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

protocol DirectAddReceiptPriceViewModelInput {
  var exchangeModel: PublishSubject<ExchangeSelectModel> { get }
  var money: PublishSubject<String> { get }
}
protocol DirectAddReceiptPriceViewModelOutput {
  var calculatedKor: BehaviorRelay<Double> { get }
}
protocol DirectAddReceiptPriceViewModelType {
  var input: DirectAddReceiptPriceViewModelInput { get }
  var output: DirectAddReceiptPriceViewModelOutput { get }
}
class DirectAddReceiptPriceViewModel: DirectAddReceiptPriceViewModelInput, DirectAddReceiptPriceViewModelOutput, DirectAddReceiptPriceViewModelType {
  private var disposeBag = DisposeBag()
  var exchangeModel: PublishSubject<ExchangeSelectModel>
  
  var money: PublishSubject<String>
    
  var calculatedKor: BehaviorRelay<Double>
  
  var input: DirectAddReceiptPriceViewModelInput { return self }
  
  var output: DirectAddReceiptPriceViewModelOutput { return self }
  
  
  init() {
    self.exchangeModel = PublishSubject()
    self.calculatedKor = BehaviorRelay(value: 0)
    self.money = PublishSubject()
    
    Observable.combineLatest(self.exchangeModel, self.money)
      .flatMapLatest { (model, money) -> Observable<Double> in
        let double = money.toDouble() ?? 0.0
        
        if model.foreignName?.contains("(100)") ?? false {
          return Observable.just((double / 100) * model.calculateDouble)
        } else {
          return Observable.just(double * model.calculateDouble)
        }
    }.bind(to: self.calculatedKor)
    .disposed(by: disposeBag)
  }
  
  
  //  if textField.text?.count != 0 {
  //    if (textField.text?.contains("."))!{
  //      if let range = textField.text!.range(of: ".") {
  //        let dotBefore = textField.text![..<range.lowerBound]
  //        let dotAfter = textField.text![range.lowerBound...] // or str[str.startIndex..<range.lowerBound]
  //
  //        let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
  //        calculatorKoreaMoney(textFieldDouble: Double(textField.text!) ?? 0, selectedForeognMoney: self.selectForeignMoneyDouble ?? 0)
  //
  //        let numberFormatter = NumberFormatter()
  //        numberFormatter.numberStyle = NumberFormatter.Style.decimal
  //        var formattedNumber = numberFormatter.string(from: NSNumber(value:(subtractionDot.toDouble())!))
  //
  //        formattedNumber?.append(String(dotAfter))
  //        textField.text = formattedNumber
  //
  //      }
  //    }else{
  //      let subtractionDot = textField.text?.replacingOccurrences(of: ",", with: "")
  //      calculatorKoreaMoney(textFieldDouble: Double(subtractionDot!) ?? 0, selectedForeognMoney: self.selectForeignMoneyDouble ?? 0)
  //      let numberFormatter = NumberFormatter()
  //      numberFormatter.numberStyle = NumberFormatter.Style.decimal
  //      let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(subtractionDot!)!))
  //
  //      textField.text = formattedNumber
  //    }
  //  }
  //
}
