import {ElfFood} from './elffood';
const fs = require('fs');
const readline = require('readline');
const nReadlines = require('n-readlines');

let elfsFood: ElfFood[] = [];
let elfCalories: number[] = [];
let maxCalories: number = 0;
let totalCalories: number[] = [];


// async function processLineByLine() : Promise<void>
// {
//     const fileStream = fs.createReadStream('data.txt');
    
//     const readLine = readline.createInterface(
//     {
//         input: fileStream,
//         crlfDelay: Infinity
//     });
        
//     for await (const line of readLine)
//     {
//         if (line == "")
//         {
//             let elf = new ElfFood(elfCalories);
//             if (maxCalories < elf.getTotalCalories())
//             {
//                 maxCalories = elf.getTotalCalories();
//                 console.log(`New max are: ${maxCalories}`);
//             }
//             elfsFood.push(elf);
//             elfCalories.splice(0);
//         }
//         else
//         {
//             let calories:number = parseInt(line);
//             if (calories == 58403)
//             // {console.log(`Now: ${calories}`);}
//             elfCalories.push(calories);
//         }
//     }
    

//     let sortedElfFood = elfsFood.sort((x, y) => x.getTotalCalories() - y.getTotalCalories())
//     for (let i = 0; i < sortedElfFood.length; i++) {
//         const element = sortedElfFood[i];
//         console.log(`${i}. Calories ${element.getTotalCalories()}`)
//     }
//     elfsFood.forEach(x => {
//         if (x.getTotalCalories() > maxCalories)
//         {
//                 maxCalories = x.getTotalCalories();
//                 console.log(`New max are: ${maxCalories}`);
//         }});
//     console.log(`Max calories by a elf are: ${maxCalories}`);
// }

// processLineByLine();


const textLines = new nReadlines('data.txt');

let line;
let elfNumber = 1;

while (line = textLines.next()) 
{
    // console.log(`Line ${lineNumber} has: ${line.toString('ascii')}`);
    // lineNumber++;
    
    if (line.length == 1)
    {
        AddElf();
    }
    else
    {
        let calories:number = parseInt(line.toString('ascii'));
        // if (calories == 58403)
        // {console.log(`Now: ${calories}`);}
        elfCalories.push(calories);
    }
}
AddElf();

let sortedElfFood = totalCalories.sort((x, y) => y - x)
for (let i = 0; i < sortedElfFood.length; i++) {
    const element = sortedElfFood[i];
    console.log(`${i}. Calories ${element}`)
}

let threeTotals = sortedElfFood[0] + sortedElfFood[1] + sortedElfFood[2];
console.log(`The one with max: ${sortedElfFood[0]} cal`)
console.log(`3 totals: ${threeTotals} cal`);


function AddElf() {
    let elf = new ElfFood(elfCalories);
    if (maxCalories < elf.getTotalCalories()) {
        maxCalories = elf.getTotalCalories();
        console.log(`New max are: ${maxCalories}`);
    }
    elfsFood.push(elf);
    console.log(`${elfNumber}. Elfs calories: ${elfsFood[elfNumber-1].getTotalCalories()}`);
    totalCalories.push(elf.getTotalCalories());
    elfCalories.splice(0);
    elfNumber++;
}
// elfsFood.forEach(x => {
    //     if (x.getTotalCalories() > maxCalories)
    //     {
        //         maxCalories = x.getTotalCalories();
        //     }});
        