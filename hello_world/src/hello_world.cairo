use debug::PrintTrait;
use array::ArrayTrait;

// fn main() {
//     let x = 5;
//     let x = x + 1;
//     {
//         let x = x * 2;
//         'Inner scope x value is:'.print();
//         x.print()
//     }
//     'Outer scope x value is:'.print();
//     x.print();
// }

// fn sub_u8s(x: u8, y: u8) -> u8 {
//     x - y
// }

// fn main() {
//     let x:u8 = sub_u8s(1, 3);
//     x.print();
// }

// fn main() {
//     // addition
//     let sum = 5_u128 + 10_u128;

//     // subtraction
//     let difference = 95_u128 - 4_u128;

//     sum.print();
//     difference.print();
//     // multiplication
//     let product = 4_u128 * 30_u128;

//     // division
//     let quotient = 56_u128 / 32_u128; //result is 1
//     let quotient = 64_u128 / 32_u128; //result is 2

//     // remainder
//     let remainder = 43_u128 % 5_u128; // result is 3
// }


// Generate the n-th Fibonacci number.

// fn main() {
//     let y = fibonacci(5);
//     y.print();

// }
// fn fibonacci(n: u64) -> u64{
//     if n <= 0{
//          0
//     }else if n == 1{
//          1
//     }else{

//          fibonacci(n - 1) + fibonacci(n - 2)
//     }
// }

// Compute the factorial of a number n.

// fn main() {
//     let fact  = factorial(4);
//     'Factorial of 4 is: '.print();
//     fact.print();
// }

// fn factorial(x:u64) -> u64{
//     if x == 0 || x == 1 {
//         1
//     }
//     else{
//         x * factorial(x - 1)
//     }
// }

// //Declaration of Array Types in Cairo
// fn main(){
//     let mut a = ArrayTrait::<u128>::new();
//     let mut arr:Array<u128> = ArrayTrait::new();
//     a.append(10);
//     a.append(1);
//     a.append(2);

//     let first = *a.at(0);
//     let second = *a.at(1);
//     // let first_value = a.pop_front().unwrap();
//     first.print(); // print '10'
//     second.print(); // print '1'
//     if arr.is_empty() {
//         'Array is empty'.print();
//     } else {
//         'Array is not empty'.print();
//     }
//     arr.append(10);
//     arr.append(1);

//     let mut length = arr.len();
//     'Length of Array'.print();
//     length.print();
//     arr.pop_front();
//     length= arr.len();
//     length.print(); 

// }

// Declaration of Dictionaries 

fn main(){
    let mut balances:Felt252Dict<u64>  = Default::default();
    balances.insert('Alex', 100);
    balances.insert('Bob', 100);
    balances.insert('Cat', 100);

    let alex_balance = balances.get('Alex');
    assert(alex_balance == 100, 'Balance is not 100');
    alex_balance.print();

}