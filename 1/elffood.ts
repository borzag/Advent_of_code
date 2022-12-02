export class ElfFood
{
    allCalories: number[];
    public constructor(calories:number[]) 
    {
        this.allCalories = calories;
    }
    
    public getTotalCalories(): number 
    {
        let totalCalories:number = 0;
        this.allCalories.forEach((mealCalories: number) => {
            totalCalories = totalCalories + mealCalories;
        });
        return totalCalories;
    }
}

export * from "./elffood";
