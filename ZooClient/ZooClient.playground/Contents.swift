import Foundation

//MARK: - Zoo Keeper
protocol ZooKeeperProtocol {
    var id: Int { get }
    var name: String { get }
    var age: Int { get }
    var animals: [Animals] { get set}
    var salary: Int { get }
    
    init(id: Int, name: String, age: Int)
}

class ZooKeeper: ZooKeeperProtocol {
    var id: Int
    var name: String
    var age: Int
    var animals: [Animals]
    var salary: Int {
        return (animals.count * 1000) + (age * 100)
    }
    
    required init(id: Int, name: String, age: Int){
        self.id = id
        self.name = name
        self.age = age
        self.animals = []
    }
}

//MARK: - Animals
protocol Animals {
    var id: Int { get }
    var name: String { get }
    var waterConsumption: Int { get }
    var zooKeeper : ZooKeeperProtocol? { get set }
    var voice: String { get }
    
    init(id: Int, name: String,waterConsumption: Int)
    
}

class Cat: Animals {
    var id: Int
    var name: String
    var waterConsumption: Int
    var zooKeeper: ZooKeeperProtocol?
    var voice: String {
        return "miyav"
    }
    
    required init(id: Int, name: String, waterConsumption: Int){
        self.id = id
        self.name = name
        self.waterConsumption = waterConsumption
    }
}

class Dog: Animals {
    var id: Int
    var name: String
    var waterConsumption: Int
    var zooKeeper: ZooKeeperProtocol?
    var voice: String {
        return "hav hav"
    }
    
    required init(id: Int, name: String, waterConsumption: Int){
        self.id = id
        self.name = name
        self.waterConsumption = waterConsumption
    }
}

//MARK: - Zoo
protocol ZooProtocol {
   
    var waterLimit: Int { get set}
    var zooKeepers: [ZooKeeperProtocol] { get set}
    var balance: Int { get set }
    var allAnimals: [Animals] { get set}
    var expenses: Int { get set }
    var income: Int  { get set }
    
    // Add animals to zoo
    mutating func addAnimals(animal: Animals, zooKeeper: ZooKeeperProtocol)
    
    // Add zoo keeper to zoo
    mutating func addZooKeeper(zooKeeper: ZooKeeperProtocol)
    
    //Increase water limit to zoo
    mutating func increaseWaterLimit(at: Int)
    
    // Pay zoo keeper's salary
    mutating func paySalary()
    
    // Add money to zoo account
    mutating func addToBalance(at amount : Int)
    
    // Add income to zoo
    mutating func addToIncome(at amount : Int)
    
    // Add expense to zoo
    mutating func addToExpenses(at amount : Int)
    
}

extension Array where Element == Animals {
    
    func getTotalWaterConsumption() -> Int {
        var total = 0
        for animal in self {
            total += animal.waterConsumption
        }
        return total
    }
}

struct Zoo: ZooProtocol {
    var waterLimit: Int
    var balance: Int
    var zooKeepers: [ZooKeeperProtocol] = []
    
    var allAnimals: [Animals] = [] {
        didSet {
            let oldWaterConsumption = oldValue.getTotalWaterConsumption()
            let newWaterConsumption = allAnimals.getTotalWaterConsumption()
            waterLimit -= newWaterConsumption - oldWaterConsumption
        }
    }
    
    var expenses: Int = 0 {
        didSet{
            balance -= expenses - oldValue
        }
    }
    
    var income: Int = 0 {
        didSet{
            balance += income - oldValue
           
        }
    }
    
    init(waterLimit: Int, balance: Int){
        self.waterLimit = waterLimit
        self.balance = balance
    }
}

extension Zoo {
    
    mutating func addAnimals(animal: Animals, zooKeeper: ZooKeeperProtocol) {
        // check does zoo keeper work at zoo
        guard  zooKeepers.contains(where: {$0.name == zooKeeper.name}) else {
            print("\(zooKeeper.name) adl?? bak??c?? bulunamad??.. \(animal.name) hayvanat bah??esine eklenemedi :(")
            return
        }
        
        //check is water limit enough
        guard waterLimit > animal.waterConsumption else {
            print("Su limiti yetersiz")
            return
        }
        
        // check has animal been added before
        if allAnimals.contains(where: {$0.id == animal.id }) {
            print("\(animal.name) daha ??nce eklendi")
            return
        }
        else if zooKeepers.contains(where: {$0.id == zooKeeper.id}) {
            var addedAnimal = animal
            var addedZooKeeper = zooKeeper
            addedAnimal.zooKeeper = zooKeeper
            addedZooKeeper.animals.append(animal)
            allAnimals.append(animal)
            print("\(animal.name) hayvanat bah??esine eklendi. Bak??c??s??: \(zooKeeper.name)")
        }
        
    }
    
    
    mutating func addZooKeeper(zooKeeper: ZooKeeperProtocol) {
        // check does zoo keeper work at zoo
        if zooKeepers.contains(where: {$0.id == zooKeeper.id}){
            print("\(zooKeeper.name) adl?? bak??c?? zaten ekli..")
            
        }
        else {
            zooKeepers.append(zooKeeper)
            print("\(zooKeeper.name) adl?? bak??c?? eklendi..")
        }
    }
    
    mutating func increaseWaterLimit(at limit: Int) {
        waterLimit += limit
    }
    
    
    mutating func paySalary() {
        var total = 0
        for zookeper in zooKeepers {
            total += zookeper.salary
        }
        
        guard total < balance else {
            print("Maa??lar ??denemedi.. B??t??e yetersiz")
            return
        }
        balance -= total
        print("Maa??lar ??dendi. Kalan b??t??e: \(balance)")
    }
    
   
    mutating func addToBalance(at amount : Int) {
        guard amount > 1000 else {
            print("L??tfen 1000???'den b??y??k bir miktar giriniz")
            return
        }
        
        balance += amount
        print("B??t??eye \(amount)??? eklendi. Yeni b??t??e: \(balance)??? ")
    }
    
    mutating func addToIncome(at amount: Int) {
        guard amount > 0 else {
            print("L??tfen 0???'den b??y??k gelir giriniz")
            return
        }
        
        income += amount
        print("Gelirlere \(amount)??? eklendi. Toplam gelir: \(income)???. Yeni b??t??e: \(balance)")
    }
    
    mutating func addToExpenses(at amount: Int) {
        guard amount > 0 else {
            print("L??tfen 0???'den b??y??k bir miktar giriniz")
            return
        }
        
        guard expenses + amount <= balance else {
            print("Giderler b??t??eyi a????yor.. L??tfen b??t??eye g??re harcay??n :)")
            return
        }
        
        expenses += amount
        print("Giderler \(amount)??? artt??.. Toplam gider: \(expenses)???. Yeni b??t??e: \(balance)")
    }
}

var myZoo = Zoo(waterLimit: 100, balance: 20000)

var dog1 = Dog(id: 1, name: "Garip", waterConsumption: 10)
var dog2 = Dog(id: 2, name: "Duman", waterConsumption: 15)
dog1.zooKeeper
var cat1 = Cat(id: 3, name: "??akir", waterConsumption: 5)
var cat2 = Cat(id: 4, name: "Pamuk", waterConsumption: 1000)

var tolga = ZooKeeper(id: 1, name: "Tolga", age: 20)
var kaan = ZooKeeper(id: 2, name: "Ka??an", age: 25)
tolga.animals.count
tolga.salary
myZoo.waterLimit
myZoo.addZooKeeper(zooKeeper: tolga)
myZoo.addZooKeeper(zooKeeper: tolga)
tolga.salary
myZoo.addAnimals(animal: cat1, zooKeeper: tolga)
myZoo.addAnimals(animal: cat2, zooKeeper: tolga)
myZoo.addAnimals(animal: dog1, zooKeeper: tolga)
tolga.salary
myZoo.addAnimals(animal: dog2, zooKeeper: kaan)
myZoo.addZooKeeper(zooKeeper: kaan)
myZoo.addAnimals(animal: dog2, zooKeeper: kaan)
myZoo.addAnimals(animal: dog2, zooKeeper: tolga)
myZoo.addAnimals(animal: cat1, zooKeeper: tolga)
myZoo.waterLimit
dog1.zooKeeper
tolga.animals.count
kaan.animals.count
myZoo.paySalary()
myZoo.addToBalance(at: 5000)
myZoo.balance
myZoo.addToExpenses(at: 40000)
myZoo.addToExpenses(at: 3000)
myZoo.addToIncome(at: 1500)
myZoo.balance
myZoo.paySalary()
