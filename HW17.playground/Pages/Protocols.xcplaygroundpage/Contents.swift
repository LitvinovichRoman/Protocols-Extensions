//: [Previous](@previous)

import Foundation

/*
                                             ПРОТОКОЛЫ

                                         ТРЕБУЕМЫЕ СВОЙСТВА

 В протоколе может содержаться требование реализации одного или нескольких свойств
 (в том числе свойств типа, указываемых с помощью ключевого слова #static).
 При этом для каждого свойства в протоколе указывается:

 название;
 тип данных;
 требования доступности и изменяемости.
 */

protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

/*
  Протокол SomeProtocol имеет требования реализации двух свойств.
   Таким образом, если тип данных подпишется на протокол SomeProtocol,
   то в нем потребуется реализовать данные свойства, при этом:

 Первое свойство должно иметь название mustBeSettable,
 Второе doesNotNeedToBeSettable.

  Тип данных обоих свойств - Int.
  Свойство mustBeSettable должно быть доступно как для чтения так и для изменения, то есть в нем должны быть геттер и сеттер.
  Свойство doesNotNeedToBeSettable, в свою очередь, должно иметь как минимум геттер.
  Требования доступности и изменяемости определяются с помощью конструкций { get } и { get set }.
   В первом случае у свойства должен быть как минимум геттер, а во втором — и геттер и сеттер.
   В случае, если свойству определено требование { get set }, то оно не может быть вычисляемым «только для чтения» или константой.

  Протокол определяет минимальные требования к типу, то есть тип данных обязан реализовать все, что описано в протоколе,
   но он может не ограничиваться этим набором. Так, для свойства doesNotNeedToBeSettable
   может быть реализован не только геттер, но и сеттер (в протоколе содержится требование реализации геттера).
 */

struct SomeStruct: SomeProtocol {
    var mustBeSettable: Int
    let doesNotNeedToBeSettable: Int
    // дополнительный метод, не описанный в протоколе
    func getSum() -> Int {
        return self.mustBeSettable + self.doesNotNeedToBeSettable
    }
}

/*
 Тип данных SomeStruct полностью соответствует описанному ранее протоколу SomeProtocol,
 но при этом содержит дополнительный метод getSum(), который возвращает сумму свойств.

 Для указания в протоколе требования к реализации свойства типа необходимо использовать модификатор #static
 
 Структура AnotherStruct принимает к реализации два протокола: SomeProtocol и AnotherProtocol.
 Это значит, что в ней должны быть реализованы все элементы обоих протоколов.
 */

protocol AnotherProtocol {
    static var someTypeProperty: Int { get }
}

struct AnotherStruct: SomeProtocol, AnotherProtocol {
    var mustBeSettable: Int
    let doesNotNeedToBeSettable: Int
    static var someTypeProperty: Int = 3
    func getSum() -> Int {
        return self.mustBeSettable
            + self.doesNotNeedToBeSettable
            + AnotherStruct.someTypeProperty
    }
}

/*
                                                  ТРЕБУЕМЫЕ МЕТОДЫ

 Помимо свойств, протокол может содержать требования к реализации одного или нескольких методов.
 Для требования реализации метода типа – модификатор #static
 Для изменяющего метода — #mutating

 Если вы указали ключевое слово mutating перед требованием метода, то указывать его при реализации метода в классе уже не нужно.
 Данное ключевое слово требуется только при реализации структуры.
 */

protocol RandomNumberGenerator {
    var randomCollection: [Int] { get set }
    func getRandomNumber() -> Int
    mutating func setNewRandomCollection(newValue: [Int])
}

/*
 Протокол RandomNumberGenerator содержит требования реализации свойства randomCollection и двух методов:
 - getRandomNumber()
 - setNewRandomCollection (newValue: )

 При реализации методов в объектном типе необходимо в точности соблюдать все требования протокола:
 - имя метода
 - наличие или отсутствие входных аргументов
 - тип возвращаемого значения
 - модификатор
 
 
 */

struct RandomGenerator: RandomNumberGenerator {
    var randomCollection: [Int] = [1, 2, 3, 4, 5]
    func getRandomNumber() -> Int {
        return self.randomCollection.randomElement() ?? 0
    }

    mutating func setNewRandomCollection(newValue: [Int]) {
        self.randomCollection = newValue
    }
}

class RandomGeneratorClass: RandomNumberGenerator {
    var randomCollection: [Int] = [1, 2, 3, 4, 5]
    func getRandomNumber() -> Int {
        if let randomElement = randomCollection.randomElement() {
            return randomElement
        }
        return 0
    }

    // не используется модификатор mutating
    func setNewRandomCollection(newValue: [Int]) {
        self.randomCollection = newValue
    }
}
// Оба типа идентичны в плане функциональности, но имеют некоторые описанные выше различия в реализации требований протокола.


/*
                                             ТРЕБУЕМЫЕ ИНИЦИАЛИЗАТОРЫ

 Протокол может предъявлять требования к реализации инициализаторов.
 При этом в классах можно реализовать назначенные designated или вспомогательные convenience инициализаторы.
 В любом случае перед объявлением инициализатора в классе необходимо указывать модификатор #required.
 Это гарантирует, что вы реализуете указанный инициализатор во всех подклассах данного класса.

 Обязательный #required инициализатор – это инициализатор, который обязательно должен быть
 определен во всех подклассах данного класса,
 required необходимо указывать перед каждой реализацией данного инициализатора в подклассах,
 чтобы последующие подклассы также реализовывали этот инициализатор.

    required init(параметры) {
        // тело инициализатора
    }
 
 
 Нет нужды обозначать реализацию инициализаторов протокола модификатором required в классах, которые имеют модификатор final.
 Реализуем протокол, содержащий требования к реализации инициализатора, и класс, выполняющий требования данного протокола

 protocol Named {
     init(name: String)
 }

 class Person: Named {
     var name: String
     required init(name: String) {
         self.name = name
     }
 }

 
 
 Протокол в качестве типа данных
 
 Протокол может выступать в качестве типа данных, то есть в определенных случаях вы можете писать не имя конкретного типа,
 а имя протокола, которому должно соответствовать значение.

 Протокол, указывающий на множество типов
 Протокол может выступать в качестве указателя на множество типов данных.
 С его помощью определяется требование к значению: оно должно иметь тип данных, соответствующий указанному протоколу.
 С этим подходом мы уже встречались, когда название протокола (например, Hashable) указывало на целую категорию типов.
 */

func getHash<T: Hashable>(of value: T) -> Int {
    return value.hashValue
}

/*
 Приведенный код, называется универсальным шаблоном (generic). Функция getHash может принять любое значение типа T,
 где тип T должен соответствовать протоколу Hashable. Данный протокол указывает на целое множество типов данных.
 Вы можете передать в нее значение любого хешируемого типа и получить значение свойства hashValue
 */

getHash(of: 5)
getHash(of: "Swift")

/*
        ПРОТОКОЛЫ И ОПЕРАТОРЫ  as? | as!
 Операторы as? и as! – эти операторы производят попытку приведения указанного значения к указанному  типу данных.

 У нас есть коллекция, которая может хранить элементы произвольных типов данных.
 При этом вы помещаете в нее значения как фундаментальных, так и собственных типов
 */

protocol HasValue {
    var value: Int { get set }
}

class ClassWithValue: HasValue {
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

struct StructWithValue: HasValue {
    var value: Int
}

// коллекция элементов
let objects: [Any] = [
    2,
    StructWithValue(value: 3),
    true,
    ClassWithValue(value: 6),
    "Word"
]

/*
 Типы данных StructWithValue и ClassWithValue подписаны на протокол HasValue.
 Значения этих типов вперемешку со значениями других типов помещены в коллекцию objects.
 Теперь вам необходимо перебрать все элементы коллекции, выбрать из них те, что соответствуют протоколу HasValue,
 и вывести для них на консоль значение свойства value. Эту задачу позволит нам выполнить оператор as?
 */

for object in objects {
    if let elementWithValue = object as? HasValue {
        print("Значение \(elementWithValue.value)")
    }
}

/*
 Оператор as? пытается преобразовать значение к типу данных HasValue (протокол выступает в качестве типа).
 В случае успеха он выводит значение соответствующего свойства на консоль, а в случае неудачи возвращает nil.

 
 
                                          ПРОТОКОЛЫ И ОПЕРАТОР is

 Вы можете использовать протоколы совместно с оператором is для проверки соответствия типа данных значения этому протоколу
 */

for object in objects {
    print(object is HasValue)
}

/*
 Если проверяемый элемент соответствует протоколу, то при проверке соответствия возвращается значение true, если нет, то false.

        НАСЛЕДОВАНИЕ ПРОТОКОЛОВ

 Протокол может наследовать один или более других протоколов.
 При этом в него могут быть добавлены новые требования поверх наследуемых - тогда тип, принявший протокол к реализации,
 будет вынужден выполнить требования всех протоколов в иерархии. При наследовании протоколов используется тот же синтаксис,
 что и при наследовании классов.
 */

protocol GeometricFigureWithXAxis {
    var x: Int { get set }
}

protocol GeometricFigureWithYAxis {
    var y: Int { get set }
}

protocol GeometricFigureTwoAxis: GeometricFigureWithXAxis,
    GeometricFigureWithYAxis
{
    var distanceFromCenter: Float { get }
}

struct Figure2D: GeometricFigureTwoAxis {
    var x: Int = 0
    var y: Int = 0
    var distanceFromCenter: Float {
        let xPow = pow(Double(self.x), 2)
        let yPow = pow(Double(self.y), 2)
        let length = sqrt(xPow + yPow)
        return Float(length)
    }
}

/*
 Протоколы GeometricFigureWithXAxis и GeometricFigureWithYAxis определяют требование на наличие свойства,
 указывающего на координату объекта на определенной оси. В свою очередь,
 протокол GeometricFigureTwoAxis объединяет требования двух вышеназванных протоколов, а также вводит дополнительное свойство.
 В результате структура Figure2D, принимающая к реализации протокол GeometricFigureTwoAxis,
 должна иметь все свойства, описанные во всех трех протоколах.

                                                  КЛАССОВЫЕ ПРОТОКОЛЫ

 Вы можете ограничить применение протокола исключительно на классы, запретив его использование для структур и перечислений.
 Для этого после имени протокола через двоеточие необходимо указать ключевое слово class,
 после которого могут быть определены родительские протоколы.
 */

protocol SuperProtocol {}

protocol SubProtocol: AnyObject, SuperProtocol {} // class устарел лучше использовать AnyObject

class ClassWithProtocol: SubProtocol {}

// struct StructWithProtocol: SubProtocol {} // ошибка

/*
                                                       КОМПОЗИЦИЯ

 В случаях, когда протокол выступает в качестве указателя на множество типов данных, бывает удобнее требовать,
 чтобы тип данных используемого значения соответствовал не одному, а нескольким протоколам.
 В этом случае можно пойти двумя путями:
 - Создать протокол, который подписывается на два родительских протокола, и использовать его в качестве указателя на тип данных.
 - Использовать композицию протоколов, то есть комбинацию нескольких протоколов. Протокол1 & Протокол2
 
 Для композиции необходимо указать имена входящих в нее протоколов, разделив их оператором #& #амперсанд
 */

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

class Person: Named, Aged {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

func wishHappyBirthday(celebrator: Named & Aged) {
    print("С Днем рождения, \(celebrator.name)! Тебе уже \(celebrator.age)!")
}

let birthdayPerson = Person(name: "Артём", age: 28)
wishHappyBirthday(celebrator: birthdayPerson)

//: [Next](@next)
