//
//  AccountMainViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/27.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AccountMainInput {
    var trip: BehaviorRelay<Trip> { get }
    var paybyDay: BehaviorRelay<PayByDays> { get }
    var selectedDay: BehaviorRelay<Int> { get }
}

protocol AccountMainOutput {
    var payByDays: BehaviorRelay<[PayByDays]> { get }
    var pays: BehaviorRelay<[Pay]> { get }
}

protocol AccountMainType {
    var input: AccountMainInput { get }
    var output: AccountMainOutput { get }
}

class AccountMainViewModel: AccountMainInput, AccountMainOutput, AccountMainType {
    var disposeBag = DisposeBag()

    var trip: BehaviorRelay<Trip>
    var selectedDay: BehaviorRelay<Int>
    var paybyDay: BehaviorRelay<PayByDays>

    var payByDays: BehaviorRelay<[PayByDays]>
    var pays: BehaviorRelay<[Pay]>

    var input: AccountMainInput { return self }
    var output: AccountMainOutput { return self }

    init(trip: Trip, day: Int) {
        self.trip = BehaviorRelay(value: trip)
        self.selectedDay = BehaviorRelay(value: day)
        self.paybyDay = BehaviorRelay(value: trip.payByDays[day])
        self.payByDays = BehaviorRelay(value: trip.payByDays)
        self.pays = BehaviorRelay(value: trip.payByDays[day].pays)

        self.selectedDay.map { (day) -> [Pay] in
            return self.trip.value.payByDays[day].pays
        }
        .bind(to: self.pays)
        .disposed(by: disposeBag)

        self.trip.subscribe(onNext: { [weak self] (trip) in
            guard let self = self else { return }
            self.paybyDay.accept(trip.payByDays[self.selectedDay.value])
            self.payByDays.accept(trip.payByDays)
            self.pays.accept(trip.payByDays[self.selectedDay.value].pays)
        }).disposed(by: disposeBag)
    }
}
