//
//  Enum_exchange.swift
//  GOtravel
//
//  Created by OOPSLA on 25/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation

struct ExchangeCountry {
  let country: String
  let korName: String
}
let ExchangeCountryDictionary : [String: ExchangeCountry] =
  [
    "KRW": ExchangeCountry(country: "대한민국", korName: "원"),
    "AED": ExchangeCountry(country: "아랍에미레이트", korName: "디르함"),
    "ATS": ExchangeCountry(country: "오스트리아", korName: "실링"),
    "BEF": ExchangeCountry(country: "벨기에", korName: "프랑"),
    "BHD": ExchangeCountry(country: "바레인", korName: "디나르"),
    "CAD": ExchangeCountry(country: "캐나다", korName: "달러"),
    "CHF": ExchangeCountry(country: "스위스", korName: "프랑"),
    "CNH": ExchangeCountry(country: "중국", korName: "위안화"),
    "DEM": ExchangeCountry(country: "독일", korName: "마르크"),
    "DKK": ExchangeCountry(country: "덴마아크", korName: "크로네"),
    "ESP": ExchangeCountry(country: "스페인", korName: "페세타"),
    "EUR": ExchangeCountry(country: "유로", korName: "유로"),
    "FIM": ExchangeCountry(country: "필란드", korName: "마르카"),
    "FPF": ExchangeCountry(country: "프랑스", korName: "프랑") ,
    "GBP": ExchangeCountry(country: "영국", korName: "파운드") ,
    "HKD": ExchangeCountry(country: "홍콩", korName: "달러") ,
    "ITL":ExchangeCountry(country: "이태리", korName: "리라"),
    "JPY(100)": ExchangeCountry(country: "일본", korName: "엔"),
    "KWD": ExchangeCountry(country: "쿠웨이트", korName: "디나르") ,
    "MYR": ExchangeCountry(country: "말레이지아", korName: "링기트"),
    "NLG": ExchangeCountry(country: "네덜란드", korName: "길더"),
    "NOK": ExchangeCountry(country: "노르웨르", korName: "크로네"),
    "NZD": ExchangeCountry(country: "뉴질랜드", korName: "달러"),
    "SAR": ExchangeCountry(country: "사우디", korName: "리얄"),
    "SEK": ExchangeCountry(country: "스웨덴", korName: "크로나"),
    "SGD": ExchangeCountry(country: "싱카포르", korName: "달러"),
    "THB": ExchangeCountry(country: "태국", korName: "바트"),
    "USD": ExchangeCountry(country: "미국", korName: "달러") ,
    "XOF": ExchangeCountry(country: "씨에프에이", korName: "프랑"),
    "AUD": ExchangeCountry(country: "호주", korName: "달러"),
    "IDR(100)": ExchangeCountry(country: "인도네시아", korName: "루피아")
    //    "인도네시아_루피아" :  "IDR",
    
]
struct exchange_country {
  static var 대한민국_원 = "KRW"
  static var 아랍에미레이트_디르함 = "AED"
  static var 오스트리아_실링 = "ATS"
  static var 벨기에_프랑 = "BEF"
  static var 바레인_디나르 = "BHD"
  static var 캐나다_달러 = "CAD"
  static var 스위스_프랑 = "CHF"
  
  static var 중국_위안화 = "CNH"
  static var 독일_마르크 = "DEM"
  static var 덴마아크_크로네 = "DKK"
  static var 스페인_페세타 = "ESP"
  static var 유로 = "EUR"
  static var 필란드_마르카 = "FIM"
  static var 프랑스_프랑 = "FPF"
  static var 영국_파운드 = "GBP"
  static var 홍콩_달러 = "HKD"
  static var 인도네시아_루피아 = "IDR"
  static var 이태리_리라 = "ITL"
  static var 일본_엔 = "JPY"
  static var 쿠웨이트_디나르 = "KWD"
  static var 말레이지아_링기트 = "MYR"
  static var 네덜란드_길더 = "NLG"
  static var 노르웨르_크로네 = "NOK"
  static var 뉴질랜드_달러 = "NZD"
  static var 사우디_리얄 = "SAR"
  static var 스웨덴_크로나 = "SEK"
  static var 싱카포르_달러 = "SGD"
  static var 태국_바트 = "THB"
  static var 미국_달러 = "USD"
  static var 씨에프에이_프랑 = "XOF"
}
