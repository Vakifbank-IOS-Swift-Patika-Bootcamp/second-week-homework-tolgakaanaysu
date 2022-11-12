import Foundation

//TODO:
/*
 -İngizlice kontrolü
 -Double .2f formatlanacak
 -Get set kontorlü
 */


//MARK: - EMPLOYEE

//Employee level and salary coefficient
enum DeveloperType: Double {
    case intern = 0.5
    case junior = 1
    case mid = 1.5
    case senior = 2.2
}

//Marital status of employee
enum MaritalStatus: String {
    case married = "Evli"
    case single = "Bekar"
}

protocol EmployeeProtocol {
    var name: String { get }
    var age: Int { get }
    var maritalStatus: MaritalStatus { get }
    var developerType: DeveloperType { get }
    var salary: Double { get }
    
    init(name: String, age: Int, maritalStatus: MaritalStatus, developerType: DeveloperType)
    
}

class Employee: EmployeeProtocol {
    var name: String
    var age: Int
    var maritalStatus: MaritalStatus
    var developerType: DeveloperType
    var salary: Double {
        return Double(age) * developerType.rawValue * 623
    }
    
    required init(name: String, age: Int, maritalStatus: MaritalStatus, developerType: DeveloperType) {
        self.name = name
        self.age = age
        self.maritalStatus = maritalStatus
        self.developerType = developerType
    }
}
import Foundation

//MARK: - Company
protocol CompanyProtocol {
    var name: String  { get }
    var foundationYear: Int { get }
    var addres: String? { get }
    
}

protocol CompanyAccountingManager {
    var employees: [EmployeeProtocol] { get set }
    var balance: Double { get set }
    var totalSalary: Double { get }
    
    // Add employee to
    func addEmployeeToCompany(_ employee: EmployeeProtocol)
    
    // Add money to company account
    func addToBalance(at amount : Double)
    
    // Withdraw money from company account
    func withdrawFromBalance(at amount: Double)
    
    // Pay employees's salary
    func paySalaries()
    
    // Total salary pay to employees
    func getTotalSalary() -> Double
}

class Company: CompanyProtocol  {
    var name: String
    var foundationYear: Int
    var addres: String?
    var balance: Double
    var employees: [EmployeeProtocol]
    var totalSalary: Double {
        return getTotalSalary()
    }
    
    init(name: String, foundationYear: Int, addres: String?, balance: Double, employees: [EmployeeProtocol]) {
        self.name = name
        self.foundationYear = foundationYear
        self.addres = addres
        self.balance = balance
        self.employees = employees
    }
    
    convenience init(name: String, foundationYear: Int){
        self.init(name: name, foundationYear: foundationYear, addres: nil, balance: 0.0, employees: [])
    }
    
    convenience init(name: String, foundationYear: Int, balance: Double){
        self.init(name: name, foundationYear: foundationYear,addres: nil, balance: balance, employees: [])
    }
    
    convenience init(name: String,foundationYear: Int, employess: [EmployeeProtocol]) {
        self.init(name: name, foundationYear: foundationYear,addres: nil, balance: 0.0, employees: employess)
    }
}

extension Company: CompanyAccountingManager {
    
    func addEmployeeToCompany(_ employee: EmployeeProtocol) {
        employees.append(employee)
        print("\(employee.name) şirkette çalışmaya başladı..")
    }
    
    func  getTotalSalary() -> Double {
        var total = 0.0
        for employee in employees {
            total += employee.salary
        }
        return total
    }
    
    func paySalaries(){
        if totalSalary < balance {
            balance -= totalSalary
            print("Maaşlar ödendi... Kalan para: \(balance)₺")
        } else {
            print("Bütçe yetersiz.. Maaşlar ödenemedi")
        }
    }
    
    func addToBalance(at amount : Double) {
        guard amount > 1000 else {
            print("Lütfen 1000₺'den büyük bir miktar giriniz")
            return
        }
        
        balance += amount
        print("Bütçeye \(amount)₺ eklendi. Yeni bütçe: \(balance)₺ ")
    }
    
    func withdrawFromBalance(at amount: Double){
        guard amount > 50 else {
            print("Lütfen 50₺'den büyük bir miktar giriniz")
            return
        }
        guard amount > balance else {
            print("Yetersiz bakiye..")
            return
        }
        
        balance -= amount
        print("Bütçe \(amount)₺ azaldı")
    }
}



let d1 = Employee(name: "Tolga", age: 33, maritalStatus: .single, developerType: .junior)
let d2 = Employee(name: "Kağan" , age: 20 , maritalStatus: .married, developerType: .mid)

var myCompany = Company(name: "Jesus Yazılım", foundationYear: 2022)

myCompany.addToBalance(at: 2)
myCompany.addEmployeeToCompany(d1)
print(d1.salary)
d1.age = 21
print(d1.salary)
d1.developerType = .senior
print(d1.salary)



myCompany.paySalaries()


