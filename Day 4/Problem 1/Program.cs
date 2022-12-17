// See https://aka.ms/new-console-template for more information

int lineNumber = 1;
int overLapCount = 0;
foreach(var line in File.ReadLines(@"Data\inputdata.txt"))
{
    if (OverLaps(line))
    { 
        overLapCount++;
        Console.WriteLine($"Line: {lineNumber}. {line} overlaps");
    }
    lineNumber++;
}

Console.WriteLine($"There are totally {overLapCount} overlaps.");

static bool OverLaps(string parts)
{
    bool result = false;

    var ranges = parts.Split(',');
    var range1 = new Range(ranges[0]);
    var range2 = new Range(ranges[1]);

    result = range1.Overlaps(range2) || range2.Overlaps(range1);

    return result;
}

readonly struct Range
{
    public readonly int start;
    public readonly int end;

    public Range(string startEnd)
    {
        var parts = startEnd.Split('-');
        start = int.Parse(parts[0]);
        end = int.Parse(parts[1]);
    }

    internal bool Overlaps(Range rh)
    {
        return rh.start <= start && rh.end >= end;
    }
}