using System.Collections.Generic;
using System.Text.RegularExpressions;

internal class Program
{
        const int PosStack1 = 1;
        const int PosStack2 = 5;
        const int PosStack3 = 9;
        const int PosStack4 = 13;
        const int PosStack5 = 17;
        const int PosStack6 = 21;
        const int PosStack7 = 25;
        const int PosStack8 = 29;
        const int PosStack9 = 33;

    private static void Main(string[] args)
    {
        string initStack1, initStack2, initStack3, initStack4, initStack5, initStack6, initStack7, initStack8, initStack9;
        initStack1 = initStack2 = initStack3 = initStack4 = initStack5 = initStack6 = initStack7 = initStack8 = initStack9 = "";

        var lifoStacks = new List<LifoStack?>(10);
        
        string moveRegexPattern = "move ([0-9]{1,2}) from ([0-9]) to ([0-9])";
        int nrOfMoves = 0;
        foreach (string line in File.ReadLines(@"Data\inputdata.txt"))
        {
            if (!line.StartsWith("move"))
            {
                if (line.Trim().Equals(""))
                {
                    continue;
                }

                // Reached stack numbers 
                if (line.Contains("1   2   3"))//   4   5   6   7   8   9 "))
                {
                    lifoStacks.Add(null); //Not used 
                    lifoStacks.Add(new LifoStack(initStack1.Trim()));
                    lifoStacks.Add(new LifoStack(initStack2.Trim())); 
                    lifoStacks.Add(new LifoStack(initStack3.Trim()));
                    lifoStacks.Add(new LifoStack(initStack4.Trim()));
                    lifoStacks.Add(new LifoStack(initStack5.Trim()));
                    lifoStacks.Add(new LifoStack(initStack6.Trim()));
                    lifoStacks.Add(new LifoStack(initStack7.Trim()));
                    lifoStacks.Add(new LifoStack(initStack8.Trim()));
                    lifoStacks.Add(new LifoStack(initStack9.Trim()));
                    continue;
                }
                initStack1 += line.Substring(PosStack1, 1);
                initStack2 += line.Substring(PosStack2, 1);
                initStack3 += line.Substring(PosStack3, 1);
                initStack4 += line.Substring(PosStack4, 1);
                initStack5 += line.Substring(PosStack5, 1);
                initStack6 += line.Substring(PosStack6, 1);
                initStack7 += line.Substring(PosStack7, 1);
                initStack8 += line.Substring(PosStack8, 1);
                initStack9 += line.Substring(PosStack9, 1);
            }
            else
            {
                var moveMatches = Regex.Matches(line, moveRegexPattern);
                int itemCount = int.Parse(moveMatches[0].Groups[1].Value);
                int fromStack = int.Parse(moveMatches[0].Groups[2].Value);
                int toStack = int.Parse(moveMatches[0].Groups[3].Value);

                for(int i = 1; i <= itemCount; i++)
                {
                    char item = lifoStacks[fromStack].Pop();
                    lifoStacks[toStack].Add(item);
                }
                nrOfMoves++;
            }
        }

        string topItems = "";
        foreach(var lifo in lifoStacks)
        {
            if (lifo == null) { continue; }
            topItems += lifo.ReadTopItem();
        }
        Console.WriteLine($"The top items from each are {topItems}.");
        Console.WriteLine($"Total moves handled {nrOfMoves}.");

    }
}

public class LifoStack
{
    private readonly Stack<char> lifo;

    public LifoStack()
    {
        lifo = new Stack<char>();
    }

    public LifoStack(string initTopBotton) 
    {
        lifo = new Stack<char>(initTopBotton.Reverse());
    }

    public void Add(char crate)
    {
        lifo.Push(crate);
    }

    public char Pop()
    {
        return lifo.Pop();
    }

    public char ReadTopItem()
    {
        if (lifo.Count == 0)
        {
            return new char();
        }
        return lifo.Peek();
    }
}