import Foundation

//MARK: - EMPLOYEE

//Employee level and salary coefficient
enum DeveloperType: Int {
    case intern = 1
    case junior = 2
    case mid = 3
    case senior = 5
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
    var developerType: DeveloperType? { get set }
    var salary: Int? { get }
    var company: String? { get set }
    
    
    
}

class Employee: EmployeeProtocol {
    var name: String
    var age: Int
    var maritalStatus: MaritalStatus
    var developerType: DeveloperType?
    var company: String? = nil
    var salary: Int? {
        guard let developerType else { return nil }
        return Int(age) * developerType.rawValue * 50
    }
   
    
    init(name: String, age: Int, maritalStatus: MaritalStatus) {
        self.name = name
        self.age = age
        self.maritalStatus = maritalStatus
        
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
    var balance: Int { get set }
    var totalSalary: Int { get }
    
    // Add employee to company
    mutating func addEmployeeToCompany(_ employee: Employee, developerType: DeveloperType)
    
    // Add money to company account
    mutating func addToBalance(at amount : Int)
    
    // Withdraw money from company account
    mutating func withdrawFromBalance(at amount: Int)
    
    // Pay employees's salary
    mutating func paySalaries()
    
    // Total salary pay to employees
    func getTotalSalary() -> Int
}

struct Company: CompanyProtocol  {
    var name: String
    let foundationYear: Int
    var addres: String?
    var balance: Int
    var employees: [EmployeeProtocol]
    var totalSalary: Int {
        return getTotalSalary()
    }
    
    init(name: String, foundationYear: Int, addres: String?, balance: Int) {
        self.name = name
        self.foundationYear = foundationYear
        self.addres = addres
        self.balance = balance
        self.employees = []
        print("\(self.name) adlı şirket kuruldu.. Şirket bütçesi: \(self.balance)")
       
    }
    
    
    
}

extension Company: CompanyAccountingManager {
    
    mutating func addEmployeeToCompany(_ employee: Employee, developerType: DeveloperType) {
        employees.append(employee)
        var addedEmployee = employee
        addedEmployee.developerType = developerType
        addedEmployee.company = self.name
        print("\(employee.name) şirkette \(developerType) olarak  çalışmaya başladı.. Maaşı: \(employee.salary!)₺")
    }
    
    func  getTotalSalary() -> Int {
        var total = 0
        for employee in employees {
            total += employee.salary!
        }
        return total
    }
    
    mutating func paySalaries(){
        if totalSalary < balance {
            balance -= totalSalary
            print("Maaşlar ödendi... Kalan para: \(balance)₺")
        } else {
            print("Bütçe yetersiz.. Maaşlar ödenemedi")
        }
    }
    
    mutating func addToBalance(at amount : Int) {
        guard amount > 1000 else {
            print("Lütfen 1000₺'den büyük bir miktar giriniz")
            return
        }
        
        balance += amount
        print("Bütçeye \(amount)₺ eklendi. Yeni bütçe: \(balance)₺ ")
    }
    
    mutating func withdrawFromBalance(at amount: Int){
        guard amount > 50 else {
            print("Lütfen 50₺'den büyük bir miktar giriniz")
            return
        }
        guard amount < balance else {
            print("Yetersiz bakiye..")
            return
        }
        
        balance -= amount
        print("Bütçe \(amount)₺ azaldı")
    }
}


//Create Company
var myCompany = Company(name: "Invented Studios", foundationYear: 2022, addres: nil, balance: 12000)

//Create Employee
var tolga = Employee(name: "Tolga", age: 25, maritalStatus: .single)
var kaan = Employee(name: "Kağan", age: 33, maritalStatus: .single)

//Check employee's company, developer type and salary before added to company
tolga.salary
tolga.company
tolga.developerType

//Check company total salary before added employee
myCompany.totalSalary

//Add employee to company
myCompany.addEmployeeToCompany(tolga, developerType: .junior)

//Check employee's company, developer type and salary after added to company
tolga.developerType
tolga.company
tolga.salary

//Check company total salary after added employee
myCompany.totalSalary

myCompany.addEmployeeToCompany(kaan, developerType: .senior)
kaan.salary
//Check company total salary after added employee
myCompany.totalSalary

//Check company balance
myCompany.balance

// Add money to company account
myCompany.addToBalance(at: 25000)

//Check company balance
myCompany.balance

// Pay employees's salary
myCompany.paySalaries()

//Check company balance
myCompany.balance

// Withdraw money from company account
myCompany.withdrawFromBalance(at: 10000)

myCompany.balance
